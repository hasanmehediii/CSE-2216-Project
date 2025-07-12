from pymongo import MongoClient

# Replace with your actual MongoDB Atlas connection string
mongo_uri = "mongodb+srv://abdullah:abdullah6789@cluster1.syfkfm2.mongodb.net/?retryWrites=true&w=majority"

# Connect to MongoDB
client = MongoClient(mongo_uri)

# Choose your database and collection
db = client["langappdb"]
collection = db["videos"]
document = {
    "language": "Chinese",
    "videos": [
        {"title": "Day 1", "videoId": "McZW0iDsZns"},
        {"title": "Day 2", "videoId": "WyehfFj72zY"},
        {"title": "Day 3", "videoId": "v_VUa80gMf0"},
        {"title": "Day 4", "videoId": "Gql5mU0OKB8"},
        {"title": "Day 5", "videoId": "oqSof_8euUg"},
        {"title": "Day 6", "videoId": "rGFW2nf8i40"},
        {"title": "Day 7", "videoId": "JgYfUMa5S6k"},
        {"title": "Day 8", "videoId": "nHDQm4NXq7Q"},
        {"title": "Day 9", "videoId": "B07gP_Flwbs"},
        {"title": "Day 10", "videoId": "dXj0hvON1y4"}
    ]
}

# Fix _id format for MongoDB
from bson import ObjectId

# Insert the document
collection.insert_one(document)

print("Document inserted successfully!")
