


import 'package:go_router/go_router.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/splash_screen.dart';

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
