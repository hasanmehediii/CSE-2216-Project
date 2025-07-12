from fastapi import APIRouter, HTTPException
from db import sentences_collection
import random

router = APIRouter(prefix="/sentence-builder", tags=["Sentence Builder"])

@router.get("/random-sentence")
async def get_random_sentence():
    # Fetch all sentence documents or use a filter or aggregation
    sentences_cursor = sentences_collection.find() # Or your sentence collection
    sentences = await sentences_cursor.to_list(length=100)

    if not sentences:
        raise HTTPException(status_code=404, detail="No sentences found")

    selected = random.choice(sentences)

    # Remove MongoDB _id for clean JSON response
    selected.pop("_id", None)

    return selected
