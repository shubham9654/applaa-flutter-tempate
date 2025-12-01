import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../constants/app_constants.dart';
import '../utils/setup_checker.dart';
import '../widgets/setup_warning_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isFirebaseAvailable = GetIt.instance.isRegistered<FirebaseAuth>();
    bool isAuthenticated = false;
    
    try {
      isAuthenticated = FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      isAuthenticated = false;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.flutter_dash,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Applaa Template',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (isAuthenticated)
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'User',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  )
                else
                  const Text(
                    'Guest User',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

          // Setup Status Warnings
          Builder(
            builder: (context) {
              final requirements = SetupChecker.getAllRequirements();
              final issues = requirements.where((r) =>
                  r.status == SetupStatus.notConfigured ||
                  r.status == SetupStatus.platformNotSupported).toList();
              
              if (issues.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Column(
                children: issues.map((req) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SetupWarningWidget(
                    requirement: req,
                    showActionButton: false,
                  ),
                )).toList(),
              );
            },
          ),

          // Navigation Items
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppConstants.homeRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppConstants.settingsRoute);
            },
          ),

          // Account Section (only if authenticated)
          if (isAuthenticated) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.profileRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment_outlined),
              title: const Text('Payments'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.paymentsRoute);
              },
            ),
          ],

          // Auth Section
          const Divider(),
          if (!isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign In'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppConstants.loginRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Sign Up'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppConstants.signupRoute);
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showSignOutDialog(context);
              },
            ),
          ],

          // About Section
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context, isFirebaseAvailable);
            },
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Check if AuthBloc is available
              if (!GetIt.instance.isRegistered<AuthBloc>()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Firebase authentication is not configured. You are already signed out as a guest.'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                GetIt.instance<AuthBloc>().add(const SignOutRequested());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signed out successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.go(AppConstants.homeRoute);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error signing out: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isFirebaseAvailable) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Applaa Flutter Template'),
            const SizedBox(height: 8),
            const Text('Version: 1.0.0'),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  isFirebaseAvailable ? Icons.check_circle : Icons.warning,
                  color: isFirebaseAvailable ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isFirebaseAvailable ? 'Firebase: Configured' : 'Firebase: Not Configured',
                  style: TextStyle(
                    color: isFirebaseAvailable ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

