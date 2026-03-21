import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  StreamSubscription<AuthState>? _subscription;

  @override
  User? build() {
    final client = Supabase.instance.client;
    _subscription = client.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
    ref.onDispose(() => _subscription?.cancel());
    return client.auth.currentUser;
  }

  Future<void> signInWithMagicLink(String email) async {
    await Supabase.instance.client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.zaiquest://login-callback',
    );
  }

  Future<void> signInWithPassword(String email, String password) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}

@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  final user = ref.watch(authNotifierProvider);
  return user?.id;
}
