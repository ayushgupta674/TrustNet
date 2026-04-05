import 'package:flutter/material.dart';
import '../../core/storage/storage_manager.dart';
import '../../features/auth/views/login_screen.dart';

class LogoutUtil {
  static Future<void> logout(BuildContext context) async {
    await StorageManager.clear();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
      );
    }
  }
}