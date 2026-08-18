import 'package:flutter/material.dart';
import '../models/tool_item.dart';
import '../theme/theme.dart';

class PricingDetailScreen extends StatefulWidget {
  final PricingTier tier;

  const PricingDetailScreen({super.key, required this.tier});

  @override
  State<PricingDetailScreen> createState() => _PricingDetailScreenState();
}

class _PricingDetailScreenState extends State<PricingDetailScreen> {
  bool _isAnnual = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    final accentColor = widget.tier.badgeColor ?? colors.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: colors.surface,
            foregroundColor: colors.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: _PricingHeroHeader(
                tier: widget.tier,
                isAnnual: _isAnnual,
                onToggle: () => setState(() => _isAnnual = !_isAnnual),
                accentColor: accentColor,
                appColors: appColors,
                colors: colors,
                text: text,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.tier.description.isNotEmpty) ...[
                    _DescriptionCard(
                      description: widget.tier.description,
                      accentColor: accentColor,
                      appColors: appColors,
                      colors: colors,
                      text: text,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                  ],
                  _SectionLabel(label: "What's Included", appColors: appColors),
                  const SizedBox(height: AppTheme.spacingMd),
                  _FeaturesCard(
                    tier: widget.tier,
                    appColors: appColors,
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  _BillingToggle(
                    isAnnual: _isAnnual,
                    onToggle: () => setState(() => _isAnnual = !_isAnnual),
                    tier: widget.tier,
                    appColors: appColors,
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  _CtaSection(
                    tier: widget.tier,
                    isAnnual: _isAnnual,
                    accentColor: accentColor,
                    colors: colors,
                    text: text,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingHeroHeader extends StatelessWidget {
  final PricingTier tier;
  final bool isAnnual;
  final VoidCallback onToggle;
  final Color accentColor;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _PricingHeroHeader({
    required this.tier,
    required this.isAnnual,
    required this.onToggle,
    required this.accentColor,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final displayPrice = isAnnual && tier.annualPrice.isNotEmpty ? tier.annualPrice : tier.price;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.18),
            colors.surface,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            AppTheme.spacingXl + AppTheme.spacingLg,
            AppTheme.spacingMd,
            AppTheme.spacingMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(tier.name, style: text.headlineMedium),
                  if (tier.isPopular) ...[
                    const SizedBox(width: AppTheme.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: AppTheme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        border: Border.all(color: accentColor.withOpacity(0.4), width: AppTheme.borderDefault),
                      ),
                      child: Text(
                        'Most Popular',
                        style: text.labelSmall?.copyWith(color: accentColor),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(displayPrice, style: text.headlineLarge?.copyWith(color: accentColor)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(tier.period, style: text.bodySmall),
                  ),
                  if (isAnnual && tier.annualPrice.isNotEmpty) ...[
                    const SizedBox(width: AppTheme.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXs + 2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        'Save 20%',
                        style: text.labelSmall?.copyWith(color: appColors.success),
                      ),
                    ),
                  ],
                ],
              ),
              if (tier.subtitle.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  tier.subtitle,
                  style: text.bodySmall?.copyWith(color: appColors.subtleText),
                ),
              ],
            ],
          ),
        ),
      ),
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

class _DescriptionCard extends StatelessWidget {
  final String description;
  final Color accentColor;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _DescriptionCard({
    required this.description,
    required this.accentColor,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: accentColor.withOpacity(0.20),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: accentColor, size: AppTheme.iconMd),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              description,
              style: text.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesCard extends StatelessWidget {
  final PricingTier tier;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _FeaturesCard({
    required this.tier,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Column(
        children: List.generate(tier.features.length, (index) {
          final feature = tier.features[index];
          final isLast = index == tier.features.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingMd,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: AppTheme.iconSm,
                      color: appColors.success,
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Text(feature, style: text.bodyMedium),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: AppTheme.spacingMd,
                  endIndent: AppTheme.spacingMd,
                  color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _BillingToggle extends StatelessWidget {
  final bool isAnnual;
  final VoidCallback onToggle;
  final PricingTier tier;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _BillingToggle({
    required this.isAnnual,
    required this.onToggle,
    required this.tier,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: appColors.cardHighlight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Annual Billing', style: text.titleSmall),
                Text(
                  'Save 20% with annual billing',
                  style: text.bodySmall?.copyWith(color: appColors.subtleText),
                ),
              ],
            ),
          ),
          Switch(
            value: isAnnual,
            onChanged: (_) => onToggle(),
            activeColor: colors.primary,
          ),
        ],
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  final PricingTier tier;
  final bool isAnnual;
  final Color accentColor;
  final ColorScheme colors;
  final TextTheme text;

  const _CtaSection({
    required this.tier,
    required this.isAnnual,
    required this.accentColor,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppTheme.buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${tier.ctaLabel} — subscription coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Text(
              tier.ctaLabel,
              style: text.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          tier.name == 'Enterprise'
              ? 'No commitment required. Talk to sales today.'
              : 'No credit card required. Cancel anytime.',
          style: text.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
