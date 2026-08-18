import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(AppTheme.opacityOverlay),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 48, color: colors.primary),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Text(title, style: text.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  'This feature is coming soon. Stay tuned!',
                  style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
