import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;

  const DashboardHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: text.bodyMedium),
              Text(userName, style: text.headlineMedium),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
            icon: Badge(
              smallSize: 8,
              backgroundColor: theme.extension<AppColorsExtension>()!.danger,
              child: Icon(Icons.notifications_outlined, color: colors.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}
