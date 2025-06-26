from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

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

class UserLogin(BaseModel):
    email: EmailStr
    password: str