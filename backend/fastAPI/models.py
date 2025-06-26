from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

# Pydantic model for user registration (signup)
class User(BaseModel):
    fullName: str
    username: str
    email: EmailStr
    phoneNumber: str
    countryCode: str
    gender: Optional[str] = None
    nid: str
    dob: datetime
    password: str
    is_premium: bool = False  # Add is_premium field with default value False

    class Config:
        orm_mode = True  # Ensure that Pydantic models can be converted to/from MongoDB documents

# Pydantic model for user login (only email and password)
class UserLogin(BaseModel):
    email: EmailStr
    password: str

# Pydantic model for the video data
class Video(BaseModel):
    title: str
    videoId: str

    class Config:
        orm_mode = True  # Ensure that Pydantic models can be converted to/from MongoDB documents

# Pydantic model for video data by language (Spanish, German, etc.)
class VideoLanguage(BaseModel):
    language: str
    videos: list[Video]  # A list of Video objects

    class Config:
        orm_mode = True  # Ensure that Pydantic models can be converted to/from MongoDB documents
