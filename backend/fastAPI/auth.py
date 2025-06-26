from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel
from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta
from fastapi.security import OAuth2PasswordBearer
from db import collection  # MongoDB collection for users
from models import User, UserLogin  # Pydantic models for User and UserLogin

# Initialize the FastAPI router
auth_router = APIRouter()

# Password hashing setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# JWT settings
SECRET_KEY = "B24TGRWvKBCIHzHKJdhZocdMKhZO0ovAi0nuydx2PAQ"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30  # You can make this configurable in your .env file

# OAuth2PasswordBearer is used to handle authentication with JWT tokens
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# Function to hash passwords
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

# Function to verify passwords
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

# Function to create JWT access token
def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# Signup route to create a new user
@auth_router.post("/signup")
async def signup(user: User):
    existing_user = await collection.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Hash the password before saving it to the database
    hashed_pwd = hash_password(user.password)
    user_dict = user.dict()
    user_dict["password"] = hashed_pwd

    # Insert the user document into the MongoDB collection
    await collection.insert_one(user_dict)
    return {"message": "User created successfully"}

# Login route to authenticate users and return JWT token
@auth_router.post("/login")
async def login(user: UserLogin):
    existing_user = await collection.find_one({"email": user.email})
    if not existing_user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    # Verify the password using the hashed password stored in the database
    if not verify_password(user.password, existing_user["password"]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    # Create and return JWT access token
    access_token = create_access_token(data={"sub": existing_user["email"]},
                                       expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    return {"access_token": access_token, "token_type": "bearer"}

# Function to get the current logged-in user based on the JWT token
async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        # Decode the JWT token to extract the email (subject) from the payload
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    # Retrieve the user from the database based on the email in the token
    user = await collection.find_one({"email": email})
    if user is None:
        raise credentials_exception
    return user

# Protected route that requires authentication (JWT token)
@auth_router.get("/protected")
async def protected_route(current_user: dict = Depends(get_current_user)):
    return {"message": f"Hello, {current_user['email']}! You have accessed a protected route."}

# Route to fetch user profile information (excluding sensitive data like password)
@auth_router.get("/user/profile")
async def get_user_profile(current_user: dict = Depends(get_current_user)):
    # Exclude sensitive fields like password from the user profile
    user_profile = {
        "fullName": current_user["fullName"],
        "username": current_user["username"],
        "email": current_user["email"],
        "phoneNumber": current_user["phoneNumber"],
        "countryCode": current_user["countryCode"],
        "gender": current_user.get("gender"),
        "nid": current_user["nid"],
        "dob": current_user["dob"].isoformat(),  # Convert datetime to string format
        "is_premium": current_user.get("is_premium", False)  # Default to False if not set
    }
    return user_profile

# Pydantic model for updating the user's premium status
class PremiumUpdate(BaseModel):
    is_premium: bool

# Route to update user's premium status
@auth_router.patch("/user/premium")
async def update_premium_status(update: PremiumUpdate, current_user: dict = Depends(get_current_user)):
    # Update the premium status in the database
    result = await collection.update_one(
        {"email": current_user["email"]},
        {"$set": {"is_premium": update.is_premium}}
    )
    if result.modified_count == 0:
        raise HTTPException(status_code=400, detail="Failed to update premium status")
    return {"message": f"Premium status updated to {update.is_premium}"}
