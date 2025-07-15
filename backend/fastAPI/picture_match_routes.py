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

    words_cursor = words_collection.find({f"translations.{lang}": {"$exists": True}})
    words = await words_cursor.to_list(length=100)

    if len(words) < 5:
        raise Exception("Not enough words available for picture match.")


    selected = random.sample(words, 5)


    result = [
        PictureMatchWord(
            word=w["translations"][lang],
            image_link=w["image_link"]
        ) for w in selected
    ]

    return result
