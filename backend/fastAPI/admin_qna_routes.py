# admin_qna_routes.py

from fastapi import APIRouter, HTTPException, Body
from pydantic import BaseModel
from bson import ObjectId
from datetime import datetime
from db import database

admin_qna_router = APIRouter()
qna_collection = database["qna"]

# ----------------------------
# Pydantic Model for Answer Input
# ----------------------------

class AnswerInput(BaseModel):
    answer: str

# ----------------------------
# Admin: Update Answer for a QnA Entry
# ----------------------------

@admin_qna_router.put("/qna/answer/{qna_id}")
async def update_qna_answer(qna_id: str, input_data: AnswerInput):
    try:
        obj_id = ObjectId(qna_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid QnA ID")

    qna_entry = await qna_collection.find_one({"_id": obj_id})
    if not qna_entry:
        raise HTTPException(status_code=404, detail="QnA entry not found")

    update_result = await qna_collection.update_one(
        {"_id": obj_id},
        {
            "$set": {
                "answer": input_data.answer.strip(),
                "answeredBy": "admin@gmail.com",  # hardcoded admin
                "answeredAt": datetime.utcnow()
            }
        }
    )

    if update_result.modified_count == 0:
        raise HTTPException(status_code=500, detail="Failed to update answer")

    return {"message": "Answer updated successfully"}


# ----------------------------
# Admin: Fetch ALL QnAs (answered + unanswered)
# ----------------------------

@admin_qna_router.get("/admin/qna/all")
async def get_all_qna_entries():
    qna_cursor = qna_collection.find().sort("timestamp", -1)
    qna_list = []
    async for qna in qna_cursor:
        qna_list.append({
            "id": str(qna["_id"]),
            "question": qna.get("question", ""),
            "answer": qna.get("answer"),
            "askedBy": qna.get("askedBy", ""),
            "answeredBy": qna.get("answeredBy", ""),
            "answeredAt": qna.get("answeredAt").isoformat() if qna.get("answeredAt") else None,
            "timestamp": qna.get("timestamp").isoformat() if qna.get("timestamp") else None,
        })
    return qna_list
