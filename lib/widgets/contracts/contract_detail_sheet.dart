import 'package:flutter/material.dart';
import '../../models/contract_result.dart';
import '../../theme/theme.dart';

class ContractDetailSheet extends StatelessWidget {
  final ContractResult contract;
  final VoidCallback onSaveToggle;

  const ContractDetailSheet({
    super.key,
    required this.contract,
    required this.onSaveToggle,
  });

  static void show(
    BuildContext context, {
    required ContractResult contract,
    required VoidCallback onSaveToggle,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContractDetailSheet(
        contract: contract,
        onSaveToggle: onSaveToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusXl),
            ),
            border: Border.all(
              color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd),
                  children: [
                    // Type + win score row
                    Wrap(
                      spacing: AppTheme.spacingSm,
                      runSpacing: AppTheme.spacingSm,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSm, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            contract.type.toUpperCase(),
                            style: text.labelSmall?.copyWith(
                                color: colors.primary, fontSize: 10),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingXs),
                          decoration: BoxDecoration(
                            color:
                                contract.winScoreColor.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                            border: Border.all(
                              color: contract.winScoreColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded,
                                  color: contract.winScoreColor,
                                  size: AppTheme.iconSm),
                              const SizedBox(width: AppTheme.spacingXs),
                              Text(
                                '${contract.winScore}% Win',
                                style: text.labelMedium?.copyWith(
                                    color: contract.winScoreColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    // Title
                    Text(contract.title, style: text.titleLarge),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(contract.agency,
                        style: text.bodyMedium
                            ?.copyWith(color: appColors.subtleText)),
                    const SizedBox(height: AppTheme.spacingLg),
                    // Key details grid
                    _SectionLabel(label: 'Contract Details', appColors: appColors),
                    const SizedBox(height: AppTheme.spacingMd),
                    _DetailsGrid(contract: contract, colors: colors, text: text, appColors: appColors),
                    const SizedBox(height: AppTheme.spacingLg),
                    // Synopsis
                    _SectionLabel(label: 'Synopsis', appColors: appColors),
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      contract.synopsis,
                      style: text.bodyMedium?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              onSaveToggle();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              contract.isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: AppTheme.iconSm,
                            ),
                            label: Text(
                                contract.isSaved ? 'Saved' : 'Save'),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMd),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.edit_note_rounded,
                                size: AppTheme.iconSm),
                            label: const Text('Write Bid'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColorsExtension appColors;
  const _SectionLabel({required this.label, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: appColors.subtleText,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  final ContractResult contract;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _DetailsGrid({
    required this.contract,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailItem(
          icon: Icons.attach_money_rounded,
          label: 'Contract Value',
          value: contract.value,
          color: appColors.success),
      _DetailItem(
          icon: Icons.schedule_rounded,
          label: 'Due Date',
          value: contract.dueDate,
          color: appColors.warning),
      _DetailItem(
          icon: Icons.calendar_today_rounded,
          label: 'Posted',
          value: contract.postedDate,
          color: appColors.subtleText),
      _DetailItem(
          icon: Icons.tag_rounded,
          label: 'NAICS Code',
          value: contract.naicsCode,
          color: colors.tertiary),
      _DetailItem(
          icon: Icons.shield_rounded,
          label: 'Set-Aside',
          value: contract.setAside,
          color: colors.secondary),
      _DetailItem(
          icon: Icons.description_rounded,
          label: 'Notice Type',
          value: contract.type,
          color: colors.primary),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingMd),
                child: Row(
                  children: [
                    Icon(item.icon, color: item.color, size: AppTheme.iconSm),
                    const SizedBox(width: AppTheme.spacingMd),
                    Text(item.label,
                        style: text.bodySmall
                            ?.copyWith(color: appColors.subtleText)),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        item.value,
                        style: text.labelMedium
                            ?.copyWith(color: colors.onSurface),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: colors.outlineVariant
                      .withOpacity(AppTheme.opacityOverlay),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
