from fastapi import APIRouter, HTTPException
from bson import ObjectId
from db import collection as users_collection, words_collection
from typing import List, Dict
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/admin", tags=["Admin"])

# Utility to convert MongoDB ObjectId and Date for users
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

# Pydantic model for returning users
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


# Endpoint to get all users
@router.get("/users", response_model=List[UserOut])
async def get_all_users(skip: int = 0, limit: int = 1):
    cursor = users_collection.find().skip(skip).limit(limit)
    users = await cursor.to_list(length=limit)
    return [user_serializer(user) for user in users]


# Endpoint to search a user by username
@router.get("/users/search", response_model=UserOut)
async def get_user_by_username(username: str):
    user = await users_collection.find_one({"username": username})
    if user:
        return user_serializer(user)
    raise HTTPException(status_code=404, detail="User not found")


# --- Word Insertion Section ---
class WordIn(BaseModel):
    english_word: str
    image_link: str
    translations: Dict[str, str]
    englishMeaning: str

    class Config:
        orm_mode = True

# Utility to convert MongoDB ObjectId for words
def word_serializer(word):
    return {
        "id": str(word["_id"]),
        "english_word": word["english_word"],
        "translations": word["translations"],
        "image_link": word["image_link"],
        "englishMeaning": word["englishMeaning"]
    }

# Insert a word into the database
@router.post("/words", response_model=WordIn)
async def insert_word(word: WordIn):
    # Create a dictionary to insert into the collection
    word_dict = word.dict()

    # Insert the word into the MongoDB words_collection
    result = await words_collection.insert_one(word_dict)

    # Return the inserted word
    inserted_word = await words_collection.find_one({"_id": result.inserted_id})

    if inserted_word:
        return word_serializer(inserted_word)
    else:
        raise HTTPException(status_code=500, detail="Failed to insert word")
