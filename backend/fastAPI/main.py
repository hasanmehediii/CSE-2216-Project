from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from auth import auth_router  # Import the router that handles /signup and /login
from video_routes import router as video_router  # Import the video routes router
from db import client, words_collection  # Ensure your MongoDB collection for words is correctly imported
from pydantic import BaseModel
from typing import Dict

# Initialize FastAPI app
app = FastAPI()

# Add CORS middleware to allow cross-origin requests
origins = [
    "*"  # Allow all origins for now (you can change this in production)
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

# Include the auth router for login and signup
app.include_router(auth_router)

# Include the video routes for fetching videos based on language
app.include_router(video_router)

# Define the Word Pydantic model to match MongoDB document structure
class Word(BaseModel):
    english_word: str
    image_link: str
    translations: Dict[str, str]
    englishMeaning: str

    class Config:
        orm_mode = True  # Ensure that Pydantic models can be converted to/from MongoDB documents

# Endpoint to get words from MongoDB
@app.get("/words", response_model=list[Word])
async def get_words():
    words_cursor = words_collection.find()
    words = await words_cursor.to_list(length=100)

    # Add englishMeaning dynamically from english_word if it's missing in the DB
    for word in words:
        word["englishMeaning"] = word.get("english_word", "")  # Use english_word as englishMeaning

    return words

# Event to test MongoDB connection on application startup
@app.on_event("startup")
async def startup_event():
    try:
        await client.admin.command('ping')
        print("Connected to MongoDB!")
    except Exception as e:
        print("Could not connect to MongoDB:", e)
