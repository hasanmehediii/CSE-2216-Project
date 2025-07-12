from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr
from datetime import datetime, timedelta
from db import collection  # users collection
import random
import hashlib
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


def send_reset_email(to_email: str, reset_code: str):
    smtp_server = "smtp.gmail.com"
    smtp_port = 587

    smtp_user = "frenchbreads53@gmail.com"           # <-- your gmail here
    smtp_password = "ktpz xsjc pmvq mqqy"          # <-- your app password here

    msg = MIMEMultipart()
    msg['From'] = smtp_user
    msg['To'] = to_email
    msg['Subject'] = "Password Reset Code"

    body = f"Your password reset code is: {reset_code}"
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(smtp_user, smtp_password)
        server.send_message(msg)
        server.quit()
        print(f"Reset email sent to {to_email}")
    except Exception as e:
        print(f"Failed to send email: {e}")



router = APIRouter(prefix="/auth", tags=["Password Reset"])



# In-memory or DB-backed storage for reset codes (here we store in user doc)
RESET_CODE_EXPIRY_MINUTES = 30

class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class ResetPasswordRequest(BaseModel):
    email: EmailStr
    reset_code: str
    new_password: str

def hash_code(code: str) -> str:
    return hashlib.sha256(code.encode()).hexdigest()

@router.post("/forgot-password")
async def forgot_password(request: ForgotPasswordRequest):
    user = await collection.find_one({"email": request.email})
    # Always return success to avoid user enumeration
    if not user:
        return {"message": "If this email exists, a reset code was sent."}

    # Generate 6-digit numeric reset code
    reset_code = f"{random.randint(100000, 999999)}"
    hashed_code = hash_code(reset_code)
    expiry = datetime.utcnow() + timedelta(minutes=RESET_CODE_EXPIRY_MINUTES)

    # Save hashed reset code and expiry in user doc
    await collection.update_one(
        {"email": request.email},
        {"$set": {"reset_code": hashed_code, "reset_code_expiry": expiry}}
    )

    # TODO: Integrate real email sending here
    send_reset_email(request.email, reset_code)


    return {"message": "If this email exists, a reset code was sent."}

@router.post("/reset-password")
async def reset_password(request: ResetPasswordRequest):
    user = await collection.find_one({"email": request.email})
    if not user:
        raise HTTPException(status_code=400, detail="Invalid email or reset code")

    stored_hashed_code = user.get("reset_code")
    expiry = user.get("reset_code_expiry")

    if not stored_hashed_code or not expiry:
        raise HTTPException(status_code=400, detail="No reset code requested")

    if datetime.utcnow() > expiry:
        raise HTTPException(status_code=400, detail="Reset code expired")

    if hash_code(request.reset_code) != stored_hashed_code:
        raise HTTPException(status_code=400, detail="Invalid reset code")

    # Hash new password before saving
    from auth import hash_password  # reuse your existing hash function
    hashed_new_password = hash_password(request.new_password)

    # Update user password and remove reset code fields
    await collection.update_one(
        {"email": request.email},
        {"$set": {"password": hashed_new_password}, "$unset": {"reset_code": "", "reset_code_expiry": ""}}
    )

    return {"message": "Password has been reset successfully"}
