import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/widgets/auth_required_widget.dart';
import '../bloc/profile_bloc.dart';
import '../../domain/entities/profile_entity.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    // Load profile after first frame to ensure context has providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<ProfileBloc>().add(const LoadProfile());
        } catch (e) {
          debugPrint('ProfileBloc not available: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _startEditing(ProfileEntity profile) {
    setState(() {
      _isEditing = true;
      _nameController.text = profile.displayName ?? '';
      _bioController.text = profile.bio ?? '';
      _phoneController.text = profile.phoneNumber ?? '';
    });
  }

  void _saveProfile(String userId) {
    if (_formKey.currentState!.validate()) {
      try {
        final profile = ProfileEntity(
          id: userId,
          email: FirebaseAuth.instance.currentUser?.email ?? '',
          displayName: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );

        context.read<ProfileBloc>().add(UpdateProfile(profile));
        setState(() {
          _isEditing = false;
        });
      } catch (e) {
        debugPrint('ProfileBloc not available: $e');
      }
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
    try {
      context.read<ProfileBloc>().add(const LoadProfile());
    } catch (e) {
      debugPrint('ProfileBloc not available: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Show sign-in prompt for guest users
        return const AuthRequiredWidget(
          title: 'Sign In Required',
          message: 'Please sign in to access your profile and manage your account settings.',
          icon: Icons.person_outline,
        );
      }
    } catch (e) {
      // Firebase not initialized, show sign-in prompt
      return const AuthRequiredWidget(
        title: 'Sign In Required',
        message: 'Please sign in to access your profile and manage your account settings.',
        icon: Icons.person_outline,
      );
    }

    // Check if ProfileBloc is available
    try {
      context.read<ProfileBloc>();
    } catch (e) {
      // ProfileBloc not available, show message
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('Profile features require Firebase authentication.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded && !_isEditing) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _startEditing(state.profile),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        context.read<ProfileBloc>().add(const LoadProfile());
                      } catch (e) {
                        debugPrint('ProfileBloc not available: $e');
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;
            final user = FirebaseAuth.instance.currentUser;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profile.photoUrl != null
                          ? NetworkImage(profile.photoUrl!)
                          : null,
                      child: profile.photoUrl == null
                          ? Text(
                              profile.displayName?.substring(0, 1).toUpperCase() ??
                                  user?.email?.substring(0, 1).toUpperCase() ??
                                  'U',
                              style: const TextStyle(fontSize: 40),
                            )
                          : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (_isEditing && (value == null || value.isEmpty)) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: TextEditingController(text: profile.email),
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      enabled: _isEditing,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    if (_isEditing) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancelEditing,
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _saveProfile(profile.id),
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

