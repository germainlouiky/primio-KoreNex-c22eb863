import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _newContracts = true;
  bool _bidDeadlines = true;
  bool _proposalUpdates = true;
  bool _teamActivity = false;
  bool _vendorAlerts = true;
  bool _weeklyDigest = true;
  bool _productUpdates = false;
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          _SectionHeader(label: 'DELIVERY CHANNELS', text: text, appColors: appColors),
          const SizedBox(height: AppTheme.spacingSm),
          _ToggleGroup(
            colors: colors,
            text: text,
            appColors: appColors,
            items: [
              _ToggleItem(
                icon: Icons.notifications_active_rounded,
                label: 'Push Notifications',
                subtitle: 'Alerts on your device',
                value: _pushEnabled,
                onChanged: (v) => setState(() => _pushEnabled = v),
              ),
              _ToggleItem(
                icon: Icons.email_outlined,
                label: 'Email Notifications',
                subtitle: 'Sent to jane.doe@acme-corp.com',
                value: _emailEnabled,
                onChanged: (v) => setState(() => _emailEnabled = v),
              ),
              _ToggleItem(
                icon: Icons.sms_outlined,
                label: 'SMS Notifications',
                subtitle: 'Text messages to your phone',
                value: _smsEnabled,
                onChanged: (v) => setState(() => _smsEnabled = v),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _SectionHeader(label: 'ALERT TYPES', text: text, appColors: appColors),
          const SizedBox(height: AppTheme.spacingSm),
          _ToggleGroup(
            colors: colors,
            text: text,
            appColors: appColors,
            items: [
              _ToggleItem(
                icon: Icons.search_rounded,
                label: 'New Contract Matches',
                subtitle: 'When new contracts match your profile',
                value: _newContracts,
                onChanged: (v) => setState(() => _newContracts = v),
              ),
              _ToggleItem(
                icon: Icons.timer_outlined,
                label: 'Bid Deadlines',
                subtitle: '48h and 24h before closing',
                value: _bidDeadlines,
                onChanged: (v) => setState(() => _bidDeadlines = v),
              ),
              _ToggleItem(
                icon: Icons.folder_open_rounded,
                label: 'Proposal Updates',
                subtitle: 'Status changes on your proposals',
                value: _proposalUpdates,
                onChanged: (v) => setState(() => _proposalUpdates = v),
              ),
              _ToggleItem(
                icon: Icons.group_outlined,
                label: 'Team Activity',
                subtitle: 'When teammates take action',
                value: _teamActivity,
                onChanged: (v) => setState(() => _teamActivity = v),
              ),
              _ToggleItem(
                icon: Icons.handshake_outlined,
                label: 'Vendor Alerts',
                subtitle: 'New vendor matches and updates',
                value: _vendorAlerts,
                onChanged: (v) => setState(() => _vendorAlerts = v),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _SectionHeader(label: 'DIGEST & UPDATES', text: text, appColors: appColors),
          const SizedBox(height: AppTheme.spacingSm),
          _ToggleGroup(
            colors: colors,
            text: text,
            appColors: appColors,
            items: [
              _ToggleItem(
                icon: Icons.summarize_outlined,
                label: 'Weekly Digest',
                subtitle: 'Summary of activity every Monday',
                value: _weeklyDigest,
                onChanged: (v) => setState(() => _weeklyDigest = v),
              ),
              _ToggleItem(
                icon: Icons.new_releases_outlined,
                label: 'Product Updates',
                subtitle: 'New features and improvements',
                value: _productUpdates,
                onChanged: (v) => setState(() => _productUpdates = v),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            height: AppTheme.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification preferences saved')),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save Preferences'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _SectionHeader({required this.label, required this.text, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
    );
  }
}

class _ToggleGroup extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;
  final List<_ToggleItem> items;

  const _ToggleGroup({
    required this.colors,
    required this.text,
    required this.appColors,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                child: Row(
                  children: [
                    Icon(items[i].icon, color: appColors.subtleText, size: AppTheme.iconMd),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[i].label, style: text.bodyMedium),
                          Text(
                            items[i].subtitle,
                            style: text.bodySmall?.copyWith(color: appColors.subtleText),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: items[i].value,
                      onChanged: items[i].onChanged,
                      activeColor: colors.primary,
                    ),
                  ],
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
    );
  }
}

class _ToggleItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}
