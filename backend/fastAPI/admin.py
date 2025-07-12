from fastapi import APIRouter, HTTPException
from bson import ObjectId
from db import (
    collection as users_collection,
    words_collection,
    sentences_collection
)
from mcq_routes import mcq_collection
from typing import List, Dict
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/admin", tags=["Admin"])

# ------------------- User Section -------------------

def user_serializer(user):
    return {
        "id": str(user["_id"]),
        "fullName": user["fullName"],
        "username": user["username"],
        "email": user["email"],
        "phoneNumber": user["phoneNumber"],
        "countryCode": user["countryCode"],
        "gender": user["gender"],
        "nid": user["nid"],
        "dob": datetime.fromtimestamp(user["dob"]["$date"]["$numberLong"] / 1000).strftime("%Y-%m-%d")
        if isinstance(user.get("dob"), dict) else "",
        "is_premium": user.get("is_premium", False)
    }

class UserOut(BaseModel):
    id: str
    fullName: str
    username: str
    email: str
    phoneNumber: str
    countryCode: str
    gender: str
    nid: str
    dob: str
    is_premium: bool

@router.get("/users", response_model=List[UserOut])
async def get_all_users(skip: int = 0, limit: int = 1):
    cursor = users_collection.find().skip(skip).limit(limit)
    users = await cursor.to_list(length=limit)
    return [user_serializer(user) for user in users]

@router.get("/users/search", response_model=UserOut)
async def get_user_by_username(username: str):
    user = await users_collection.find_one({"username": username})
    if user:
        return user_serializer(user)
    raise HTTPException(status_code=404, detail="User not found")

# ------------------- Word Section -------------------

class WordIn(BaseModel):
    english_word: str
    image_link: str
    translations: Dict[str, str]
    englishMeaning: str

    class Config:
        orm_mode = True

def word_serializer(word):
    return {
        "id": str(word["_id"]),
        "english_word": word["english_word"],
        "translations": word["translations"],
        "image_link": word["image_link"],
        "englishMeaning": word["englishMeaning"]
    }

@router.post("/words", response_model=WordIn)
async def insert_word(word: WordIn):
    word_dict = word.dict()
    result = await words_collection.insert_one(word_dict)
    inserted_word = await words_collection.find_one({"_id": result.inserted_id})
    if inserted_word:
        return word_serializer(inserted_word)
    raise HTTPException(status_code=500, detail="Failed to insert word")

# ------------------- MCQ Section -------------------

class MCQOption(BaseModel):
    options: List[str]
    answer_index: int

class MCQModel(BaseModel):
    question: str
    languages: Dict[str, MCQOption]

@router.post("/mcq", response_model=Dict)
async def insert_mcq(mcq: MCQModel):
    mcq_dict = mcq.dict()
    result = await mcq_collection.insert_one(mcq_dict)
    inserted_mcq = await mcq_collection.find_one({"_id": result.inserted_id})
    if inserted_mcq:
        inserted_mcq["id"] = str(inserted_mcq["_id"])
        inserted_mcq.pop("_id", None)
        return inserted_mcq
    raise HTTPException(status_code=500, detail="Failed to insert MCQ")

# ------------------- Sentence Section -------------------

class SentenceModel(BaseModel):
    english: str
    spanish: str
    german: str
    arabic: str
    french: str
    chinese: str

@router.post("/sentences", response_model=Dict)
async def insert_sentence(sentence: SentenceModel):
    sentence_dict = sentence.dict()
    result = await sentences_collection.insert_one(sentence_dict)
    inserted_sentence = await sentences_collection.find_one({"_id": result.inserted_id})
    if inserted_sentence:
        inserted_sentence["id"] = str(inserted_sentence["_id"])
        inserted_sentence.pop("_id", None)
        return inserted_sentence
    raise HTTPException(status_code=500, detail="Failed to insert sentence")
