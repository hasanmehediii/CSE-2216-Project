from fastapi import APIRouter, HTTPException
from db import database

mcq_router = APIRouter()
mcq_collection = database["mcqs"]

@mcq_router.get("/mcq/{language}")
async def get_mcqs_by_language(language: str, skip: int = 0):
    supported_languages = ["spanish", "german", "chinese", "arabic", "french"]

    if language.lower() not in supported_languages:
        raise HTTPException(status_code=400, detail="Unsupported language")

    if skip < 0:
        raise HTTPException(status_code=400, detail="Skip parameter must be non-negative")

    # Debug: Check collection existence and document count
    collection_names = await database.list_collection_names()
    print(f"Collections in database: {collection_names}")
    doc_count = await mcq_collection.count_documents({"languages." + language.lower(): {"$exists": True}})
    print(f"Documents in mcq_questions for {language}: {doc_count}")

    # Check if there are enough questions for the requested skip
    if skip >= doc_count:
        raise HTTPException(status_code=404, detail=f"Not enough questions for {language} at skip {skip}")

    # Fetch questions with pagination (skip and limit)
    cursor = mcq_collection.find({"languages." + language.lower(): {"$exists": True}}).skip(skip).limit(10)
    results = await cursor.to_list(length=10)
    print(f"Queried documents (skip={skip}, limit=10): {results}")  # Debug

    mcqs = []
    for q in results:
        language_data = q.get("languages", {}).get(language.lower())
        print(f"Language data for {language}: {language_data}")  # Debug
        if not language_data or not language_data.get("options") or language_data.get("answer_index") is None:
            continue
        mcqs.append({
            "question": q["question"].replace("{selected_language}", language.capitalize()),
            "options": language_data["options"],
            "answer_index": int(language_data["answer_index"])
        })

    if not mcqs:
        raise HTTPException(status_code=404, detail=f"No valid questions found for {language} at skip {skip}")

    print(f"Returning MCQs (skip={skip}): {mcqs}")  # Debug
    return {"language": language, "questions": mcqs}