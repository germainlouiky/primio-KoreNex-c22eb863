import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../theme/theme.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  bool _isLoading = false;

  Future<void> _handleManageSubscription() async {
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
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing & Invoices'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // Current plan summary
          Container(
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
              border: Border.all(color: colors.primary.withOpacity(0.30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: colors.primary, size: AppTheme.iconMd),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text('Current Plan', style: text.labelMedium?.copyWith(color: colors.primary)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: 2),
                      decoration: BoxDecoration(
                        color: appColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text('Active', style: text.labelSmall?.copyWith(color: appColors.success)),
                    ),
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
                Text('Next billing: July 26, 2026', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/pricing'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          side: BorderSide(color: colors.primary.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                        ),
                        child: Text('Change Plan', style: text.labelMedium?.copyWith(color: colors.primary)),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _handleManageSubscription,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          side: BorderSide(color: appColors.danger.withOpacity(0.4)),
                          foregroundColor: appColors.danger,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: appColors.danger),
                              )
                            : Text('Cancel Plan', style: text.labelMedium?.copyWith(color: appColors.danger)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Payment method
          Text(
            'PAYMENT METHOD',
            style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: appColors.toolCardBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(Icons.credit_card_rounded, color: colors.primary, size: AppTheme.iconMd),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visa ending in 4242', style: text.bodyMedium),
                      Text('Expires 09/2028', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment method update coming soon')),
                    );
                  },
                  child: Text('Update', style: text.labelMedium?.copyWith(color: colors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Invoice history
          Row(
            children: [
              Expanded(
                child: Text(
                  'INVOICE HISTORY',
                  style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading all invoices...')),
                  );
                },
                icon: Icon(Icons.download_rounded, size: AppTheme.iconSm, color: colors.primary),
                label: Text('Download All', style: text.labelSmall?.copyWith(color: colors.primary)),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            decoration: BoxDecoration(
              color: appColors.toolCardBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
            ),
            child: Column(
              children: List.generate(_invoices.length, (i) {
                final inv = _invoices[i];
                final isLast = i == _invoices.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingMd,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(inv.description, style: text.bodyMedium),
                                Text(inv.date, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(inv.amount, style: text.bodyMedium),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: appColors.success.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Paid', style: text.labelSmall?.copyWith(color: appColors.success)),
                              ),
                            ],
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          IconButton(
                            icon: Icon(Icons.download_rounded, size: AppTheme.iconSm, color: appColors.subtleText),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloading ${inv.description}...')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: AppTheme.spacingMd,
                        color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ),
    );
  }
}

class _Invoice {
  final String description;
  final String date;
  final String amount;

  const _Invoice(this.description, this.date, this.amount);
}

const _invoices = [
  _Invoice('Professional Plan — July 2026', 'Jul 1, 2026', '\$149.00'),
  _Invoice('Professional Plan — June 2026', 'Jun 1, 2026', '\$149.00'),
  _Invoice('Professional Plan — May 2026', 'May 1, 2026', '\$149.00'),
  _Invoice('Professional Plan — April 2026', 'Apr 1, 2026', '\$149.00'),
  _Invoice('Starter Plan — March 2026', 'Mar 1, 2026', '\$49.00'),
  _Invoice('Starter Plan — February 2026', 'Feb 1, 2026', '\$49.00'),
];
