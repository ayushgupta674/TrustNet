// lib/features/auth/widgets/auth_submit_button.dart
import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoginMode;
  final bool isLoading;

  const AuthSubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoginMode,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Text(
        isLoginMode ? 'Log in' : 'Sign up',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}