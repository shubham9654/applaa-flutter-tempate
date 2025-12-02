# Firebase Setup Guide

## Android Setup

1. **Download google-services.json**
   - Go to Firebase Console → Project Settings
   - Download `google-services.json`
   - Place it in `android/app/`

2. **Update android/build.gradle**
   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

3. **Update android/app/build.gradle**
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   
   android {
       defaultConfig {
           minSdkVersion 21
       }
   }
   ```

## iOS Setup

1. **Download GoogleService-Info.plist**
   - Go to Firebase Console → Project Settings
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

2. **Update ios/Podfile**
   ```ruby
   platform :ios, '12.0'
   ```

3. **Run pod install**
   ```bash
   cd ios
   pod install
   ```

## Web Setup

1. **Add Firebase Web Config**
   - Go to Firebase Console → Project Settings
   - Copy the Firebase config object
   - Create `lib/core/config/firebase_options.dart` (use FlutterFire CLI)

## Enable Services

1. **Authentication**
   - Firebase Console → Authentication → Sign-in method
   - Enable Email/Password

2. **Firestore**
   - Firebase Console → Firestore Database
   - Create database in test mode (or production with rules)

3. **Cloud Messaging**
   - Firebase Console → Cloud Messaging
   - Enable Cloud Messaging API

## Firestore Rules (Development)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /payments/{paymentId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Testing

Use Firebase Emulator Suite for local development:
```bash
firebase emulators:start
```

