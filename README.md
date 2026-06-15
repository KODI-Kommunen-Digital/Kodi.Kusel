# Kusel

A Flutter application for the Kusel district.

## Prerequisites

Before running this project, you must manually add the following sensitive files. These are excluded from version control for security reasons. Obtain them from a teammate or the project's secure secrets vault.

### Required Files

| File                    | Location in Project                          |
|-------------------------|----------------------------------------------|
| `firebase_options.dart` | `lib/firebase_option/firebase_options.dart`  |
| `google-services.json`  | `android/app/src/google-services.json`       |
| `GoogleService-Info.plist` | `ios/Runner/GoogleService-Info.plist`     |
| `.envKusel`             | `.envKusel` (project root)                   |

### `.envKusel` Format

Create a `.envKusel` file in the project root with the following keys:

```
BASE_URL_PROD=<production_api_base_url>
IMAGE_DOWNLOADING_ENDPOINT=<image_storage_base_url>
BASE_URL_STAGE=<staging_api_base_url>
```

## Getting Started

1. Add all required files listed above.
2. Run `flutter pub get` to install dependencies.
3. Run the app:
   - **Dev:** `flutter run --target lib/main_dev.dart`
   - **Prod:** `flutter run --target lib/main_prod.dart`

## FVM

This project uses [FVM](https://fvm.app/) to manage the Flutter SDK version. Install FVM and run `fvm install` to use the correct version.
K