import 'package:flutter/material.dart';
import '../../models/tool_item.dart';
import '../../theme/theme.dart';

class PricingCard extends StatelessWidget {
  final PricingTier tier;
  final VoidCallback? onSelect;

  const PricingCard({
    super.key,
    required this.tier,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final appColors = theme.extension<AppColorsExtension>()!;

    return Material(
      color: appColors.toolCardBg,
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: tier.isPopular
              ? colors.primary
              : colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: tier.isPopular ? AppTheme.borderSelected : AppTheme.borderDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(tier.name, style: text.titleLarge),
              if (tier.isPopular) ...[
                const SizedBox(width: AppTheme.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: AppTheme.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    'Most Popular',
                    style: text.labelSmall?.copyWith(color: colors.primary),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(tier.price, style: text.headlineLarge),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(tier.period, style: text.bodySmall),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ...tier.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: AppTheme.iconSm,
                    color: appColors.success,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(f, style: text.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            child: tier.isPopular
                ? ElevatedButton(
                    onPressed: onSelect,
                    child: Text(tier.ctaLabel),
                  )
                : OutlinedButton(
                    onPressed: onSelect,
                    child: Text(tier.ctaLabel),
                  ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
