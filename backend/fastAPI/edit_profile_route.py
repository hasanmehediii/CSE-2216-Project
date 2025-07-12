from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from db import collection
from auth import get_current_user

router = APIRouter(prefix="/profile", tags=["User Profile"])

class UserProfileUpdate(BaseModel):
    fullName: Optional[str] = None
    username: Optional[str] = None
    phoneNumber: Optional[str] = None
    countryCode: Optional[str] = None
    gender: Optional[str] = None
    dob: Optional[datetime] = None

@router.put("/edit")
async def update_profile(update_data: UserProfileUpdate, current_user: dict = Depends(get_current_user)):
    update_dict = {k: v for k, v in update_data.dict().items() if v is not None}

    if not update_dict:
        raise HTTPException(status_code=400, detail="No valid fields to update")

    result = await collection.update_one({"email": current_user["email"]}, {"$set": update_dict})

    if result.modified_count == 0:
        raise HTTPException(status_code=400, detail="No changes were made")

    return {"message": "Profile updated successfully"}
