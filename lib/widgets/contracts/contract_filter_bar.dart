import 'package:flutter/material.dart';
import '../../providers/contracts_provider.dart';
import '../../theme/theme.dart';

class ContractFilterBar extends StatelessWidget {
  final ContractsProvider provider;

  const ContractFilterBar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Row(
        children: [
          _FilterDropdown(
            label: provider.selectedAgency == 'All Agencies'
                ? 'Agency'
                : provider.selectedAgency.split(' ').last,
            isActive: provider.selectedAgency != 'All Agencies',
            onTap: () => _showAgencyPicker(context, colors, text),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _FilterDropdown(
            label: provider.selectedSetAside == 'All Types'
                ? 'Set-Aside'
                : provider.selectedSetAside,
            isActive: provider.selectedSetAside != 'All Types',
            onTap: () => _showSetAsidePicker(context, colors, text),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _FilterDropdown(
            label: provider.selectedValue == 'Any Value'
                ? 'Value'
                : provider.selectedValue,
            isActive: provider.selectedValue != 'Any Value',
            onTap: () => _showValuePicker(context, colors, text),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _FilterDropdown(
            label: _sortLabel(provider.sortOption),
            isActive: provider.sortOption != ContractSortOption.winScore,
            icon: Icons.sort_rounded,
            onTap: () => _showSortPicker(context, colors, text),
          ),
        ],
      ),
    );
  }

  String _sortLabel(ContractSortOption option) {
    switch (option) {
      case ContractSortOption.winScore:
        return 'Win Score';
      case ContractSortOption.value:
        return 'Value';
      case ContractSortOption.dueDate:
        return 'Due Date';
      case ContractSortOption.postedDate:
        return 'Posted';
    }
  }

  void _showAgencyPicker(
      BuildContext context, ColorScheme colors, TextTheme text) {
    _showOptionSheet(
      context: context,
      title: 'Filter by Agency',
      options: provider.agencies,
      selected: provider.selectedAgency,
      onSelect: provider.setAgency,
      colors: colors,
      text: text,
    );
  }

  void _showSetAsidePicker(
      BuildContext context, ColorScheme colors, TextTheme text) {
    _showOptionSheet(
      context: context,
      title: 'Filter by Set-Aside',
      options: provider.setAsideTypes,
      selected: provider.selectedSetAside,
      onSelect: provider.setSetAside,
      colors: colors,
      text: text,
    );
  }

  void _showValuePicker(
      BuildContext context, ColorScheme colors, TextTheme text) {
    _showOptionSheet(
      context: context,
      title: 'Filter by Value',
      options: provider.valueRanges,
      selected: provider.selectedValue,
      onSelect: provider.setValue,
      colors: colors,
      text: text,
    );
  }

  void _showSortPicker(
      BuildContext context, ColorScheme colors, TextTheme text) {
    _showOptionSheet(
      context: context,
      title: 'Sort Results By',
      options: ContractSortOption.values
          .map((o) => _sortLabel(o))
          .toList(),
      selected: _sortLabel(provider.sortOption),
      onSelect: (label) {
        final option = ContractSortOption.values.firstWhere(
          (o) => _sortLabel(o) == label,
          orElse: () => ContractSortOption.winScore,
        );
        provider.setSortOption(option);
      },
      colors: colors,
      text: text,
    );
  }

  void _showOptionSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String selected,
    required void Function(String) onSelect,
    required ColorScheme colors,
    required TextTheme text,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppTheme.spacingMd),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                  child: Text(title,
                      style: text.titleMedium,
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: options.map((option) {
                      final isSelected = option == selected;
                      return ListTile(
                        title: Text(
                          option,
                          style: text.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_rounded,
                                color: colors.primary, size: AppTheme.iconMd)
                            : null,
                        tileColor: isSelected
                            ? colors.primary.withOpacity(0.08)
                            : null,
                        onTap: () {
                          onSelect(option);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData icon;

  const _FilterDropdown({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon = Icons.keyboard_arrow_down_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colors.primary.withOpacity(0.12)
              : appColors.toolCardBg,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: isActive
                ? colors.primary.withOpacity(0.4)
                : colors.outlineVariant.withOpacity(0.3),
            width: AppTheme.borderDefault,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 80),
              child: Text(
                label,
                style: text.labelMedium?.copyWith(
                  color: isActive ? colors.primary : appColors.subtleText,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              icon,
              size: AppTheme.iconSm,
              color: isActive ? colors.primary : appColors.subtleText,
            ),
          ],
        ),
      ),
    );
  }
}
