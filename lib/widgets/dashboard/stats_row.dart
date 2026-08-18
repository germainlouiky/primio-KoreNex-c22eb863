import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../common/stat_card.dart';

class StatsRow extends StatelessWidget {
  final int activeProposals;
  final int upcomingDeadlines;
  final double winRate;

  const StatsRow({
    super.key,
    required this.activeProposals,
    required this.upcomingDeadlines,
    required this.winRate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatCard(
              label: 'Active',
              value: '$activeProposals',
              icon: Icons.description_outlined,
              accentColor: colors.primary,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: StatCard(
              label: 'Deadlines',
              value: '$upcomingDeadlines',
              icon: Icons.schedule_rounded,
              accentColor: appColors.warning,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: StatCard(
              label: 'Win Rate',
              value: '${winRate.toInt()}%',
              icon: Icons.trending_up_rounded,
              accentColor: appColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
