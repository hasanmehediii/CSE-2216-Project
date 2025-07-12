from pymongo import MongoClient

# Replace with your actual MongoDB Atlas connection string
mongo_uri = "mongodb+srv://abdullah:abdullah6789@cluster1.syfkfm2.mongodb.net/?retryWrites=true&w=majority"

# Connect to MongoDB
client = MongoClient(mongo_uri)

# Choose your database and collection
db = client["langappdb"]
collection = db["videos"]

# Document to insert
document = {
    "language": "Arabic",
    "videos": [
        {"title": "Day 1", "videoId": "8_60iWXl7dw"},
        {"title": "Day 2", "videoId": "XJzH4rzPsww"},
        {"title": "Day 3", "videoId": "NapGLT3WFX8"},
        {"title": "Day 4", "videoId": "X1mC1XY65Kc"},
        {"title": "Day 5", "videoId": "DZ8j2fOHJns"},
        {"title": "Day 6", "videoId": "CtWcqmlANm8"},
        {"title": "Day 7", "videoId": "vEfd47I7R68"},
        {"title": "Day 8", "videoId": "PB1XeuwNfvs"},
        {"title": "Day 9", "videoId": "pZH7toJjGcc"},
        {"title": "Day 10", "videoId": "dinQIb4ZFXY"}
    ]
}

# Fix _id format for MongoDB
from bson import ObjectId

# Insert the document
collection.insert_one(document)

print("Document inserted successfully!")









