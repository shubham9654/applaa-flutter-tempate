import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    User? user;
    bool isAuthenticated = false;
    try {
      user = FirebaseAuth.instance.currentUser;
      isAuthenticated = user != null;
    } catch (e) {
      isAuthenticated = false;
    }

    // Check if ProfileBloc is available
    bool hasProfileBloc = false;
    try {
      context.read<ProfileBloc>();
      hasProfileBloc = true;
    } catch (e) {
      hasProfileBloc = false;
    }

    // If not authenticated, show demo UI
    if (!isAuthenticated || !hasProfileBloc) {
      return _buildDemoProfileUI(context);
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

  Widget _buildDemoProfileUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF6C5CE7),
                  child: const Text(
                    'JD',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            // Profile Fields
            _buildProfileField(
              label: 'Full Name',
              value: 'John Doe',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildProfileField(
              label: 'Email',
              value: 'john.doe@example.com',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            _buildProfileField(
              label: 'Phone Number',
              value: '+1 (555) 123-4567',
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),
            _buildProfileField(
              label: 'Bio',
              value: 'Software developer passionate about creating amazing apps.',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6C5CE7),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

