import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/tool_item.dart';
import '../theme/theme.dart';

class ToolDetailScreen extends StatelessWidget {
  final ToolItem tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colors.surface,
            foregroundColor: colors.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: _ToolHeroHeader(tool: tool, appColors: appColors, colors: colors, text: text),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'Key Features', appColors: appColors),
                  const SizedBox(height: AppTheme.spacingMd),
                  ...tool.features.map((f) => _FeatureRow(feature: f, tool: tool, appColors: appColors, colors: colors, text: text)),
                  if (tool.useCases.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingLg),
                    _SectionLabel(label: 'Who Uses This', appColors: appColors),
                    const SizedBox(height: AppTheme.spacingMd),
                    _UseCasesCard(useCases: tool.useCases, tool: tool, appColors: appColors, colors: colors, text: text),
                  ],
                  const SizedBox(height: AppTheme.spacingXl),
                  _CtaButton(tool: tool, colors: colors, text: text),
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

class _ToolHeroHeader extends StatelessWidget {
  final ToolItem tool;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _ToolHeroHeader({
    required this.tool,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tool.accentColor.withOpacity(0.20),
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
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: tool.accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: tool.accentColor.withOpacity(0.30),
                    width: AppTheme.borderDefault,
                  ),
                ),
                child: Icon(tool.icon, color: tool.accentColor, size: AppTheme.iconLg),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(tool.name, style: text.headlineSmall),
              if (tool.tagline.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  tool.tagline,
                  style: text.bodyMedium?.copyWith(color: appColors.subtleText),
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

class _FeatureRow extends StatelessWidget {
  final ToolFeature feature;
  final ToolItem tool;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _FeatureRow({
    required this.feature,
    required this.tool,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: tool.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(feature.icon, color: tool.accentColor, size: AppTheme.iconMd),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: text.titleSmall),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  feature.description,
                  style: text.bodySmall?.copyWith(color: appColors.subtleText, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UseCasesCard extends StatelessWidget {
  final List<String> useCases;
  final ToolItem tool;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _UseCasesCard({
    required this.useCases,
    required this.tool,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Column(
        children: useCases.map((useCase) {
          final isLast = useCase == useCases.last;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_right_rounded, color: tool.accentColor, size: AppTheme.iconMd),
                  const SizedBox(width: AppTheme.spacingXs),
                  Expanded(
                    child: Text(useCase, style: text.bodyMedium?.copyWith(height: 1.4)),
                  ),
                ],
              ),
              if (!isLast)
                Divider(
                  height: AppTheme.spacingLg,
                  color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final ToolItem tool;
  final ColorScheme colors;
  final TextTheme text;

  const _CtaButton({required this.tool, required this.colors, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppTheme.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () => context.push('/tool/${tool.id}/workspace'),
        style: ElevatedButton.styleFrom(
          backgroundColor: tool.accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
        icon: const Icon(Icons.rocket_launch_rounded, size: AppTheme.iconSm),
        label: Text('Launch ${tool.name}', style: text.labelLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}
