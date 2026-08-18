import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  StreamSubscription<AuthState>? _authSub;

  bool _isLoading = false;
  String? _error;
  User? _user;

  AuthProvider({required SupabaseService supabaseService})
      : _supabaseService = supabaseService {
    _user = _supabaseService.currentUser;
    _authSub = _supabaseService.authStateChanges.listen((state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  String get userEmail => _user?.email ?? '';
  String get userInitials {
    final email = userEmail;
    if (email.isEmpty) return '?';
    return email[0].toUpperCase();
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      if (e.message.contains('Email not confirmed')) {
        _error = 'Please confirm your email before signing in. Check your inbox for a confirmation link.';
      } else if (e.message.contains('Invalid login credentials')) {
        _error = 'Invalid email or password. Please try again.';
      } else {
        _error = e.message;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabaseService.signUp(email: email, password: password);
      _isLoading = false;

      if (response.user != null && response.user!.identities != null && response.user!.identities!.isEmpty) {
        _error = 'An account with this email already exists.';
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
    } catch (_) {
      // Force local state clear even if network fails
    }
    _user = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Could not send reset email. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.updatePassword(newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Could not update password. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
