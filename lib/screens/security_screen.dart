import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/theme.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _currentObscured = true;
  bool _newObscured = true;
  bool _confirmObscured = true;
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _sessionAlerts = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.updatePassword(_newPasswordController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Password updated successfully'
                : auth.error ?? 'Could not update password',
          ),
        ),
      );
      auth.clearError();

      if (success) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Password'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // Change Password
          Text(
            'CHANGE PASSWORD',
            style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _currentObscured,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    suffixIcon: IconButton(
                      icon: Icon(_currentObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _currentObscured = !_currentObscured),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _newObscured,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(_newObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _newObscured = !_newObscured),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmObscured,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(_confirmObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _confirmObscured = !_confirmObscured),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v != _newPasswordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
                SizedBox(
                  width: double.infinity,
                  height: AppTheme.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _savePassword,
                    child: const Text('Update Password'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Password strength hint
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: colors.primary, size: AppTheme.iconSm),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text('Password Requirements', style: text.labelMedium?.copyWith(color: colors.primary)),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                for (final req in [
                  'At least 8 characters',
                  'One uppercase and one lowercase letter',
                  'At least one number',
                  'At least one special character (!@#\$%)',
                ])
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: appColors.subtleText, size: AppTheme.iconSm),
                        const SizedBox(width: AppTheme.spacingSm),
                        Text(req, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Security Settings
          Text(
            'SECURITY SETTINGS',
            style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            decoration: BoxDecoration(
              color: appColors.toolCardBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                width: AppTheme.borderDefault,
              ),
            ),
            child: Column(
              children: [
                _SecurityToggle(
                  icon: Icons.verified_user_outlined,
                  label: 'Two-Factor Authentication',
                  subtitle: 'Extra layer of account security',
                  value: _twoFactorEnabled,
                  onChanged: (v) => setState(() => _twoFactorEnabled = v),
                  colors: colors,
                  text: text,
                  appColors: appColors,
                  showDivider: true,
                ),
                _SecurityToggle(
                  icon: Icons.fingerprint_rounded,
                  label: 'Biometric Login',
                  subtitle: 'Use Face ID or fingerprint',
                  value: _biometricEnabled,
                  onChanged: (v) => setState(() => _biometricEnabled = v),
                  colors: colors,
                  text: text,
                  appColors: appColors,
                  showDivider: true,
                ),
                _SecurityToggle(
                  icon: Icons.devices_outlined,
                  label: 'New Login Alerts',
                  subtitle: 'Email alerts for new sign-ins',
                  value: _sessionAlerts,
                  onChanged: (v) => setState(() => _sessionAlerts = v),
                  colors: colors,
                  text: text,
                  appColors: appColors,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Active Sessions
          Text(
            'ACTIVE SESSIONS',
            style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            decoration: BoxDecoration(
              color: appColors.toolCardBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                width: AppTheme.borderDefault,
              ),
            ),
            child: Column(
              children: [
                for (final session in [
                  _SessionData('iPhone 15 Pro', 'iOS · New York, US', 'Active now', true),
                  _SessionData('Chrome on MacBook', 'macOS · New York, US', '2 hours ago', false),
                  _SessionData('KoreNex Web App', 'Chrome · New York, US', 'Yesterday', false),
                ])
                  _SessionTile(session: session, colors: colors, text: text, appColors: appColors),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            width: double.infinity,
            height: AppTheme.buttonHeight,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All other sessions signed out')),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: appColors.danger.withOpacity(0.4)),
                foregroundColor: appColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: const Text('Sign Out All Other Sessions'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ),
    );
  }
}

class _SecurityToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;
  final bool showDivider;

  const _SecurityToggle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.colors,
    required this.text,
    required this.appColors,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          child: Row(
            children: [
              Icon(icon, color: appColors.subtleText, size: AppTheme.iconMd),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.bodyMedium),
                    Text(subtitle, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                  ],
                ),
              ),
              Switch(value: value, onChanged: onChanged, activeColor: colors.primary),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppTheme.spacingMd + AppTheme.iconMd + AppTheme.spacingMd,
            color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          ),
      ],
    );
  }
}

class _SessionData {
  final String device;
  final String location;
  final String lastActive;
  final bool isCurrent;

  const _SessionData(this.device, this.location, this.lastActive, this.isCurrent);
}

class _SessionTile extends StatelessWidget {
  final _SessionData session;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _SessionTile({
    required this.session,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(Icons.devices_rounded, color: colors.primary, size: AppTheme.iconMd),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(session.device, style: text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    if (session.isCurrent) ...[
                      const SizedBox(width: AppTheme.spacingXs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: appColors.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Current', style: text.labelSmall?.copyWith(color: appColors.success)),
                      ),
                    ],
                  ],
                ),
                Text(session.location, style: text.bodySmall?.copyWith(color: appColors.subtleText), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(session.lastActive, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
