import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui';
import '../bloc/settings_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            User? currentUser;
            try {
              currentUser = FirebaseAuth.instance.currentUser;
              isAuthenticated = currentUser != null;
            } catch (e) {
              isAuthenticated = false;
            }

            return CustomScrollView(
              slivers: [
                // Sticky Header
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.grey[50]!.withOpacity(0.9),
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.grey[50]!.withOpacity(0.9),
                      ),
                    ),
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _buildSettingsList(context, isAuthenticated, currentUser, settings),
                    ),
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

  List<Widget> _buildSettingsList(
    BuildContext context,
    bool isAuthenticated,
    User? currentUser,
    dynamic settings,
  ) {
    final List<Widget> items = [];
    
    // Profile Card
    if (isAuthenticated) {
      items.add(
        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: currentUser?.photoURL != null
                                          ? NetworkImage(currentUser!.photoURL!)
                                          : null,
                                      ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6C5CE7),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentUser?.displayName ?? 'User',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentUser?.email ?? 'user@applaa.ui',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(AppConstants.profileRoute);
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6C5CE7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
      );
    }
    
    // Premium Banner (if authenticated)
    if (isAuthenticated) {
      items.add(
        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF6C5CE7), Color(0xFF818CF8)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C5CE7).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -24,
                                top: -24,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -24,
                                bottom: -24,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // Premium content can be added here
                            ],
                          ),
                        ),
      );
    }
    
    // Account Section
    if (isAuthenticated) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                context: context,
                icon: Icons.person_outline,
                iconColor: const Color(0xFF6C5CE7),
                title: 'Personal Information',
                onTap: () {
                  context.push(AppConstants.profileRoute);
                },
                showDivider: true,
              ),
              _buildSettingsItem(
                context: context,
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF6C5CE7),
                title: 'Security & Login',
                onTap: () {},
                showDivider: true,
              ),
              _buildSettingsItem(
                context: context,
                icon: Icons.credit_card_outlined,
                iconColor: const Color(0xFF6C5CE7),
                title: 'Payments & Billing',
                onTap: () {
                  context.push(AppConstants.paymentsRoute);
                },
              ),
            ],
          ),
        ),
      );
    }
    
    // Preferences Section
    items.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 4),
        child: Text(
          'PREFERENCES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
    items.add(
      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[100]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsItemWithToggle(
                              icon: Icons.notifications_outlined,
                              iconColor: Colors.orange[500]!,
                              title: 'Push Notifications',
                              value: settings.notificationsEnabled,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(
                                      const ToggleNotifications(),
                                    );
                              },
                              showDivider: true,
                            ),
                            _buildSettingsItemWithToggle(
                              icon: Icons.dark_mode_outlined,
                              iconColor: Colors.grey[600]!,
                              title: 'Dark Mode',
                              value: settings.isDarkMode,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(
                                      const ToggleTheme(),
                                    );
                              },
                              showDivider: true,
                            ),
                            _buildSettingsItem(
                              context: context,
                              icon: Icons.language_outlined,
                              iconColor: Colors.blue[500]!,
                              title: 'Language',
                              subtitle: 'English (US)',
                              onTap: () {
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
                          ],
                        ),
                      ),
    );
    
    // Support Section
    items.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 4),
        child: Text(
          'SUPPORT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
    items.add(
      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[100]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              context: context,
                              icon: Icons.help_outline,
                              iconColor: Colors.green[600]!,
                              title: 'Help Center',
                              onTap: () {},
                              showDivider: true,
                            ),
                            _buildSettingsItem(
                              context: context,
                              icon: Icons.description_outlined,
                              iconColor: Colors.purple[500]!,
                              title: 'Terms & Privacy',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
    );
    
    // Logout Button
    if (isAuthenticated) {
      items.add(
        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red[100]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextButton.icon(
                            onPressed: () {
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
                                        if (!GetIt.instance.isRegistered<AuthBloc>()) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Firebase authentication is not configured.'),
                                              backgroundColor: Colors.orange,
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
                                        }
                                      },
                                      child: const Text('Sign Out'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
      );
    }
    
    return items;
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(color: Colors.grey[50]!),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[300],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItemWithToggle({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(color: Colors.grey[50]!),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6C5CE7),
          ),
        ],
      ),
    );
  }
}

