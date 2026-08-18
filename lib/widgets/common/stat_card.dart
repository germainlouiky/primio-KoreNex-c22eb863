import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: theme.extension<AppColorsExtension>()!.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: accentColor.withOpacity(AppTheme.opacityOverlay),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(AppTheme.opacityOverlay),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: accentColor, size: AppTheme.iconSm),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(value, style: text.headlineSmall?.copyWith(color: accentColor), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppTheme.spacingXs),
          Text(label, style: text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
