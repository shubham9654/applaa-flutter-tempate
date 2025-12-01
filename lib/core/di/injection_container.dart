import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/payments/data/datasources/payments_remote_datasource.dart';
import '../../features/payments/data/repositories/payments_repository_impl.dart';
import '../../features/payments/domain/repositories/payments_repository.dart';
import '../../features/payments/presentation/bloc/payments_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/notifications/data/datasources/notifications_local_datasource.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../services/notification_service.dart';
import '../services/admob_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => flutterLocalNotificationsPlugin,
  );
  
  // Services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(
      getIt<FlutterLocalNotificationsPlugin>(),
      getIt<FirebaseMessaging>(),
    ),
  );
  
  getIt.registerLazySingleton<AdMobService>(
    () => AdMobService(),
  );
  
  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );
  
  // Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<ProfileRepository>()),
  );
  
  // Settings
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );
  
  getIt.registerFactory<SettingsBloc>(
    () => SettingsBloc(getIt<SettingsRepository>()),
  );
  
  // Payments
  getIt.registerLazySingleton<PaymentsRemoteDataSource>(
    () => PaymentsRemoteDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(getIt<PaymentsRemoteDataSource>()),
  );
  
  getIt.registerFactory<PaymentsBloc>(
    () => PaymentsBloc(getIt<PaymentsRepository>()),
  );
  
  // Dashboard
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt<DashboardRemoteDataSource>()),
  );
  
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(getIt<DashboardRepository>()),
  );
  
  // Notifications
  getIt.registerLazySingleton<NotificationsLocalDataSource>(
    () => NotificationsLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      getIt<NotificationsLocalDataSource>(),
      getIt<NotificationService>(),
    ),
  );
  
  getIt.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(getIt<NotificationsRepository>()),
  );
}

