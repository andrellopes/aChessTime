# ChessTime (Flutter)

A simple, beautiful, and efficient chess timer, made in Flutter for Android.

## ✨ Features

- Two clocks with tap alternation
- Time and increment presets (and customization)
- Pause/restart with wakelock
- Visual warning in critical time
- Click sound and vibration options
- Light/dark theme and responsive UI
- Languages: PT-BR, EN, ES, FR, IT, DE
- AdMob banner (with test IDs by default)
- Backup and restoration of preferences, presets, and language

## 📦 Stack

- Flutter/Dart
- Provider (state)
- SharedPreferences (light persistence)
- Google Mobile Ads (AdMob)

## 🚀 How to run (development)

Prerequisites: Flutter installed and in PATH; Android SDK configured.

```powershell
# Install dependencies
flutter pub get

# Run with test IDs (default)
flutter run
```

By default, ad IDs are test ones (safe). If you want to test with your IDs, inject via `--dart-define`:

```powershell
flutter run `
  --dart-define=ADMOB_APP_ID_ANDROID=ca-app-pub-xxxxxxxx~yyyyyyyy `
  --dart-define=ANDROID_NATIVE_AD_UNIT_ID=ca-app-pub-xxxxxxxx/aaaaaaaa `
  --dart-define=ANDROID_BANNER_AD_UNIT_ID=ca-app-pub-xxxxxxxx/bbbbbbbb
```

Note: this repository is configured only for Android.

## 🔐 Security (no secrets in repo)

- There are no passwords or keys in the code. Android signing uses local `android/keystore.properties` (not versioned). Example: `android/keystore.properties.example`.
- AdMob credentials can be configured in two ways:
  1. **Via `--dart-define` flags** (recommended for CI/CD):

     ```powershell
     flutter run --dart-define=ADMOB_APP_ID_ANDROID=ca-app-pub-xxxxxxxx~yyyyyyyy
     ```

  2. **Via local `secrets.json` file** (recommended for local development):
     - Edit `secrets.json` with your real AdMob IDs (App ID, banner and native unit IDs)
     - For Android App ID in AndroidManifest, also update `android/keystore.properties` (copy from example)
     - Files are automatically ignored by `.gitignore`
- The AdMob App ID in AndroidManifest is injected via placeholder (`${ADMOB_APP_ID}`) from `ADMOB_APP_ID_ANDROID`.
- Ad Unit IDs in Dart are read from `secrets.json` or `--dart-define`, with fallback to test IDs in `lib/secrets.dart`.
- `.gitignore` blocks: `*.jks`, `android/keystore.properties`, `secrets.json`, `google-services.json`, `GoogleService-Info.plist`, `lib/firebase_options.dart`, `.env`, certificates etc.

## 🧪 Release build (Android)

To sign locally, create `android/keystore.properties` from the example and point to your `.jks` (do not commit):

```properties
storeFile=android/app/chess_time_release.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=chess_time
keyPassword=YOUR_KEY_PASSWORD
ADMOB_APP_ID_ANDROID=ca-app-pub-xxxxxxxx~yyyyyyyy
```

For AdMob credentials, you can either:

- Set Android App ID in `android/keystore.properties` and unit IDs in `secrets.json`
- Or use `--dart-define` flags for all values

Build:

```powershell
flutter build apk --release
```

## 📁 Structure (summary)

- `lib/` Flutter code (screens, services, widgets, l10n, utils)
- `android/` Android configuration (Gradle, Manifest)
- `assets/` sounds and media

## 📜 License

See `LICENSE` in the project root.
