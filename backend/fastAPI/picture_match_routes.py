from fastapi import APIRouter, Query
from typing import List
from db import words_collection
from pydantic import BaseModel
import random

router = APIRouter()

class PictureMatchWord(BaseModel):
    word: str
    image_link: str

@router.get("/picture-match", response_model=List[PictureMatchWord])
async def get_picture_match_words(
        lang: str = Query(..., description="Target language for translation, e.g., spanish, french")
):
    # Get all words that have the given language in translations
    words_cursor = words_collection.find({f"translations.{lang}": {"$exists": True}})
    words = await words_cursor.to_list(length=100)

    if len(words) < 6:
        raise Exception("Not enough words available for picture match.")

    # Pick 6 random items (5 correct + 1 distractor)
    selected = random.sample(words, 6)

    # Pick 5 for matching, 1 as distractor
    result = [
        PictureMatchWord(
            word=w["translations"][lang],
            image_link=w["image_link"]
        ) for w in selected
    ]

    return result
