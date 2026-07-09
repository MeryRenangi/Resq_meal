# ResQ Meal — Production Guide

## 1. Firebase setup checklist

- [ ] Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
- [ ] Enable **Authentication** (Email/Password; add Google if needed)
- [ ] Create **Firestore** database (production mode)
- [ ] Enable **Storage** bucket
- [ ] Enable **Cloud Messaging** (FCM)
- [ ] Install CLI: `npm install -g firebase-tools`
- [ ] Login: `firebase login`
- [ ] Copy `.firebaserc.example` → `.firebaserc` and set your project ID
- [ ] Run FlutterFire:
  ```bash
  dart pub global activate flutterfire_cli
  flutterfire configure
  ```
- [ ] Place `google-services.json` in `android/app/`
- [ ] Deploy security rules:
  ```bash
  firebase deploy --only firestore:rules,storage
  firebase deploy --only firestore:indexes
  ```
- [ ] Replace `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`
- [ ] Restrict API keys in Google Cloud Console (Android app + Maps)
- [ ] Create FCM notification channel `resq_meal_alerts` (handled in app; verify in Firebase Console)
- [ ] Set Firestore backup and billing alerts
- [ ] Verify `ProductionConfig.isFirebaseConfigured` is true after configure

## 2. APK / AAB build commands

```bash
# Dependencies & quality gate
flutter pub get
flutter analyze
flutter test

# Debug APK (testing)
flutter build apk --debug

# Release APK (sideload / internal testing)
flutter build apk --release

# Split per ABI (smaller downloads)
flutter build apk --release --split-per-abi

# Play Store bundle (recommended)
flutter build appbundle --release
```

Output paths:
- APK: `build/app/outputs/flutter-apk/`
- AAB: `build/app/outputs/bundle/release/`

## 3. Release build checklist

- [ ] Copy `android/key.properties.example` → `android/key.properties`
- [ ] Generate keystore:
  ```bash
  keytool -genkey -v -keystore android/keystore/resq-meal-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias resqmeal
  ```
- [ ] Set version in `pubspec.yaml` (`version: x.y.z+build`)
- [ ] Confirm `applicationId` = `com.resqmeal.resq_meal`
- [ ] Confirm app label **ResQ Meal** in `AndroidManifest.xml`
- [ ] `google-services.json` present for release Firebase
- [ ] Maps API key set for production
- [ ] Run `flutter build appbundle --release`
- [ ] Test on physical device: auth, donations, requests, chat, QR, notifications
- [ ] Verify ProGuard release build (no crash on startup)

## 4. Deployment checklist

### Firebase
- [ ] Deploy `firebase/firestore.rules` and `firebase/storage.rules`
- [ ] Deploy composite indexes from `firebase/firestore.indexes.json`
- [ ] Seed admin user / roles in Firestore `users` collection
- [ ] Configure FCM for production (no test tokens in prod docs)

### Google Play
- [ ] Create Play Console app with package `com.resqmeal.resq_meal`
- [ ] Upload AAB from `flutter build appbundle --release`
- [ ] Complete store listing, privacy policy, content rating
- [ ] Declare location, camera, notifications permissions usage

### Post-launch
- [ ] Monitor Crashlytics (optional: add `firebase_crashlytics`)
- [ ] Monitor Firestore usage and Storage bandwidth
- [ ] Review security rules after schema changes

## Project layout (production artifacts)

| Path | Purpose |
|------|---------|
| `lib/config/firebase_options.dart` | FlutterFire generated options |
| `lib/config/production_config.dart` | Runtime Firebase readiness checks |
| `firebase/firestore.rules` | Role-based Firestore security |
| `firebase/storage.rules` | Image upload limits and auth |
| `firebase/firestore.indexes.json` | Composite query indexes |
| `firebase.json` | Firebase CLI project config |
| `android/app/proguard-rules.pro` | Release shrinking rules |
| `android/key.properties.example` | Signing template |

## Verification matrix (manual QA)

| Area | Routes / screens | Firebase |
|------|------------------|----------|
| Auth | Login, register, forgot password | Auth |
| Roles | Donor / NGO / Admin dashboards | `users` |
| Donations | Create, detail, history, admin approval | `donations` |
| Requests | Create, detail, NGO/donor flows | `food_requests` |
| Chat | Chats tab, detail | `chats`, messages subcollection |
| Notifications | List, detail, FCM token sync | `notifications`, FCM |
| QR | Display, scan, verify | `qr_verifications` |
| Reports | Analytics, export PDF/CSV | `reports` |
| Admin | Users, NGOs, donations, feedback | Multiple collections |

## Commands reference

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
firebase deploy --only firestore:rules,storage,firestore:indexes
```
