import 'package:flutter/material.dart';
import '../../models/contract_result.dart';
import '../../theme/theme.dart';

class ContractResultCard extends StatelessWidget {
  final ContractResult contract;
  final VoidCallback onSaveToggle;
  final VoidCallback onTap;

  const ContractResultCard({
    super.key,
    required this.contract,
    required this.onSaveToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
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
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingSm,
                AppTheme.spacingSm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            contract.type.toUpperCase(),
                            style: text.labelSmall?.copyWith(
                              color: colors.primary,
                              letterSpacing: 0.8,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          contract.title,
                          style: text.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          contract.agency,
                          style: text.bodySmall?.copyWith(
                              color: appColors.subtleText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  // Win score + save button column
                  Column(
                    children: [
                      _WinScoreBadge(contract: contract),
                      const SizedBox(height: AppTheme.spacingXs),
                      IconButton(
                        onPressed: onSaveToggle,
                        icon: Icon(
                          contract.isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: contract.isSaved
                              ? colors.primary
                              : appColors.subtleText,
                          size: AppTheme.iconMd,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Synopsis
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd),
              child: Text(
                contract.synopsis,
                style: text.bodySmall
                    ?.copyWith(color: appColors.subtleText, height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            // Footer chips
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                0,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
              ),
              child: Wrap(
                spacing: AppTheme.spacingXs,
                runSpacing: AppTheme.spacingXs,
                children: [
                  _InfoChip(
                    icon: Icons.attach_money_rounded,
                    label: contract.value,
                    color: appColors.success,
                  ),
                  _InfoChip(
                    icon: Icons.schedule_rounded,
                    label: 'Due ${contract.dueDate}',
                    color: appColors.warning,
                  ),
                  _InfoChip(
                    icon: Icons.shield_rounded,
                    label: contract.setAsideShort,
                    color: colors.tertiary,
                  ),
                  _InfoChip(
                    icon: Icons.tag_rounded,
                    label: contract.naicsCode,
                    color: appColors.subtleText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WinScoreBadge extends StatelessWidget {
  final ContractResult contract;
  const _WinScoreBadge({required this.contract});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXs),
      decoration: BoxDecoration(
        color: contract.winScoreColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: contract.winScoreColor.withOpacity(0.25),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Column(
        children: [
          Text(
            '${contract.winScore}%',
            style: text.labelMedium?.copyWith(
              color: contract.winScoreColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            contract.winScoreLabel,
            style: text.labelSmall?.copyWith(
              color: contract.winScoreColor,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(0.2),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: text.labelSmall?.copyWith(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
