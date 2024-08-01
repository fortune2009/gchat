# GChat - Real-time Chat Application

## Overview
GChat is a real-time chat application built using Flutter. The application allows friends and family to have text-based conversations in real time. The backend is powered by Firebase RealTime Database for real-time communication.

## Features
- User Signup
- User Login
- Tabbed Home Screen with Chat Tab
- List of Users
- Real-time Text Messaging
- User Profile Information
- User Logout

## Setup Instructions For this build

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase Account: [Create Firebase Account](https://firebase.google.com/)
- Git: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Project Setup
1. **Clone the Repository:**

   git clone https://github.com/yourusername/gchat.git
   cd gchat


2. **Install Dependencies:**

   flutter pub get


3. **Firebase Configuration:**
    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Create a new project or use an existing one.
    - Add an Android/iOS/Web app to your Firebase project.
    - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) and place it in the appropriate directory of your Flutter project.
    - For web, configure Firebase by adding the Firebase configuration keys to your web app (`index.html` or `firebase.js`).

4. **Environment Configuration:**
    - Setup environment configuration for exposing the app to different values based on its current environment.
    - Create environment-specific files like `config_dev.dart`, `config_prod.dart`, etc., and ensure they are correctly referenced in your code.
      flutter run --dart-define=ENV=development
      flutter run --dart-define=ENV=production
      flutter run --dart-define=ENV=staging

NB: This was not implemented because the Firebase plugin was used for this project. This config works best using API integration.

5. **Run the App:**

   flutter run


## Deployment Steps

### Web Deployment
1. **Build the Web App:**

   flutter build web


2. **Deploy to Firebase Hosting:**
    - Install Firebase CLI: `npm install -g firebase-tools`
    - Login to Firebase: `firebase login`
    - Initialize Firebase Hosting: `firebase init hosting`
    - Deploy: `firebase deploy`

### Android Deployment
1. **Build the APK:**

   flutter build apk


2. **Upload the APK:**
    - Upload the APK to Google Play Console or any other Android distribution platform.

### iOS Deployment
1. **Build the IPA:**

   flutter build ios


2. **Upload the IPA:**
    - Upload the IPA to Apple App Store Connect using Xcode or Application Loader.

## Plugins Used
- [provider](https://pub.dev/packages/provider): State management
- [firebase_database](https://pub.dev/packages/firebase_database): Real-time database and communication
- [http](https://pub.dev/packages/http): Network requests
- [localstorage](https://pub.dev/packages/localstorage): Local-web database management

## Contact
For any queries or further information, please contact:
- Name: Fortune David
- Email: fortunedavidchigozirim@gmail.com