import 'package:flutter/material.dart';
import '../../providers/nex_provider.dart';
import '../../theme/theme.dart';

class NexSuggestedPrompts extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const NexSuggestedPrompts({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primary, colors.tertiary],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: colors.onPrimary,
              size: AppTheme.iconLg,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Hi, I\'m Nex',
            style: textTheme.headlineSmall!.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Your AI procurement assistant.\nHow can I help you today?',
            style: textTheme.bodyMedium!.copyWith(color: appColors.subtleText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Wrap(
            spacing: AppTheme.spacingSm,
            runSpacing: AppTheme.spacingSm,
            alignment: WrapAlignment.center,
            children: NexProvider.suggestedPrompts.map((prompt) {
              return InkWell(
                onTap: () => onSelect(prompt),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm + 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    border: Border.all(
                      color: colors.outlineVariant
                          .withOpacity(AppTheme.opacityOverlay),
                      width: AppTheme.borderDefault,
                    ),
                  ),
                  child: Text(
                    prompt,
                    style: textTheme.bodySmall!.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
