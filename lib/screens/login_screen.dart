import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _errorText;

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Please enter email and password.');
      return;
    }

    if (_isSignUp && password.length < 6) {
      setState(() => _errorText = 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _errorText = null);
    final auth = context.read<AuthProvider>();
    bool success;

    if (_isSignUp) {
      success = await auth.signUp(email: email, password: password);
      if (mounted && success) {
        // If Supabase returned a session (email confirmation disabled), go straight in
        if (auth.isAuthenticated) {
          context.go('/dashboard');
          return;
        }
        // Otherwise email confirmation is required
        setState(() {
          _isSignUp = false;
          _errorText = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Check your email to confirm, then sign in.'),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }
    } else {
      success = await auth.signIn(email: email, password: password);
    }

    if (success && mounted) {
      context.go('/dashboard');
    } else if (mounted) {
      setState(() => _errorText = auth.error ?? 'Authentication failed. Please try again.');
      auth.clearError();
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email above first')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.resetPassword(email);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Password reset email sent to $email'
                : auth.error ?? 'Could not send reset email',
          ),
        ),
      );
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.primary, colors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Icon(Icons.hub_rounded, size: AppTheme.iconLg, color: colors.onPrimary),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text('KoreNex', style: text.headlineMedium),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                'Win More. Work Smarter.',
                style: text.titleMedium?.copyWith(color: colors.primary),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                'One platform. Every procurement workflow.',
                style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
              Text('Email', style: text.labelLarge),
              const SizedBox(height: AppTheme.spacingSm),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'you@company.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text('Password', style: text.labelLarge),
              const SizedBox(height: AppTheme.spacingSm),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              if (!_isSignUp) ...[
                const SizedBox(height: AppTheme.spacingSm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : _handleForgotPassword,
                    child: Text('Forgot password?', style: text.labelMedium?.copyWith(color: colors.primary)),
                  ),
                ),
              ],
              if (_errorText != null) ...[
                const SizedBox(height: AppTheme.spacingMd),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: colors.onErrorContainer, size: AppTheme.iconSm),
                      const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: Text(
                          _errorText!,
                          style: text.bodySmall?.copyWith(color: colors.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppTheme.spacingMd),
              ElevatedButton(
                onPressed: isLoading ? null : _handleAuth,
                child: isLoading
                    ? SizedBox(
                        height: AppTheme.iconSm,
                        width: AppTheme.iconSm,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      )
                    : Text(_isSignUp ? 'Create Account' : 'Sign In'),
              ),
              const SizedBox(height: AppTheme.spacingXl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp ? 'Already have an account? ' : "Don't have an account? ",
                    style: text.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _isSignUp = !_isSignUp;
                      context.read<AuthProvider>().clearError();
                    }),
                    child: Text(
                      _isSignUp ? 'Sign In' : 'Start Free Trial',
                      style: text.bodySmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}
