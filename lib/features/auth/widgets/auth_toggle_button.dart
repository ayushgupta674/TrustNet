import 'package:flutter/material.dart';

class AuthToggleButton extends StatelessWidget {
  final bool isLoginMode;
  final VoidCallback onToggle;

  const AuthToggleButton({
    super.key,
    required this.isLoginMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            isLoginMode ? "Don't have an account?" : 'Already have an account?',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: onToggle,
            child: Text(
              isLoginMode ? 'Sign up' : 'Log in',
              style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}