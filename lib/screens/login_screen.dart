import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../theme/theme.dart';
import '../widgets/auth/captcha_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _obscure = true;
  bool _isSignUp = false;
  bool _rememberMe = false;
  bool _captchaVerified = false;

  static const _prefKeyEmail = 'remembered_email';
  static const _prefKeyRemember = 'remember_me';

  // Password strength: 0=empty, 1=weak, 2=fair, 3=strong, 4=very strong
  int _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    if (_isSignUp) {
      setState(() => _passwordStrength = _calcStrength(_passwordController.text));
    }
  }

  int _calcStrength(String p) {
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(p) && RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(p)) score++;
    if (score <= 1) return 1;
    if (score == 2) return 2;
    if (score == 3) return 3;
    return 4;
  }

  Future<void> _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool(_prefKeyRemember) ?? false;
    if (remembered) {
      final email = prefs.getString(_prefKeyEmail) ?? '';
      if (mounted) {
        setState(() {
          _rememberMe = true;
          _emailController.text = email;
        });
      }
    }
  }

  Future<void> _saveRememberMe(String email) async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool(_prefKeyRemember, true);
      await prefs.setString(_prefKeyEmail, email);
    } else {
      await prefs.remove(_prefKeyRemember);
      await prefs.remove(_prefKeyEmail);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  String? _errorText;

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Please enter your email and password.');
      return;
    }

    if (_isSignUp) {
      if (username.isEmpty) {
        setState(() => _errorText = 'Please choose a username.');
        return;
      }
      if (password.length < 8) {
        setState(() => _errorText = 'Password must be at least 8 characters.');
        return;
      }
      if (_passwordStrength < 2) {
        setState(() => _errorText = 'Please choose a stronger password (see tips below).');
        return;
      }
    }

    setState(() => _errorText = null);
    final auth = context.read<AuthProvider>();
    bool success;

    if (_isSignUp) {
      success = await auth.signUp(
        email: email,
        password: password,
        username: username,
      );
      if (mounted && success) {
        if (auth.isAuthenticated) {
          await _saveRememberMe(email);
          context.go('/dashboard');
          return;
        }
        setState(() {
          _isSignUp = false;
          _errorText = null;
          _passwordStrength = 0;
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
      await _saveRememberMe(email);
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

  Color _strengthColor(ColorScheme colors) {
    switch (_passwordStrength) {
      case 1: return colors.error;
      case 2: return const Color(0xFFF59E0B);
      case 3: return const Color(0xFF22C55E);
      case 4: return const Color(0xFF16A34A);
      default: return colors.outlineVariant;
    }
  }

  String _strengthLabel() {
    switch (_passwordStrength) {
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Strong';
      case 4: return 'Very Strong';
      default: return '';
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

              // ── Username field (sign-up only) ──────────────────────────
              if (_isSignUp) ...[
                Text('Username', style: text.labelLarge),
                const SizedBox(height: AppTheme.spacingSm),
                TextField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Choose a display name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
              ],

              // ── Email ──────────────────────────────────────────────────
              Text('Email', style: text.labelLarge),
              const SizedBox(height: AppTheme.spacingSm),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'you@company.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // ── Password ───────────────────────────────────────────────
              Text('Password', style: text.labelLarge),
              const SizedBox(height: AppTheme.spacingSm),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => isLoading ? null : _handleAuth(),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              // ── Password strength meter (sign-up only) ─────────────────
              if (_isSignUp) ...[
                const SizedBox(height: AppTheme.spacingSm),
                Row(
                  children: List.generate(4, (i) {
                    final filled = _passwordStrength > i;
                    final barColor = filled ? _strengthColor(colors) : colors.outlineVariant;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                if (_passwordStrength > 0) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _strengthLabel(),
                      style: text.labelSmall?.copyWith(color: _strengthColor(colors)),
                    ),
                  ),
                ],
                const SizedBox(height: AppTheme.spacingSm),
                // Tips card
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield_outlined, size: AppTheme.iconSm, color: colors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Strong password tips',
                            style: text.labelSmall?.copyWith(color: colors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ...[
                        ('At least 8 characters', _passwordController.text.length >= 8),
                        ('Upper & lowercase letters', RegExp(r'[A-Z]').hasMatch(_passwordController.text) && RegExp(r'[a-z]').hasMatch(_passwordController.text)),
                        ('At least one number', RegExp(r'[0-9]').hasMatch(_passwordController.text)),
                        ('A special character (!@#\$%…)', RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(_passwordController.text)),
                      ].map((tip) {
                        final met = tip.$2;
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                met ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                size: 14,
                                color: met ? const Color(0xFF22C55E) : colors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tip.$1,
                                style: text.labelSmall?.copyWith(
                                  color: met ? colors.onSurface : colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // ── CAPTCHA ───────────────────────────────────────────
                const SizedBox(height: AppTheme.spacingMd),
                CaptchaWidget(
                  key: ValueKey(_isSignUp),
                  onVerified: (ok) => setState(() => _captchaVerified = ok),
                ),
              ],

              const SizedBox(height: AppTheme.spacingSm),

              // ── Remember me / Forgot password row ─────────────────────
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: isLoading
                          ? null
                          : (val) => setState(() => _rememberMe = val ?? false),
                      activeColor: colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => setState(() => _rememberMe = !_rememberMe),
                    child: Text(
                      'Remember me',
                      style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ),
                  const Spacer(),
                  if (!_isSignUp)
                    TextButton(
                      onPressed: isLoading ? null : _handleForgotPassword,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: text.labelMedium?.copyWith(color: colors.primary),
                      ),
                    ),
                ],
              ),

              // ── Error banner ───────────────────────────────────────────
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
                onPressed: (isLoading || (_isSignUp && !_captchaVerified)) ? null : _handleAuth,
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
                      _passwordStrength = 0;
                      _captchaVerified = false;
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
