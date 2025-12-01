import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/admob_service.dart';
import 'core/config/app_config.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/data/datasources/settings_local_datasource.dart';
import 'features/payments/presentation/bloc/payments_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if options are available
  try {
    // Check if Firebase is configured (has options)
    // On web, Firebase needs to be configured via index.html
    if (kIsWeb) {
      // For web, Firebase should be initialized via script tags in index.html
      // If not configured, skip initialization
      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('Firebase not configured for web: $e');
        debugPrint('Continuing without Firebase...');
      }
    } else {
      // For mobile platforms, try to initialize
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    debugPrint('Continuing without Firebase...');
    // Continue without Firebase if initialization fails
  }

  try {
    // Initialize dependency injection
    await setupDependencyInjection();
  } catch (e) {
    debugPrint('Dependency injection setup error: $e');
    debugPrint('Some features may not work properly');
    // Continue - some services may not be available
  }

  // Only initialize services if dependency injection succeeded
  if (getIt.isRegistered<AdMobService>()) {
    try {
      // Initialize AdMob
      await getIt<AdMobService>().initialize();
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
      // Continue without AdMob if initialization fails
    }
  }

  if (getIt.isRegistered<NotificationService>()) {
    try {
      // Initialize notifications
      await getIt<NotificationService>().initialize();
    } catch (e) {
      debugPrint('Notification service initialization error: $e');
      // Continue without notifications if initialization fails
    }
  }

  // AdMob doesn't work on web, skip it
  try {
    if (!kIsWeb) {
      await MobileAds.instance.initialize();
    }
  } catch (e) {
    debugPrint('MobileAds initialization error: $e');
    // Continue without ads if initialization fails
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsBloc _settingsBloc;
  final List<BlocProvider> _providers = [];

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  void _initializeProviders() {
    // Create SettingsBloc first - it's critical and must always be available
    // SettingsBloc should always be registered in DI, but we have fallbacks
    try {
      if (getIt.isRegistered<SettingsBloc>()) {
        _settingsBloc = getIt<SettingsBloc>();
      } else {
        throw Exception('SettingsBloc not registered in DI');
      }
    } catch (e) {
      debugPrint('SettingsBloc not in DI, creating manually: $e');
      try {
        if (getIt.isRegistered<SettingsRepository>()) {
          final settingsRepo = getIt<SettingsRepository>();
          _settingsBloc = SettingsBloc(settingsRepo);
        } else {
          throw Exception('SettingsRepository not registered');
        }
      } catch (e2) {
        debugPrint('Critical error creating SettingsBloc: $e2');
        // Last resort: create with a basic repository
        try {
          final sharedPrefs = getIt<SharedPreferences>();
          final localDataSource = SettingsLocalDataSourceImpl(sharedPrefs);
          final settingsRepo = SettingsRepositoryImpl(localDataSource);
          _settingsBloc = SettingsBloc(settingsRepo);
        } catch (e3) {
          debugPrint('Fatal: Cannot create SettingsBloc at all: $e3');
          // This should never happen if DI is set up correctly
          // But if it does, we need to handle it
          throw Exception('Cannot initialize SettingsBloc: $e3');
        }
      }
    }
    
    // Load settings immediately
    _settingsBloc.add(const LoadSettings());
    
    // Always add SettingsBloc first - use create to ensure it's properly provided
    _providers.insert(0, BlocProvider<SettingsBloc>(
      create: (_) => _settingsBloc,
      lazy: false, // Don't wait, create immediately
    ));
    
    // Add PaymentsBloc (doesn't depend on Firebase)
    try {
      _providers.add(BlocProvider(create: (_) => getIt<PaymentsBloc>()));
    } catch (e) {
      debugPrint('PaymentsBloc not available: $e');
    }
    
    // Conditionally add Firebase-dependent BLoCs
    try {
      _providers.add(BlocProvider(create: (_) => getIt<AuthBloc>()..add(const CheckAuthStatus())));
    } catch (e) {
      debugPrint('AuthBloc not available (Firebase may not be initialized): $e');
    }
    
    try {
      _providers.add(BlocProvider(create: (_) => getIt<ProfileBloc>()));
    } catch (e) {
      debugPrint('ProfileBloc not available: $e');
    }
    
    try {
      _providers.add(BlocProvider(create: (_) => getIt<DashboardBloc>()));
    } catch (e) {
      debugPrint('DashboardBloc not available: $e');
    }
    
    try {
      _providers.add(BlocProvider(create: (_) => getIt<NotificationsBloc>()));
    } catch (e) {
      debugPrint('NotificationsBloc not available: $e');
    }
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure SettingsBloc is always in providers
    if (_providers.isEmpty || !_providers.any((p) => p is BlocProvider<SettingsBloc>)) {
      debugPrint('Warning: SettingsBloc not in providers, adding it');
      _providers.insert(0, BlocProvider<SettingsBloc>(
        create: (_) => _settingsBloc,
        lazy: false,
      ));
    }
    
    return MultiBlocProvider(
      providers: _providers,
      child: Builder(
        builder: (context) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              ThemeMode themeMode = ThemeMode.system;
              if (settingsState is SettingsLoaded) {
                themeMode = settingsState.settings.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light;
              }

              return MaterialApp.router(
                title: AppConfig.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: appRouter,
                builder: (context, child) {
                  return child ?? const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
