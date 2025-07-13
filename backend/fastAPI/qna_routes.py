# qna_routes.py

from fastapi import APIRouter, Depends, HTTPException, Body
from pydantic import BaseModel
from typing import Optional
from bson import ObjectId
from datetime import datetime
from auth import get_current_user
from db import database

qna_router = APIRouter()
qna_collection = database["qna"]

# ----------------------------
# Pydantic Models
# ----------------------------

class QuestionInput(BaseModel):
    question: str

# ----------------------------
# Ask Question (User)
# ----------------------------

@qna_router.post("/qna/ask")
async def ask_question(
        input_data: QuestionInput,
        current_user: dict = Depends(get_current_user)
):
    new_question = {
        "question": input_data.question.strip(),
        "askedBy": current_user["email"],
        "timestamp": datetime.utcnow(),
        "answer": None,
        "answeredBy": None,
        "answeredAt": None
    }
    result = await qna_collection.insert_one(new_question)
    return {"message": "Question submitted", "id": str(result.inserted_id)}

# ----------------------------
# Get Answered Questions
# ----------------------------

@qna_router.get("/qna/all")
async def get_answered_qna():
    qna_cursor = qna_collection.find({"answer": {"$ne": None}}).sort("answeredAt", -1)
    qna_list = []
    async for q in qna_cursor:
        qna_list.append({
            "id": str(q["_id"]),
            "question": q["question"],
            "answer": q["answer"],
            "askedBy": q.get("askedBy", ""),
            "answeredBy": q.get("answeredBy", ""),
            "answeredAt": q.get("answeredAt", "").isoformat() if q.get("answeredAt") else None
        })
    return qna_list
