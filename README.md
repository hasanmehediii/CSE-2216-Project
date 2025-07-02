# 🌐 LangBuddy – Language Learning App

LangBuddy is a cross-platform language learning application. This was built by **Team Quattro** for the 2nd year 2nd semester application development final project. This has been made by using **Flutter** for the frontend, **FastAPI** for the backend, and **MongoDB** for the database. The app offers an engaging and intuitive way to learn new languages and also good for test yourself by attend in exams.

## 📱 Features

- 🔐 User Authentication (Signup/Login)
- 📚 Vocabulary Quizzes & Flashcards
- 📈 Learning Progress Tracker
- 🎯 Personalized Learning Path
- 🌍 Support for Multiple Languages
- ☁️ Data stored in MongoDB (Cloud/Local)
- 📦 RESTful API powered by FastAPI

## 🧰 Tech Stack

| Layer                          | Technology         |
|--------------------------------|--------------------|
| Frontend                       | Flutter            |
| Backend                        | FastAPI (Python)   |
| Database                       | MongoDB            |
| ------------------------------ | ------------------ |

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (3.x+)
- Python 3.9+
- MongoDB (local or cloud like MongoDB Atlas)

### 🔧 Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create a virtual environment:
    ```bash
    python -m venv venv
    source venv/bin/activate  # For Windows: venv\Scripts\activate
    pip install -r requirements.txt
   ```

3. Run backend server:
    ```bash
   uvicorn main:app --reload
   ```
   
4. Run frontend:
    ```bash
   cd frontend
   flutter pub get
   flutter run
    ```

## 🚀 Future Improvements
    - 🌐 Web version using Flutter Web
    - 🧠 AI tutor with OpenAI API
    - 📥 Downloadable lessons and offline mode
    - 🧑‍🏫 Tutor marketplace and booking system
    - 🎙️ Speech recognition for pronunciation evaluation


## 🙌 Contributors:
1. Abdullah Ibne Masood (03)
2. Ibna Afra Roza (16)
3. Nafisha Akter Tuli (40)
4. Mehedi Hasan (22)