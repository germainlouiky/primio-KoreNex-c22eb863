import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class _ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color Function(AppColorsExtension) colorFn;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.colorFn,
  });
}

final _activities = <_ActivityItem>[
  _ActivityItem(
    title: 'New contract match',
    subtitle: 'USAF IT Modernization — \$4.2M',
    time: '2m ago',
    icon: Icons.article_outlined,
    colorFn: (c) => c.success,
  ),
  _ActivityItem(
    title: 'Bid deadline approaching',
    subtitle: 'VA Health Records System — Due in 3 days',
    time: '1h ago',
    icon: Icons.schedule_rounded,
    colorFn: (c) => c.warning,
  ),
  _ActivityItem(
    title: 'Proposal submitted',
    subtitle: 'DHS Cybersecurity Assessment — \$1.5M',
    time: '3h ago',
    icon: Icons.check_circle_outline_rounded,
    colorFn: (c) => c.success,
  ),
  _ActivityItem(
    title: 'Set-aside alert',
    subtitle: '8(a) opportunity in your NAICS codes',
    time: '5h ago',
    icon: Icons.star_outline_rounded,
    colorFn: (c) => c.warning,
  ),
  _ActivityItem(
    title: 'Compliance review complete',
    subtitle: 'DOD Cloud Migration — No issues found',
    time: 'Yesterday',
    icon: Icons.verified_outlined,
    colorFn: (c) => c.success,
  ),
];

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Recent Activity', style: text.titleLarge)),
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Full activity log coming soon')),
              ),
              child: Text(
                'View all',
                style: text.labelMedium?.copyWith(color: colors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activities.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
            ),
            itemBuilder: (context, index) {
              final item = _activities[index];
              final accentColor = item.colorFn(appColors);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingMd,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingSm),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(AppTheme.opacityOverlay),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Icon(item.icon, color: accentColor, size: AppTheme.iconSm),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppTheme.spacingXs),
                          Text(
                            item.subtitle,
                            style: text.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      item.time,
                      style: text.labelSmall?.copyWith(color: appColors.subtleText),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
