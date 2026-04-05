// lib/features/auth/providers/auth_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/auth_request.dart';
import '../data/models/auth_response.dart';

import '../data/repositories/auth_repository.dart';

enum AuthUserType { ngo, user }
final authTypeProvider = StateProvider<AuthUserType>((ref) => AuthUserType.user);

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthActionNotifier extends StateNotifier<AsyncValue<AuthResponse?>> {
  AuthActionNotifier(this._ref) : super(const AsyncValue.data(null));
  final Ref _ref;

  // Now returns Future<AuthResponse>
  Future<AuthResponse> performAction(dynamic action) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(authRepositoryProvider);
      final result = action is LoginRequest
          ? await repo.login(action)
          : await repo.register(action as RegisterRequest);
      state = AsyncValue.data(result);
      return result; // Return the result for direct use
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

final authActionProvider = StateNotifierProvider<AuthActionNotifier, AsyncValue<AuthResponse?>>((ref) {
  return AuthActionNotifier(ref);
});