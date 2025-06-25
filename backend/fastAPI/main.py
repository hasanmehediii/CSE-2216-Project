from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from db import client, words_collection  # Ensure your MongoDB collection for words is correctly imported
from pydantic import BaseModel
from typing import Dict

app = FastAPI()

# Add CORS middleware
origins = [
    "*"  # Allow all origins for now
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the Word Pydantic model to match MongoDB document structure
class Word(BaseModel):
    english_word: str
    image_link: str
    translations: Dict[str, str]
    englishMeaning: str

    class Config:
        orm_mode = True

@app.get("/words", response_model=list[Word])
async def get_words():
    words_cursor = words_collection.find()
    words = await words_cursor.to_list(length=100)

    # Add englishMeaning dynamically from english_word if it's missing in the DB
    for word in words:
        word["englishMeaning"] = word.get("english_word", "")  # Use english_word as englishMeaning

    return words

@app.on_event("startup")
async def startup_event():
    try:
        await client.admin.command('ping')
        print("Connected to MongoDB!")
    except Exception as e:
        print("Could not connect to MongoDB:", e)
