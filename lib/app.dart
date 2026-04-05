import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/views/login_screen.dart';
import 'features/auth/views/splash_screen.dart';


// Simple router without any redirects
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
    ),
  ],
);

class UnityNodeApp extends StatelessWidget {
  const UnityNodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Unity Node',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}