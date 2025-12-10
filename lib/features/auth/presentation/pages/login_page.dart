import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui';
import '../bloc/auth_bloc.dart';
import '../../../../core/constants/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      try {
        if (GetIt.instance.isRegistered<AuthBloc>()) {
          context.read<AuthBloc>().add(
                SignInRequested(
                  _emailController.text.trim(),
                  _passwordController.text,
                ),
              );
        }
      } catch (e) {
        // Silently handle errors - UI will still show
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if AuthBloc is available in the widget tree
    bool hasAuthBloc = false;
    try {
      context.read<AuthBloc>();
      hasAuthBloc = true;
    } catch (e) {
      hasAuthBloc = false;
    }

    return Scaffold(
      body: hasAuthBloc
          ? BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  context.go(AppConstants.homeRoute);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return _buildLoginUI(context, state);
              },
            )
          : _buildLoginUI(context, null),
    );
  }

  Widget _buildLoginUI(BuildContext context, AuthState? state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Stack(
        children: [
          // Animated Background Blobs
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 288,
              height: 288,
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: Colors.purple[300]!.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                color: Colors.indigo[300]!.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Glassmorphism Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 400),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 32,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Header with Icon
                                Transform.rotate(
                                  angle: 0.05,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF6C5CE7),
                                          Color(0xFF818CF8)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6C5CE7)
                                              .withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.fingerprint,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter your credentials to access Applaa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Email Input
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style:
                                      const TextStyle(color: Color(0xFF1E293B)),
                                  decoration: InputDecoration(
                                    hintText: 'Email Address',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6C5CE7),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Password Input
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style:
                                      const TextStyle(color: Color(0xFF1E293B)),
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    prefixIcon: Icon(Icons.lock_outlined,
                                        color: Colors.grey[400]),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6C5CE7),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6C5CE7),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Sign In Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        (state != null && state is AuthLoading)
                                            ? null
                                            : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6C5CE7),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 10,
                                      shadowColor: const Color(0xFF6C5CE7)
                                          .withOpacity(0.5),
                                    ),
                                    child: (state != null &&
                                            state is AuthLoading)
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sign In',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward,
                                                  size: 18),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Biometric Login
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle biometric login
                                      },
                                      child: Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.face,
                                          color: Color(0xFF6C5CE7),
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Tap for FaceID',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color:
                                            Colors.grey[300]!.withOpacity(0.5),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        'Or continue with',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[400],
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color:
                                            Colors.grey[300]!.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Social Buttons (Neomorphic)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialButton(
                                        Icons.g_mobiledata, () {}),
                                    const SizedBox(width: 24),
                                    _buildSocialButton(Icons.apple, () {}),
                                    const SizedBox(width: 24),
                                    _buildSocialButton(Icons.facebook, () {}),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Footer
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.push(AppConstants.signupRoute);
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6C5CE7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Close Button
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  context.go(AppConstants.homeRoute);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[800],
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 10,
              offset: const Offset(-5, -5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: const Color(0xFF1E293B),
          size: 24,
        ),
      ),
    );
  }
}
