from pymongo import MongoClient

# Replace with your MongoDB Atlas connection string
MONGO_URI = "mongodb+srv://abdullah:abdullah6789@cluster1.syfkfm2.mongodb.net/?retryWrites=true&w=majority"

def insert_sentences():
    client = MongoClient(MONGO_URI)
    db = client.langappdb  # Replace with your DB name
    sentences_collection = db.sentences

    # List of sentence documents (e.g., from the JSON file)
    sentence_docs = [
        {
            "english": "The dog runs in the park",
            "spanish": "El perro corre en el parque",
            "german": "Der Hund läuft im Park",
            "arabic": "الكلب يجري في الحديقة",
            "french": "Le chien court dans le parc",
            "chinese": "狗在公园里跑"
        },
        {
            "english": "I read a book every day",
            "spanish": "Leo un libro todos los días",
            "german": "Ich lese jeden Tag ein Buch",
            "arabic": "أقرأ كتابًا كل يوم",
            "french": "Je lis un livre tous les jours",
            "chinese": "我每天读一本书"
        },
        {
            "english": "She sings a beautiful song",
            "spanish": "Ella canta una canción hermosa",
            "german": "Sie singt ein schönes Lied",
            "arabic": "هي تغني أغنية جميلة",
            "french": "Elle chante une belle chanson",
            "chinese": "她唱了一首美丽的歌"
        },
        {
            "english": "We play soccer with friends",
            "spanish": "Jugamos fútbol con amigos",
            "german": "Wir spielen Fußball mit Freunden",
            "arabic": "نلعب كرة القدم مع الأصدقاء",
            "french": "Nous jouons au football avec des amis",
            "chinese": "我们和朋友一起踢足球"
        },
        {
            "english": "The sun shines brightly today",
            "spanish": "El sol brilla intensamente hoy",
            "german": "Die Sonne scheint heute hell",
            "arabic": "الشمس تشرق بقوة اليوم",
            "french": "Le soleil brille fort aujourd'hui",
            "chinese": "今天太阳闪耀得很明亮"
        }
    ]

    # Insert multiple documents
    result = sentences_collection.insert_many(sentence_docs)
    print(f"Inserted {len(result.inserted_ids)} documents with IDs: {result.inserted_ids}")

    # Close the client connection
    client.close()

if __name__ == "__main__":
    insert_sentences()