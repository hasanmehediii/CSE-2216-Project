from fastapi import APIRouter, HTTPException
from db import videos_collection  # Ensure your MongoDB collection for videos is correctly imported
from pydantic import BaseModel
from typing import List

# Define Pydantic models for Video and VideoLanguage
class Video(BaseModel):
    title: str
    videoId: str

    class Config:
        orm_mode = True  # Ensure that Pydantic models can be converted to/from MongoDB documents

class VideoLanguage(BaseModel):
    language: str
    videos: List[Video]

# Create the router for video routes
router = APIRouter()

# Endpoint to fetch video data based on the selected language
@router.get("/videos/{language}", response_model=VideoLanguage)
async def get_videos(language: str):
    # Fetch the video data from the MongoDB collection based on the requested language
    document = await videos_collection.find_one({"language": language})

    if not document:
        raise HTTPException(status_code=404, detail="Videos not found for this language")

    return VideoLanguage(language=document["language"], videos=document["videos"])
