from pymongo import MongoClient

# Replace with your actual MongoDB Atlas connection string
mongo_uri = "mongodb+srv://abdullah:abdullah6789@cluster1.syfkfm2.mongodb.net/?retryWrites=true&w=majority"

# Connect to MongoDB
client = MongoClient(mongo_uri)

# Choose your database and collection
db = client["langappdb"]
collection = db["videos"]
document = {
    "language": "French",
    "videos": [
        {"title": "Day 1", "videoId": "1BSoGSXZAig"},
        {"title": "Day 2", "videoId": "QKtzi6xbC4U"},
        {"title": "Day 3", "videoId": "RxCR3g6aYJ0"},
        {"title": "Day 4", "videoId": "cctA8tkRY3M"},
        {"title": "Day 5", "videoId": "tbJ8JDR8dyE"},
        {"title": "Day 6", "videoId": "So-SShqBfn8"},
        {"title": "Day 7", "videoId": "Ez-RtSEt4yc"},
        {"title": "Day 8", "videoId": "YlgELdnLL7w"},
        {"title": "Day 9", "videoId": "wOgaV7UDx8E"},
        {"title": "Day 10", "videoId": "Sk6YQynZ1h8"}
    ]
}

# Fix _id format for MongoDB
from bson import ObjectId

# Insert the document
collection.insert_one(document)

print("Document inserted successfully!")