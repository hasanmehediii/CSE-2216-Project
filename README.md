# 🌐 LangMastero – Language Learning App

<p align="center">
  <img src="language.png" alt="LangMastero Logo" width="150" height="150" style="border-radius: 50%; border: 2px solid #ccc;" />
  <br>
  <strong>LangMastero – Learn Languages Easily</strong>
</p>


LangMastero is a cross-platform language learning application. This was built by **Team Quattro** for the 2nd year 2nd semester application development final project. This has been made by using **Flutter** for the frontend, **FastAPI** for the backend, and **MongoDB** for the database. The app offers an engaging and intuitive way to learn new languages and also good for test yourself by attend in exams.

## Attachments

  - [Video](https://youtu.be/-zH8NUaVHFw)
  - [Video (with voice)](https://youtu.be/t7dwbIkAJb4)
  - [Report](App_Report.pdf)
  - [Apk File](https://drive.google.com/file/d/1VICObE5gMyPvmKnrwiV2NgcdLoCO8O8O/view?usp=drive_link)

## 📱 Features

- 🔐 User Authentication (Signup/Login)
- 📚 Vocabulary, Flashcards, MCQ Quiz and Sentence Making.
- 📈 Learning Guideline with Todo List
- 🌍 Support for Multiple Languages
- ☁️ Live QNA with admin (Pro User)
- 📈 Pre recorded premium video classes
- 📊 Admin Dashboard (For insert JSON and manage user)
- 🌐 Web version using Flutter Web
- ☁️ Data stored in MongoDB (Cloud/Local)
- 📦 RESTful API powered by FastAPI

## 🧰 Tech Stack

| Layer                          | Technology         |
|--------------------------------|--------------------|
| Frontend                       | Flutter            |
| Backend                        | FastAPI (Python)   |
| Database                       | MongoDB            |


# App Screenshots

Discover the core features of our application through these carefully designed screenshots. Each screen is crafted to provide an intuitive and engaging user experience, ensuring seamless navigation and functionality.

---

## Key Screens

| **Welcome Screen** | **Login Screen** |
|:------------------:|:----------------:|
| <img src="readme/welcome.jpg" alt="Welcome" width="300"> | <img src="readme/login.jpg" alt="Login" width="300"> |
| A vibrant entry point to start your journey. | Secure and streamlined access to your account. |

| **Home Screen** | **Pro Purchase Screen** |
|:---------------:|:-----------------------:|
| <img src="readme/home.jpg" alt="Home" width="300"> | <img src="readme/getpro.jpg" alt="Pro" width="300"> |
| Your central hub for navigating app features. | Unlock premium features with ease. |

| **Recorded Lecture Screen** | **Offline Branch Screen** |
|:--------------------------:|:------------------------:|
| <img src="readme/video.jpg" alt="Video" width="300"> | <img src="readme/location.jpg" alt="Location" width="300"> |
| Access high-quality lectures anytime, anywhere. | Connect with nearby offline branches effortlessly. |

| **MCQ Exam Screen** | **Vocabulary Screen** |
|:-------------------:|:---------------------:|
| <img src="readme/mcq.jpg" alt="MCQ" width="300"> | <img src="readme/vocabulary.jpg" alt="Vocabulary" width="300"> |
| Test your knowledge with interactive quizzes. | Build your vocabulary with engaging exercises. |

| **Flash Card Screen** | **Sentence Making Screen** |
|:---------------------:|:--------------------------:|
| <img src="readme/flashcard.jpg" alt="Flash Card" width="300"> | <img src="readme/sentence.jpg" alt="Sentence" width="300"> |
| Reinforce learning with dynamic flashcards. | Enhance language skills through sentence creation. |

| **Interaction Screen** | **Manage User Screen** |
|:----------------------:|:----------------------:|
| <img src="readme/qna.jpg" alt="QnA" width="300"> | <img src="readme/user.jpg" alt="User" width="300"> |
| Engage in real-time Q&A for collaborative learning. | Manage user profiles with a clean, intuitive interface. |

---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (3.x+)
- Python 3.9+
- MongoDB (local or cloud like MongoDB Atlas)

### 🔧 Backend Setup

1. Create a .env file with your ip address and port number
   ```bash
   #BASE_URL=http://<your_machine's_ipv4>:8000
   ```

2. Navigate to the backend directory:
   ```bash
   cd backend
   ```

3. Create a virtual environment:
    ```bash
    python -m venv venv
    source venv/bin/activate  # For Windows: venv\Scripts\activate
    pip install -r requirements.txt
   ```

4. Run backend server:
    ```bash
   cd backend/fastAPI
   uvicorn main:app --reload
   ```
   
5. Run frontend:
    ```bash
   flutter pub get
   flutter run
    ```

## 🚀 Future Improvements
    - 🧠 AI tutor with OpenAI API
    - 📥 Downloadable lessons and offline mode
    - 🧑‍🏫 Tutor marketplace and booking system
    - 🎙️ Speech recognition for pronunciation evaluation


## 🙌 Contributors:
<table align="center">
  <tr>
    <td align="center">
      <img src="assets/person2.png" width="100px;" height="100px;" alt="Masood" style="border-radius: 50%; object-fit: cover;"/>
      <br />
      <sub><b>Abdullah Ibne Masood</b></sub>
      <br />
      <a href="https://github.com/AbdullahIbneMasoodRegan">GitHub</a>
    </td>
    <td align="center">
      <img src="assets/person3.png" width="100px;" height="100px;" alt="Roza" style="border-radius: 50%; object-fit: cover;"/>
      <br />
      <sub><b>Ibna Afra Roza</b></sub>
      <br />
      <a href="https://www.github.com/Roza-fail">GitHub</a>
    </td>
    <td align="center">
      <img src="assets/person4.png" width="100px;" height="100px;" alt="Nafisha" style="border-radius: 50%; object-fit: cover;"/>
      <br />
      <sub><b>Nafisha Akhter Tuli</b></sub>
      <br />
      <a href="https://github.com/nafisha3588">GitHub</a>
    </td>
    <td align="center">
      <img src="assets/person1.jpg" width="100px;" height="100px;" alt="Mehedi" style="border-radius: 50%; object-fit: cover;"/>
      <br />
      <sub><b>Mehedi Hasan</b></sub>
      <br />
      <a href="https://www.github.com/hasan-mehedii">GitHub</a>
    </td>
  </tr>
</table>
