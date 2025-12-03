import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final Logger _logger = Logger();
  late FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  // Remote Config Keys
  // Auth
  static const String keyEnableEmailAuth = 'enable_email_auth';
  static const String keyEnableGoogleAuth = 'enable_google_auth';
  static const String keyEnableAppleAuth = 'enable_apple_auth';
  static const String keyEnableFacebookAuth = 'enable_facebook_auth';
  static const String keyEnableBiometricAuth = 'enable_biometric_auth';
  static const String keyMinPasswordLength = 'min_password_length';
  static const String keyRequireEmailVerification = 'require_email_verification';
  
  // Stripe Payment
  static const String keyEnableStripePayments = 'enable_stripe_payments';
  static const String keyStripePublishableKey = 'stripe_publishable_key';
  static const String keyStripeMerchantId = 'stripe_merchant_id';
  static const String keyEnableApplePay = 'enable_apple_pay';
  static const String keyEnableGooglePay = 'enable_google_pay';
  static const String keyMinPaymentAmount = 'min_payment_amount';
  static const String keyMaxPaymentAmount = 'max_payment_amount';
  static const String keyCurrency = 'currency';
  static const String keyPaymentMethods = 'payment_methods'; // JSON array
  
  // Dashboard & Revenue
  static const String keyEnableRevenueChart = 'enable_revenue_chart';
  static const String keyEnableEarningsWidget = 'enable_earnings_widget';
  static const String keyChartUpdateInterval = 'chart_update_interval'; // in seconds
  static const String keyDashboardRefreshInterval = 'dashboard_refresh_interval';
  static const String keyShowRevenueGoal = 'show_revenue_goal';
  static const String keyMonthlyRevenueGoal = 'monthly_revenue_goal';
  static const String keyEnableRealtimeUpdates = 'enable_realtime_updates';
  
  // General App Settings
  static const String keyAppMaintenanceMode = 'app_maintenance_mode';
  static const String keyAppMinVersion = 'app_min_version';
  static const String keyForceUpdate = 'force_update';
  static const String keyFeatureFlags = 'feature_flags'; // JSON object
  static const String keyApiBaseUrl = 'api_base_url';
  static const String keyEnableAnalytics = 'enable_analytics';
  static const String keyEnableCrashReporting = 'enable_crash_reporting';
  
  // AdMob
  static const String keyEnableAds = 'enable_ads';
  static const String keyAdRefreshInterval = 'ad_refresh_interval';
  static const String keyBannerAdUnitId = 'banner_ad_unit_id';
  static const String keyInterstitialAdUnitId = 'interstitial_ad_unit_id';
  
  // UI Customization
  static const String keyPrimaryColor = 'primary_color';
  static const String keyEnableDarkMode = 'enable_dark_mode';
  static const String keyShowWelcomeScreen = 'show_welcome_screen';

  Future<void> initialize() async {
    if (_initialized) {
      _logger.i('Remote Config already initialized');
      return;
    }

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1), // Changed from 12 hours for testing
      ));

      // Set default values
      await _remoteConfig.setDefaults(_getDefaultValues());

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();
      
      _initialized = true;
      _logger.i('Remote Config initialized successfully');
      _logCurrentValues();
    } catch (e) {
      _logger.e('Failed to initialize Remote Config: $e');
      // Continue with default values
      _initialized = true;
    }
  }

  Map<String, dynamic> _getDefaultValues() {
    return {
      // Auth defaults
      keyEnableEmailAuth: true,
      keyEnableGoogleAuth: true,
      keyEnableAppleAuth: true,
      keyEnableFacebookAuth: true,
      keyEnableBiometricAuth: true,
      keyMinPasswordLength: 6,
      keyRequireEmailVerification: false,
      
      // Stripe defaults
      keyEnableStripePayments: true,
      keyStripePublishableKey: '',
      keyStripeMerchantId: '',
      keyEnableApplePay: true,
      keyEnableGooglePay: true,
      keyMinPaymentAmount: 1.0,
      keyMaxPaymentAmount: 10000.0,
      keyCurrency: 'USD',
      keyPaymentMethods: '["card", "apple_pay", "google_pay"]',
      
      // Dashboard defaults
      keyEnableRevenueChart: true,
      keyEnableEarningsWidget: true,
      keyChartUpdateInterval: 300, // 5 minutes
      keyDashboardRefreshInterval: 60, // 1 minute
      keyShowRevenueGoal: true,
      keyMonthlyRevenueGoal: 10000.0,
      keyEnableRealtimeUpdates: true,
      
      // General defaults
      keyAppMaintenanceMode: false,
      keyAppMinVersion: '1.0.0',
      keyForceUpdate: false,
      keyFeatureFlags: '{}',
      keyApiBaseUrl: 'https://api.applaa.com',
      keyEnableAnalytics: true,
      keyEnableCrashReporting: true,
      
      // AdMob defaults
      keyEnableAds: true,
      keyAdRefreshInterval: 60,
      keyBannerAdUnitId: '',
      keyInterstitialAdUnitId: '',
      
      // UI defaults
      keyPrimaryColor: '#6C5CE7',
      keyEnableDarkMode: true,
      keyShowWelcomeScreen: true,
    };
  }

  void _logCurrentValues() {
    _logger.d('=== Remote Config Values ===');
    _logger.d('Email Auth: ${getEnableEmailAuth()}');
    _logger.d('Stripe Payments: ${getEnableStripePayments()}');
    _logger.d('Revenue Chart: ${getEnableRevenueChart()}');
    _logger.d('Maintenance Mode: ${getAppMaintenanceMode()}');
    _logger.d('===========================');
  }

  // Auth Getters
  bool getEnableEmailAuth() => _remoteConfig.getBool(keyEnableEmailAuth);
  bool getEnableGoogleAuth() => _remoteConfig.getBool(keyEnableGoogleAuth);
  bool getEnableAppleAuth() => _remoteConfig.getBool(keyEnableAppleAuth);
  bool getEnableFacebookAuth() => _remoteConfig.getBool(keyEnableFacebookAuth);
  bool getEnableBiometricAuth() => _remoteConfig.getBool(keyEnableBiometricAuth);
  int getMinPasswordLength() => _remoteConfig.getInt(keyMinPasswordLength);
  bool getRequireEmailVerification() => _remoteConfig.getBool(keyRequireEmailVerification);

  // Stripe Payment Getters
  bool getEnableStripePayments() => _remoteConfig.getBool(keyEnableStripePayments);
  String getStripePublishableKey() => _remoteConfig.getString(keyStripePublishableKey);
  String getStripeMerchantId() => _remoteConfig.getString(keyStripeMerchantId);
  bool getEnableApplePay() => _remoteConfig.getBool(keyEnableApplePay);
  bool getEnableGooglePay() => _remoteConfig.getBool(keyEnableGooglePay);
  double getMinPaymentAmount() => _remoteConfig.getDouble(keyMinPaymentAmount);
  double getMaxPaymentAmount() => _remoteConfig.getDouble(keyMaxPaymentAmount);
  String getCurrency() => _remoteConfig.getString(keyCurrency);
  String getPaymentMethods() => _remoteConfig.getString(keyPaymentMethods);

  // Dashboard & Revenue Getters
  bool getEnableRevenueChart() => _remoteConfig.getBool(keyEnableRevenueChart);
  bool getEnableEarningsWidget() => _remoteConfig.getBool(keyEnableEarningsWidget);
  int getChartUpdateInterval() => _remoteConfig.getInt(keyChartUpdateInterval);
  int getDashboardRefreshInterval() => _remoteConfig.getInt(keyDashboardRefreshInterval);
  bool getShowRevenueGoal() => _remoteConfig.getBool(keyShowRevenueGoal);
  double getMonthlyRevenueGoal() => _remoteConfig.getDouble(keyMonthlyRevenueGoal);
  bool getEnableRealtimeUpdates() => _remoteConfig.getBool(keyEnableRealtimeUpdates);

  // General App Getters
  bool getAppMaintenanceMode() => _remoteConfig.getBool(keyAppMaintenanceMode);
  String getAppMinVersion() => _remoteConfig.getString(keyAppMinVersion);
  bool getForceUpdate() => _remoteConfig.getBool(keyForceUpdate);
  String getFeatureFlags() => _remoteConfig.getString(keyFeatureFlags);
  String getApiBaseUrl() => _remoteConfig.getString(keyApiBaseUrl);
  bool getEnableAnalytics() => _remoteConfig.getBool(keyEnableAnalytics);
  bool getEnableCrashReporting() => _remoteConfig.getBool(keyEnableCrashReporting);

  // AdMob Getters
  bool getEnableAds() => _remoteConfig.getBool(keyEnableAds);
  int getAdRefreshInterval() => _remoteConfig.getInt(keyAdRefreshInterval);
  String getBannerAdUnitId() => _remoteConfig.getString(keyBannerAdUnitId);
  String getInterstitialAdUnitId() => _remoteConfig.getString(keyInterstitialAdUnitId);

  // UI Getters
  String getPrimaryColor() => _remoteConfig.getString(keyPrimaryColor);
  bool getEnableDarkMode() => _remoteConfig.getBool(keyEnableDarkMode);
  bool getShowWelcomeScreen() => _remoteConfig.getBool(keyShowWelcomeScreen);

  // Force fetch new values (useful for testing)
  Future<void> forceFetch() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await _remoteConfig.fetchAndActivate();
      _logger.i('Remote Config force fetched successfully');
      _logCurrentValues();
    } catch (e) {
      _logger.e('Failed to force fetch Remote Config: $e');
    }
  }

  // Listen for config updates (real-time)
  Stream<RemoteConfigUpdate> get onConfigUpdated => _remoteConfig.onConfigUpdated;

  // Activate config updates
  Future<void> activateConfigUpdates() async {
    _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.activate();
      _logger.i('Remote Config updated: ${event.updatedKeys}');
      _logCurrentValues();
    });
  }
}

