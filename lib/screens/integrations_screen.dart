import 'package:flutter/material.dart';
import '../theme/theme.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  final List<_Integration> _integrations = [
    _Integration(
      name: 'SAM.gov',
      description: 'Sync federal contract opportunities automatically',
      category: 'Government',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF3B82F6),
      isConnected: true,
    ),
    _Integration(
      name: 'Salesforce CRM',
      description: 'Push won contracts to your CRM pipeline',
      category: 'CRM',
      icon: Icons.cloud_rounded,
      color: Color(0xFF00A1E0),
      isConnected: true,
    ),
    _Integration(
      name: 'DocuSign',
      description: 'E-sign contracts without leaving KoreNex',
      category: 'Documents',
      icon: Icons.draw_rounded,
      color: Color(0xFFFFBF00),
      isConnected: false,
    ),
    _Integration(
      name: 'Microsoft Teams',
      description: 'Get contract alerts and updates in Teams',
      category: 'Communication',
      icon: Icons.groups_rounded,
      color: Color(0xFF6264A7),
      isConnected: false,
    ),
    _Integration(
      name: 'Slack',
      description: 'Notify your team of new matches in Slack',
      category: 'Communication',
      icon: Icons.chat_rounded,
      color: Color(0xFF4A154B),
      isConnected: false,
    ),
    _Integration(
      name: 'QuickBooks',
      description: 'Sync invoices and billing to accounting',
      category: 'Finance',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF2CA01C),
      isConnected: false,
    ),
    _Integration(
      name: 'Google Drive',
      description: 'Store and share proposals in Drive',
      category: 'Documents',
      icon: Icons.drive_folder_upload_rounded,
      color: Color(0xFF4285F4),
      isConnected: false,
    ),
    _Integration(
      name: 'HubSpot',
      description: 'Sync contacts and deal tracking',
      category: 'CRM',
      icon: Icons.hub_rounded,
      color: Color(0xFFFF7A59),
      isConnected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    final connected = _integrations.where((i) => i.isConnected).toList();
    final available = _integrations.where((i) => !i.isConnected).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // Stats bar
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: 'Connected',
                  value: '${connected.length}',
                  color: appColors.success,
                  colors: colors,
                  text: text,
                  appColors: appColors,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: _StatChip(
                  label: 'Available',
                  value: '${available.length}',
                  color: colors.primary,
                  colors: colors,
                  text: text,
                  appColors: appColors,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),

          if (connected.isNotEmpty) ...[
            Text(
              'CONNECTED',
              style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Container(
              decoration: BoxDecoration(
                color: appColors.toolCardBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
              ),
              child: Column(
                children: List.generate(connected.length, (i) {
                  return _IntegrationTile(
                    integration: connected[i],
                    showDivider: i < connected.length - 1,
                    colors: colors,
                    text: text,
                    appColors: appColors,
                    onToggle: () => setState(() => connected[i].isConnected = !connected[i].isConnected),
                    context: context,
                  );
                }),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
          ],

          Text(
            'AVAILABLE',
            style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            decoration: BoxDecoration(
              color: appColors.toolCardBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
            ),
            child: Column(
              children: List.generate(available.length, (i) {
                return _IntegrationTile(
                  integration: available[i],
                  showDivider: i < available.length - 1,
                  colors: colors,
                  text: text,
                  appColors: appColors,
                  onToggle: () => setState(() => available[i].isConnected = !available[i].isConnected),
                  context: context,
                );
              }),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Request integration
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(Icons.add_circle_outline_rounded, color: colors.primary, size: AppTheme.iconLg),
                const SizedBox(height: AppTheme.spacingSm),
                Text('Don\'t see your tool?', style: text.titleSmall),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  'Request an integration and we\'ll prioritize it in our roadmap.',
                  style: text.bodySmall?.copyWith(color: appColors.subtleText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Integration request sent — thank you!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.primary.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                    ),
                    child: Text('Request an Integration', style: text.labelMedium?.copyWith(color: colors.primary)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ),
    );
  }
}

class _Integration {
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  bool isConnected;

  _Integration({
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.isConnected,
  });
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(value, style: text.headlineSmall?.copyWith(color: color)),
          const SizedBox(width: AppTheme.spacingSm),
          Text(label, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
        ],
      ),
    );
  }
}

class _IntegrationTile extends StatelessWidget {
  final _Integration integration;
  final bool showDivider;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;
  final VoidCallback onToggle;
  final BuildContext context;

  const _IntegrationTile({
    required this.integration,
    required this.showDivider,
    required this.colors,
    required this.text,
    required this.appColors,
    required this.onToggle,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: integration.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(integration.icon, color: integration.color, size: AppTheme.iconMd),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(integration.name, style: text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: AppTheme.spacingXs),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(integration.category, style: text.labelSmall?.copyWith(color: colors.primary)),
                        ),
                      ],
                    ),
                    Text(integration.description, style: text.bodySmall?.copyWith(color: appColors.subtleText), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Switch(
                value: integration.isConnected,
                onChanged: (_) {
                  onToggle();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(integration.isConnected ? '${integration.name} disconnected' : '${integration.name} connected'),
                    ),
                  );
                },
                activeColor: appColors.success,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppTheme.spacingMd,
            color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          ),
      ],
    );
  }
}
