// lib/features/auth/widgets/auth_form_fields.dart
import 'package:flutter/material.dart';

class AuthFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? nameController;
  final bool isLoginMode;
  final String selectedRole; // 'NGO' or 'DONOR'

  const AuthFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.confirmPasswordController,
    this.nameController,
    required this.isLoginMode,
    required this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    final isNGO = selectedRole.toUpperCase() == 'NGO';
    // Show name field only for DONOR (or if isLoginMode false and not NGO)
    final showNameField = !isLoginMode && !isNGO;

    return Column(
      children: [
        // Name field (only for DONOR registration)
        if (showNameField)
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        if (showNameField) const SizedBox(height: 16),

        // Email field
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 20),

        // Password field
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),

        // Confirm password (only in signup mode)
        if (!isLoginMode) ...[
          const SizedBox(height: 20),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ],
    );
  }
}