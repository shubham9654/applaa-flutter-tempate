import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../bloc/settings_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(const LoadSettings());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SettingsLoaded) {
            final settings = state.settings;
            
            // Check if user is authenticated
            bool isAuthenticated = false;
            try {
              isAuthenticated = FirebaseAuth.instance.currentUser != null;
            } catch (e) {
              isAuthenticated = false;
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Sign In Section (for guest users)
                if (!isAuthenticated) ...[
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sign In to Access More Features',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to access your profile, make payments, and sync your data.',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    context.push(AppConstants.loginRoute);
                                  },
                                  icon: const Icon(Icons.login),
                                  label: const Text('Sign In'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.push(AppConstants.signupRoute);
                                  },
                                  icon: const Icon(Icons.person_add),
                                  label: const Text('Sign Up'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Account Section (only for authenticated users)
                if (isAuthenticated) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Profile'),
                      subtitle: const Text('Manage your profile information'),
                      leading: const Icon(Icons.person),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push(AppConstants.profileRoute);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Payments Section
                  Card(
                    child: ListTile(
                      title: const Text('Payments'),
                      subtitle: const Text('Manage payment methods and transactions'),
                      leading: const Icon(Icons.payment),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push(AppConstants.paymentsRoute);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // App Settings Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark theme'),
                    value: settings.isDarkMode,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(const ToggleTheme());
                    },
                    secondary: const Icon(Icons.dark_mode),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Enable push notifications'),
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                            const ToggleNotifications(),
                          );
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: const Text('Language'),
                    subtitle: Text(settings.language.toUpperCase()),
                    leading: const Icon(Icons.language),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Show language selection dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Language'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('English'),
                                onTap: () {
                                  context.read<SettingsBloc>().add(
                                        const ChangeLanguage('en'),
                                      );
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Spanish'),
                                onTap: () {
                                  context.read<SettingsBloc>().add(
                                        const ChangeLanguage('es'),
                                      );
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Sign Out Section (only for authenticated users)
                if (isAuthenticated)
                  Card(
                    child: ListTile(
                      title: const Text('Sign Out'),
                      leading: const Icon(Icons.logout, color: Colors.red),
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: () {
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
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    context.read<AuthBloc>().add(const SignOutRequested());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Signed out successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    appRouter.go(AppConstants.homeRoute);
                                  } catch (e) {
                                    debugPrint('Sign out error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error signing out: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

