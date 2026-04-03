import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoginMode;

  const AuthSubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoginMode,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Text(
        isLoginMode ? 'Log in' : 'Sign up',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}