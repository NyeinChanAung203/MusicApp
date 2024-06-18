# Music Application

Music Application using Flutter and FastAPI

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Tutorial](#tutorial)
- [Screenshots](#screenshots)


## Overview

This project is a simple music app. It is built by following a YouTube tutorial created by Rivaan Ranawat. The tutorial provides a step-by-step guide on how to build this project from scratch.


## Features

- Authentication [ Sign up with email and password, Login, Logout ]
- Upload Songs
- Play Songs in app or background
- Favorite Songs


## Prerequisites

Before you begin, ensure you have met the following requirements:
- [ Basic Knowledge of Flutter, Dart and Python ]


## Installation

To install this project, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/NyeinChanAung203/MusicApp.git
    ```
2. Navigate to the project directory:
    ```bash
    cd server
    ```
3. Install the necessary dependencies:
    ```bash
    pip install -r requirements.txt
    ```
4. Start Server:
    ```bash
    fastapi run main.py
    ```
5. Go to client folder and run flutter
    ```bash
    cd client
    flutter run
    ```
*Note*: You need to start postgres service and change postgres url [DATABASE_URL] in server/database.py file [ add your own postgre user and password ]


## Tutorial

You can follow the tutorial on YouTube to understand the step-by-step process of building this project. Watch the full tutorial here: [YouTube Tutorial Link](https://www.youtube.com/watch?v=CWvlOU2Y3Ik)


---

**Note**: This project is for educational purposes and follows the tutorial by Rivaan Ranawat. All credit for the tutorial content goes to Rivaan Ranawat.


## Screenshots

### Authentication
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/7b84a23d-0098-4d24-bf4a-5084c201967c" width="210" height="480">
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/88dac23c-d0a5-434e-bd48-920ad3f95931" width="210" height="480"> <br><br>

### Home and Playing Song
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/17242b81-4469-45d4-bceb-c5734fb4de75" width="210" height="480">
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/53b6fb8d-7a08-448e-8346-5f35920b7c09" width="210" height="480">
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/905808d3-b446-4f27-a54b-f6f5d0072280" width="210" height="480"> <br><br>

### Playing Song
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/47529f52-8d30-4954-9f4b-4330a6771acd" width="210" height="480">
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/827bd344-ed2b-4666-a44c-b3aa1c3a3909" width="210" height="480"> <br><br>

### Library and Upload New Song
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/0b4ad465-f8b5-487c-9c82-67d4108c28b6" width="210" height="480">
<img src="https://github.com/NyeinChanAung203/MusicApp/assets/63293974/139db1f2-1422-478e-afe9-4bde8d11ee8e" width="210" height="480">




