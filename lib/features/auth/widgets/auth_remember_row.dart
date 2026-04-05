// lib/features/auth/widgets/auth_remember_row.dart
import 'package:flutter/material.dart';

class AuthRememberRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onForgotPassword;

  const AuthRememberRow({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(  // 👈 prevents overflow
          child: Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
                activeColor: const Color(0xFF7C3AED),
              ),
              const Flexible(child: Text('Remember me')),
            ],
          ),
        ),
        Flexible(  // 👈 prevents overflow
          child: TextButton(
            onPressed: onForgotPassword,
            child: const Text('Forgot Password?'),
          ),
        ),
      ],
    );
  }
}