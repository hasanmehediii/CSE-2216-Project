# db.py
import os
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

load_dotenv()

MONGO_DETAILS = os.getenv("MONGODB_URI")
DATABASE_NAME = os.getenv("DATABASE_NAME")

client = AsyncIOMotorClient(MONGO_DETAILS)
database = client[DATABASE_NAME]
collection = database["users"]
words_collection = database["words"]
videos_collection = database["videos"]
sentences_collection = database["sentences"]
