# 🌐 LangMastero – Language Learning App

LangMastero is a cross-platform language learning application. This was built by **Team Quattro** for the 2nd year 2nd semester application development final project. This has been made by using **Flutter** for the frontend, **FastAPI** for the backend, and **MongoDB** for the database. The app offers an engaging and intuitive way to learn new languages and also good for test yourself by attend in exams.

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


## **Screenshots 📸**

| ![Start](readme/welcome.jpg) | ![Login](readme/login.jpg) |
|:-------------------:|:------------------:|
| _Welcome Screen._ | _Login Screen._ |

| ![Home](readme/home.jpg) | ![Pro](readme/getpro.jpg) |
|:-------------------:|:------------------:|
| _Home Screen._ | _Pro purchase Screen._ |

| ![Video](readme/video.jpg) | ![Location](readme/location.jpg) |
|:-------------------:|:------------------:|
| _Recorded Lecture Screen._ | _Offline branch Screen._ |

| ![MCQ](readme/mcq.jpg) | ![Vocabulary](readme/vocabulary.jpg) |
|:-------------------:|:------------------:|
| _MCQ exam Screen._ | _Vocabulary Screen._ |

--- 
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
### 👤 Abdullah Ibne Masood
- **Email**: [abdullahibnemasoodr@gmail.com](mailto:abdullahibnemasoodr@gmail.com)
- **GitHub**: [AbdullahIbneMasoodRegan](https://github.com/AbdullahIbneMasoodRegan)

### 👤 Ibna Afra Roza
- **Email**: [ibnaafra-2022015891@cs.du.ac.bd](mailto:ibnaafra-2022015891@cs.du.ac.bd)
- **GitHub**: [Roza-fail](https://www.github.com/Roza-fail)

### 👤 Nafisha Akhter
- **Email**: [nafisha3558@gmail.com](mailto:nafisha3558@gmail.com)
- **GitHub**: [nafisha3588](https://github.com/nafisha3588)

### 👤 Mehedi Hasan
- **Email**: [mehedi-2022415897@cs.du.ac.bd](mailto:mehedi-2022415897@cs.du.ac.bd)
- **GitHub**: [hasan-mehedii](https://www.github.com/hasan-mehedii)
