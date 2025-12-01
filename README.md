# Applaa Flutter Template

A comprehensive Flutter template project with clean architecture, BLoC state management, Firebase integration, Stripe payments, and AdMob ads.

## Features

- ✅ **Clean Architecture** - Data/Domain/Presentation layers
- ✅ **BLoC State Management** - flutter_bloc for all modules
- ✅ **Navigation** - go_router with route guards
- ✅ **Dependency Injection** - get_it for service locator
- ✅ **Firebase Integration** - Auth, Firestore, Cloud Messaging
- ✅ **Stripe Payments** - Payment Intent flow with card input
- ✅ **AdMob Integration** - Banner and Interstitial ads
- ✅ **Notifications** - FCM + Local notifications
- ✅ **Responsive UI** - Works on Android, iOS, and Web
- ✅ **Theme Support** - Light/Dark mode toggle
- ✅ **Revenue Dashboard** - Charts and analytics

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/        # App constants
│   ├── di/              # Dependency injection
│   ├── router/           # Navigation setup
│   ├── services/        # Core services
│   ├── theme/           # Theme configuration
│   └── widgets/         # Reusable widgets
├── features/
│   ├── auth/            # Authentication module
│   ├── profile/         # User profile module
│   ├── settings/        # Settings module
│   ├── payments/       # Stripe payments module
│   ├── dashboard/       # Revenue dashboard module
│   ├── notifications/   # Notifications module
│   ├── splash/          # Splash screen
│   └── home/            # Home with bottom navigation
└── main.dart            # App entry point
```

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd applaa_flutter_template
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env file with your actual keys
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Environment Variables

Copy `.env.example` to `.env` and fill in your actual values:

```bash
cp .env.example .env
```

### Required Environment Variables

- **Firebase**: `FIREBASE_PROJECT_ID`, `FIREBASE_API_KEY`, etc.
- **Stripe**: `STRIPE_PUBLISHABLE_KEY`, `STRIPE_SECRET_KEY`
- **AdMob**: `ADMOB_APP_ID`, `ADMOB_BANNER_ID`, `ADMOB_INTERSTITIAL_ID`
- **API**: `API_BASE_URL` for your backend server

See `.env.example` for all available configuration options.

## Docker Setup

### Prerequisites
- Docker and Docker Compose installed

### Build and Run

```bash
# Build and start the container
docker-compose up --build

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The app will be available at `http://localhost:8080` (or the port specified in `.env`).

### Docker Commands

```bash
# Build image
docker build -t applaa-flutter-app .

# Run container
docker run -p 8080:80 applaa-flutter-app

# Stop and remove
docker-compose down
```

## Setup Instructions

### 1. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android app:
   - Download `google-services.json` and place it in `android/app/`
3. Add iOS app:
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`
4. Enable Authentication (Email/Password)
5. Enable Firestore Database
6. Enable Cloud Messaging

### 2. Stripe Setup

1. Create a Stripe account at [Stripe](https://stripe.com/)
2. Get your publishable and secret keys from the dashboard
3. Add them to your `.env` file:
   ```
   STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
   STRIPE_SECRET_KEY=sk_test_your_secret_key_here
   ```
4. Set up a backend server to create payment intents (for security)
5. Update `API_BASE_URL` in `.env` to point to your backend server

**For detailed Stripe setup and troubleshooting, see [STRIPE.md](STRIPE.md)**

### 3. AdMob Setup

1. Create an AdMob account at [AdMob](https://admob.google.com/)
2. Create ad units (Banner and Interstitial)
3. Add them to your `.env` file:
   ```
   ADMOB_APP_ID=ca-app-pub-xxxxx
   ADMOB_BANNER_ID=ca-app-pub-xxxxx
   ADMOB_INTERSTITIAL_ID=ca-app-pub-xxxxx
   ```
4. For Android: Add your AdMob App ID to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-xxxxx"/>
   ```
5. For iOS: Add your AdMob App ID to `ios/Runner/Info.plist`:
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>ca-app-pub-xxxxx</string>
   ```

## Configuration

### Environment Variables

All configuration is done through the `.env` file. Copy `.env.example` to `.env` and update with your values:

```bash
cp .env.example .env
```

**Important**: Never commit your `.env` file to version control. It's already in `.gitignore`.

### Configuration Files

#### Android Configuration
- `android/app/build.gradle` - Update minSdkVersion to 21+
- `android/app/src/main/AndroidManifest.xml` - Add internet permission and AdMob App ID

#### iOS Configuration
- `ios/Podfile` - Ensure platform is iOS 12.0+
- `ios/Runner/Info.plist` - Add AdMob App ID and notification permissions

#### Web Configuration
- Ensure Firebase and AdMob are configured for web platforms
- Firebase web config should be added to `web/index.html`

## Module Details

### Auth Module
- Email/Password authentication
- Sign up and Sign in flows
- Firebase Auth integration
- Route guards for protected pages

### Profile Module
- View and edit user profile
- Display name, bio, phone number
- Profile picture support

### Settings Module
- Theme toggle (Light/Dark)
- Notification preferences
- Language selection
- Sign out functionality

### Payments Module
- Stripe Payment Intent flow
- Card input UI
- Payment confirmation
- Requires backend server for security

### Dashboard Module
- Revenue analytics
- Total, monthly, and weekly revenue
- Revenue trend charts
- AdMob banner integration

### Notifications Module
- FCM token management
- Local notification storage
- Notification history
- Mark as read functionality

## Architecture

This project follows Clean Architecture principles:

- **Presentation Layer**: UI, BLoC, Pages
- **Domain Layer**: Entities, Repositories (interfaces), Use Cases
- **Data Layer**: Data Sources, Repository Implementations

## State Management

All modules use BLoC pattern:
- Events: User actions
- States: UI states
- Bloc: Business logic

## Navigation

- `go_router` for declarative routing
- Route guards for authentication
- Bottom navigation for main app
- Nested navigation support

## Dependencies

Key dependencies:
- `flutter_bloc` - State management
- `go_router` - Navigation
- `get_it` - Dependency injection
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging` - Firebase
- `flutter_stripe` - Stripe payments
- `google_mobile_ads` - AdMob
- `fl_chart` - Charts
- `flutter_local_notifications` - Local notifications

## Testing

Run tests:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Docker (Web)
```bash
# Build and run with Docker
docker-compose up --build

# Or build manually
docker build -t applaa-flutter-app .
docker run -p 8080:80 applaa-flutter-app
```

## File Structure

```
.
├── .env.example          # Environment variables template
├── .env                  # Your actual environment variables (not in git)
├── Dockerfile            # Docker build configuration (includes nginx config)
├── docker-compose.yml    # Docker Compose configuration
├── STRIPE.md             # Stripe setup and troubleshooting guide
├── FIREBASE_SETUP.md     # Firebase setup guide
├── ADMOB_SETUP.md        # AdMob setup guide
├── lib/                  # Flutter source code
└── README.md             # This file
```

## Notes

- **Environment Variables**: Use `.env` file for all configuration. Never commit it to git.
- **Docker**: Single `Dockerfile` and `docker-compose.yml` for simplicity
- **Test Keys**: This template uses test/development keys for Stripe and AdMob
- **Production**: Replace with production keys before deploying
- **Backend**: Payment Intent creation should be done on your backend server
- **Firebase**: Configure Firebase properly for each platform
- **AdMob**: Requires proper app configuration for each platform

## License

This template is provided as-is for use in your projects.

## Support

For issues or questions, please refer to the official documentation:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Stripe Documentation](https://stripe.com/docs)
- [AdMob Documentation](https://developers.google.com/admob)
