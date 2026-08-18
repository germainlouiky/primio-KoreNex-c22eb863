import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  // ── Auth ──

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: username != null && username.isNotEmpty ? {'username': username} : null,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // ── Chat Messages (Nex) ──

  Future<List<Map<String, dynamic>>> loadChatMessages() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('chat_messages')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveChatMessage({
    required String text,
    required bool isUser,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    try {
      await _client.from('chat_messages').insert({
        'user_id': userId,
        'text': text,
        'is_user': isUser,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Silently fail — chat still works locally
    }
  }

  Future<void> clearChatMessages() async {
    final userId = currentUser?.id;
    if (userId == null) return;

    try {
      await _client.from('chat_messages').delete().eq('user_id', userId);
    } catch (_) {
      // Silently fail
    }
  }
}
