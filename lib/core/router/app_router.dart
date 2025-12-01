import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/payments/presentation/pages/payments_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../constants/app_constants.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppConstants.splashRoute,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthRoute = state.matchedLocation == AppConstants.loginRoute ||
        state.matchedLocation == AppConstants.signupRoute ||
        state.matchedLocation == AppConstants.splashRoute;

    if (user == null && !isAuthRoute) {
      return AppConstants.loginRoute;
    }

    if (user != null && isAuthRoute) {
      return AppConstants.homeRoute;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppConstants.splashRoute,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppConstants.loginRoute,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppConstants.signupRoute,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => HomePage(child: child),
      routes: [
        GoRoute(
          path: AppConstants.homeRoute,
          name: 'home',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: AppConstants.profileRoute,
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: AppConstants.settingsRoute,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: AppConstants.paymentsRoute,
          name: 'payments',
          builder: (context, state) => const PaymentsPage(),
        ),
        GoRoute(
          path: AppConstants.dashboardRoute,
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    ),
  ],
);

