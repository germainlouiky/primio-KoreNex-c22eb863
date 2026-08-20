import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../theme/theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingSm),
              _ProfileHeader(colors: colors, text: text, appColors: appColors),
              const SizedBox(height: AppTheme.spacingLg),
              _CurrentPlanCard(colors: colors, text: text, appColors: appColors),
              const SizedBox(height: AppTheme.spacingLg),
              _UsageSection(colors: colors, text: text, appColors: appColors),
              const SizedBox(height: AppTheme.spacingLg),
              _SettingsSection(colors: colors, text: text, appColors: appColors),
              const SizedBox(height: AppTheme.spacingLg),
              _SignOutButton(colors: colors, text: text),
              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _ProfileHeader({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.userEmail;
    final initials = auth.userInitials;

    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.secondary],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          child: Center(
            child: Text(
              initials,
              style: text.titleLarge?.copyWith(color: colors.onPrimary),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email, style: text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                email,
                style: text.bodySmall?.copyWith(color: appColors.subtleText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  'Professional Plan',
                  style: text.labelSmall?.copyWith(color: colors.primary),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile editing coming soon')),
            );
          },
          icon: Icon(Icons.edit_outlined, color: appColors.subtleText, size: AppTheme.iconMd),
        ),
      ],
    );
  }
}

class _CurrentPlanCard extends StatefulWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _CurrentPlanCard({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  State<_CurrentPlanCard> createState() => _CurrentPlanCardState();
}

class _CurrentPlanCardState extends State<_CurrentPlanCard> {
  bool _isLoading = false;

  Future<void> _handleManageSubscription(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in first')),
          );
        }
        return;
      }

      final response = await http.post(
        Uri.parse('https://zxwhkgcrtlvemqabcint.supabase.co/functions/v1/create-portal-session'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final portalUrl = data['url'];
        if (portalUrl != null) {
          await launchUrl(Uri.parse(portalUrl), webOnlyWindowName: '_self');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No active subscription found, or something went wrong.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final text = widget.text;
    final appColors = widget.appColors;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withOpacity(0.15),
            colors.secondary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: colors.primary.withOpacity(0.30), width: AppTheme.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: colors.primary, size: AppTheme.iconMd),
              const SizedBox(width: AppTheme.spacingSm),
              Text('Current Plan', style: text.labelMedium?.copyWith(color: colors.primary)),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Professional', style: text.headlineSmall),
              const Spacer(),
              Text('\$149', style: text.headlineSmall?.copyWith(color: colors.primary)),
              Text('/month', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Next billing date: July 26, 2026',
            style: text.bodySmall?.copyWith(color: appColors.subtleText),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => _handleManageSubscription(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    side: BorderSide(color: colors.primary.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primary,
                          ),
                        )
                      : Text('Manage Subscription', style: text.labelMedium?.copyWith(color: colors.primary)),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.go('/pricing'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                  child: Text('Upgrade', style: text.labelMedium?.copyWith(color: colors.onPrimary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UsageSection extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _UsageSection({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'USAGE THIS MONTH',
          style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Row(
          children: [
            Expanded(
              child: _UsageTile(
                label: 'Bids Written',
                value: '12',
                limit: 'Unlimited',
                icon: Icons.edit_note_rounded,
                color: const Color(0xFF8B5CF6),
                appColors: appColors,
                text: text,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: _UsageTile(
                label: 'Contracts Found',
                value: '247',
                limit: 'Unlimited',
                icon: Icons.search_rounded,
                color: const Color(0xFF3B82F6),
                appColors: appColors,
                text: text,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Row(
          children: [
            Expanded(
              child: _UsageTile(
                label: 'Proposals Active',
                value: '5',
                limit: '20 max',
                icon: Icons.folder_open_rounded,
                color: const Color(0xFFEC4899),
                appColors: appColors,
                text: text,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: _UsageTile(
                label: 'Vendors Matched',
                value: '34',
                limit: 'Unlimited',
                icon: Icons.handshake_rounded,
                color: const Color(0xFF06B6D4),
                appColors: appColors,
                text: text,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UsageTile extends StatelessWidget {
  final String label;
  final String value;
  final String limit;
  final IconData icon;
  final Color color;
  final AppColorsExtension appColors;
  final TextTheme text;

  const _UsageTile({
    required this.label,
    required this.value,
    required this.limit,
    required this.icon,
    required this.color,
    required this.appColors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppTheme.iconSm),
          const SizedBox(height: AppTheme.spacingSm),
          Text(value, style: text.headlineSmall?.copyWith(color: color)),
          Text(label, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
          Text(limit, style: text.labelSmall?.copyWith(color: appColors.subtleText)),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _SettingsSection({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _SettingsItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.push('/notifications')),
      _SettingsItem(icon: Icons.security_outlined, label: 'Security & Password', onTap: () => context.push('/security')),
      _SettingsItem(icon: Icons.payment_outlined, label: 'Billing & Invoices', onTap: () => context.push('/billing')),
      _SettingsItem(icon: Icons.group_outlined, label: 'Team Members', onTap: () => context.push('/team')),
      _SettingsItem(icon: Icons.integration_instructions_outlined, label: 'Integrations', onTap: () => context.push('/integrations')),
      _SettingsItem(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () => context.push('/help')),
      _SettingsItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () => context.push('/privacy')),
      _SettingsItem(icon: Icons.gavel_rounded, label: 'Terms of Service', onTap: () => context.push('/terms')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SETTINGS',
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
            children: List.generate(items.length, (index) {
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: items[index].onTap,
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(AppTheme.radiusMedium) : Radius.zero,
                      bottom: isLast ? const Radius.circular(AppTheme.radiusMedium) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingMd,
                      ),
                      child: Row(
                        children: [
                          Icon(items[index].icon, color: appColors.subtleText, size: AppTheme.iconMd),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(child: Text(items[index].label, style: text.bodyMedium)),
                          Icon(Icons.chevron_right_rounded, color: appColors.subtleText, size: AppTheme.iconMd),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: AppTheme.spacingMd + AppTheme.iconMd + AppTheme.spacingMd,
                      color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsItem({required this.icon, required this.label, required this.onTap});
}



class _SignOutButton extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;

  const _SignOutButton({required this.colors, required this.text});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    return SizedBox(
      width: double.infinity,
      height: AppTheme.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: () async {
          await context.read<AuthProvider>().signOut();
          if (context.mounted) context.go('/login');
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: appColors.danger.withOpacity(0.40), width: AppTheme.borderDefault),
          foregroundColor: appColors.danger,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        ),
        icon: Icon(Icons.logout_rounded, size: AppTheme.iconSm, color: appColors.danger),
        label: Text('Sign Out', style: text.labelLarge?.copyWith(color: appColors.danger)),
      ),
    );
  }
}
