class AppConfig {
  // Firebase Configuration
  static const String firebaseProjectId = 'your-project-id';
  
  // Stripe Configuration
  static const String stripePublishableKey = 'pk_test_your_publishable_key';
  static const String stripeSecretKey = 'sk_test_your_secret_key';
  static const String stripeApiUrl = 'https://api.stripe.com/v1';
  
  // AdMob Configuration (Test IDs)
  static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String admobBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String admobInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  
  // App Configuration
  static const String appName = 'Applaa Template';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://your-api-url.com';
  static const Duration apiTimeout = Duration(seconds: 30);
}

