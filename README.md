# Social Media Flutter App

A simple social media application built with Flutter and Firebase, demonstrating core concepts like authentication (Email/Password, Google Sign-In), posting messages, and viewing a real-time feed.

## Features

*   **Authentication:**
    *   Sign up with Email & Password.
    *   Sign in with Email & Password.
    *   Persistent login state.
*   **Posting:**
    *   Create and publish text-based posts.
    *   Posts include username and timestamp.
*   **Feed:**
    *   Real-time stream of posts from Firestore.
    *   Posts displayed chronologically (newest first).
*   **Architecture:**
    *   Clean Architecture (Features: Auth, Post)
    *   Repository Pattern
    *   Use Cases
    *   Bloc for State Management
    *   `get_it` for Dependency Injection
    *   `go_router` for Navigation

## Technology Stack

*   **Frontend:** Flutter
*   **Backend:** Firebase
    *   Firebase Authentication (Email/Password, Google)
    *   Cloud Firestore (Database)
*   **State Management:** `flutter_bloc` / `bloc`
*   **Dependency Injection:** `get_it`
*   **Routing:** `go_router`
*   **Other:** `dartz`, `equatable`, `intl`, `google_sign_in`


## Prerequisites

Before you begin, ensure you have met the following requirements:

*   **Flutter SDK:** You need Flutter installed on your machine. Check the [official Flutter installation guide](https://flutter.dev/docs/get-started/install). (Latest stable version recommended).
*   **Firebase Project:** You need a Firebase project set up. If you don't have one, create it at [console.firebase.google.com](https://console.firebase.google.com/).
*   **IDE:** An IDE like VS Code or Android Studio with Flutter plugins installed.
*   **Emulator/Device:** An Android emulator, iOS simulator, or a physical device to run the app.

---

## Setup & Firebase Configuration (Crucial Steps!)

Follow these steps carefully to get the project running:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/mukullogixhunt/social_media.git
    cd social_media
    ```
    *(Replace `<your-repository-url>` with the actual URL)*

2.  **Firebase Project Setup:**
    *   Go to your [Firebase Project Console](https://console.firebase.google.com/).
    *   **Add Apps:**
        *   **Android:** Add an Android app to your Firebase project.
            *   Use `com.example.social_media` as the package name (or update it in `android/app/build.gradle` and match it here).
            *   Download the generated `google-services.json` file.
            *   Place the `google-services.json` file inside the `android/app/` directory of your Flutter project.
            *   **Important for Google Sign-In:** Add your `SHA-1` and `SHA-256` fingerprints to the Firebase Android app settings (Authentication -> Sign-in method -> Google -> Add fingerprint). You can get these using `cd android && ./gradlew signingReport`.
        *   **iOS:** Add an iOS app to your Firebase project.
            *   Use `com.example.socialMedia` as the iOS bundle ID (or update it in Xcode and match it here).
            *   Download the generated `GoogleService-Info.plist` file.
            *   Open the `ios` folder of your project in Xcode. Drag the `GoogleService-Info.plist` file into the `Runner/Runner` directory within Xcode (ensure 'Copy items if needed' is checked).
        *   **(Alternative/Recommended) FlutterFire CLI:** You can use the FlutterFire CLI to automate adding the configuration files. See [FlutterFire Overview](https://firebase.flutter.dev/docs/overview#installation). Run `flutterfire configure` in your project root. This command will guide you through selecting your Firebase project and automatically download/place the necessary configuration files (`google-services.json` and `GoogleService-Info.plist`, and update `firebase_options.dart`).

    *   **Enable Authentication Methods:**
        *   In the Firebase console, go to `Build` -> `Authentication` -> `Sign-in method`.
        *   Enable the **Email/Password** provider.
        *   Enable the **Google** provider. Make sure to select your project's support email.

    *   **Enable Firestore Database:**
        *   Go to `Build` -> `Firestore Database`.
        *   Click `Create database`.
        *   Choose **Start in production mode** or **Start in test mode**.
            *   *Production mode* is safer but requires setting up security rules immediately.
            *   *Test mode* allows open access for 30 days (good for initial development, **change before deploying!**).
            *   Select a Firestore location (choose one close to your users).
        *   **Security Rules:** Even in test mode, it's good practice to define basic rules. Navigate to the `Rules` tab in Firestore. A minimal rule set for authenticated users could be:
            ```js
            rules_version = '2';
            service cloud.firestore {
              match /databases/{database}/documents {
                // Allow reads/writes only if the user is authenticated
                // match /{document=**} { // Too broad for production
                //   allow read, write: if request.auth != null;
                // }

                // Allow anyone to read posts, but only authenticated users to create
                match /posts/{postId} {
                  allow read: if true; // Or 'if request.auth != null;' if feed should be private
                  allow create: if request.auth != null;
                  // Add update/delete rules based on userId if needed
                  // allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
                }

                // Allow users to read their own data and create/update it.
                match /users/{userId} {
                  allow read: if request.auth != null;
                  allow create: if request.auth != null && request.auth.uid == userId;
                  allow update: if request.auth != null && request.auth.uid == userId;
                  // Generally avoid allowing direct delete unless necessary
                }
              }
            }
            ```
            Click **Publish** to save the rules.

3.  **Install Dependencies:**
    Open your terminal in the project root directory and run:
    ```bash
    flutter pub get
    ```

---

## Running the Application

1.  **Ensure Device/Emulator is Ready:** Make sure you have an Android emulator running or a physical device connected and recognized by Flutter (`flutter devices`). For iOS, ensure an iOS simulator is running or a device is connected.

2.  **Run the App:**
    In your terminal, from the project root directory, execute:
    ```bash
    flutter run
    ```

    The app should now build and launch on your selected device/emulator. You can log in, sign up, view the feed, and create posts.

## Project Structure

The project follows a feature-first structure based on Clean Architecture principles:

```text
lib/
├── core/                   # Shared code: constants, extensions, theme, base classes (UseCase, Failure)
│   ├── constants/          # App-wide constants (e.g., MediaConstants, TextConstants)
│   ├── error/              # Failure classes, exception handling
│   ├── extentions/         # Dart extensions (e.g., BuildContext)  <-- Note: Typo? Should be "extensions"?
│   ├── theme/              # App theme data (light/dark mode)
│   ├── usecase/            # Base UseCase class
│   └── utlis/              # Utility widgets/functions (e.g., FullScreenLoader, formatTimeAgo) <-- Note: Typo? Should be "utils"?
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer: models, datasources, repositories impl
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/         # Domain layer: entities, repositories contracts, usecases
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   ├── presentation/   # Presentation layer: BLoC, screens, widgets
│   │   │   ├── bloc/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── auth_injection.dart # DI setup for auth
│   └── post/               # Post feature (feed, creating posts)
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── presentation/
│       │   ├── bloc/
│       │   ├── screens/
│       │   └── widgets/    # (If any post-specific widgets exist)
│       └── post_injection.dart # DI setup for post
├── app_router.dart         # GoRouter configuration
├── injection_container.dart # Main GetIt service locator setup
├── main.dart               # App entry point, Firebase init, MyApp widget
└── firebase_options.dart   # Auto-generated by FlutterFire CLI

## Contributing

Contributions are welcome! Please follow standard Fork and Pull Request workflows. Ensure your code adheres to the existing style and architecture. Add tests for new features or bug fixes where applicable.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request
