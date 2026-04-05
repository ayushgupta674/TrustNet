// lib/features/auth/views/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_manager.dart';
import '../../admin_panel/views/admin_dashboard_screen.dart';
import '../../ngo_dashboard/views/ngo_dashboard_screen.dart';
import '../../home/views/shorts_screen.dart';
import '../data/models/auth_request.dart';
import '../data/models/auth_response.dart';
import '../providers/auth_state_provider.dart';
import '../providers/ngo_profile_provider.dart';
import '../widgets/auth_user_selector.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_remember_row.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_toggle_button.dart';

import 'complete_nog_profile_screen.dart'; // ✅ Fixed typo

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoginMode = true;
  bool _rememberMe = false;

  // Controllers
  final _nameController = TextEditingController(); // Only used for DONOR registration
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _selectedRole {
    final type = ref.read(authTypeProvider);
    return type == AuthUserType.ngo ? 'NGO' : 'DONOR';
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final notifier = ref.read(authActionProvider.notifier);

    try {
      AuthResponse result;
      if (_isLoginMode) {
        final request = LoginRequest(email: email, password: password);
        result = await notifier.performAction(request);
      } else {
        // REGISTER
        final confirm = _confirmPasswordController.text.trim();
        if (password != confirm) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
          return;
        }

        String requestName;
        if (_selectedRole == 'NGO') {
          // NGO: placeholder (will be updated in profile completion)
          requestName = 'New NGO';
        } else {
          // DONOR: must provide full name
          final name = _nameController.text.trim();
          if (name.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter your full name')),
            );
            return;
          }
          requestName = name;
        }

        final request = RegisterRequest(
          name: requestName,
          email: email,
          password: password,
          role: _selectedRole,
        );
        result = await notifier.performAction(request);
      }

      // Save auth data
      await StorageManager.saveAuthData(
        token: result.token,
        userId: result.userId,
        role: result.role,
        name: result.name,
      );

      if (mounted) {
        // Pass `isRegistration: true` only for new NGO registrations
        final isRegistration = !_isLoginMode && result.role == 'NGO';
        await _navigateByRole(result.role, isRegistration: isRegistration);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: ${error.toString()}')),
        );
      }
    }
  }

  Future<void> _navigateByRole(String role, {bool isRegistration = false}) async {
    if (role == 'NGO') {
      if (isRegistration) {
        // New NGO → go directly to profile completion (skip completeness check)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompleteNgoProfileScreen()),
        );
      } else {
        // Existing NGO (login) → check if profile is complete
        final isComplete = await ref.read(isProfileCompleteProvider.future);
        if (mounted) {
          if (isComplete) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NgoDashboardScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CompleteNgoProfileScreen()),
            );
          }
        }
      }
    } else if (role == 'ADMIN') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
    }
    else {
      // DONOR
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ShortsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authActionProvider);
    final isLoading = authState.isLoading;
    String? error;
    authState.whenOrNull(error: (err, _) => error = err.toString());

    final selectedType = ref.watch(authTypeProvider);
    final formRole = selectedType == AuthUserType.ngo ? 'NGO' : 'DONOR';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.volunteer_activism, size: 70, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Unity Node',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const AuthUserSelector(),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _isLoginMode ? 'Welcome back' : 'Create account',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLoginMode
                              ? 'Sign in to continue'
                              : 'Join the best NGO management platform',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 32),
                        AuthFormFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          nameController: _nameController,
                          isLoginMode: _isLoginMode,
                          selectedRole: formRole,
                        ),
                        const SizedBox(height: 20),
                        if (_isLoginMode)
                          AuthRememberRow(
                            rememberMe: _rememberMe,
                            onRememberMeChanged: (value) =>
                                setState(() => _rememberMe = value ?? false),
                            onForgotPassword: () => print('Forgot password'),
                          ),
                        const SizedBox(height: 24),
                        if (error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(error!, style: const TextStyle(color: Colors.red)),
                          ),
                        AuthSubmitButton(
                          onPressed: _handleSubmit,
                          isLoginMode: _isLoginMode,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 16),
                        AuthToggleButton(
                          isLoginMode: _isLoginMode,
                          onToggle: () => setState(() => _isLoginMode = !_isLoginMode),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}