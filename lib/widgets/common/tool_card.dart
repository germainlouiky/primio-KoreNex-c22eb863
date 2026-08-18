import 'package:flutter/material.dart';
import '../../models/tool_item.dart';
import '../../theme/theme.dart';

class ToolCard extends StatelessWidget {
  final ToolItem tool;
  final VoidCallback? onTap;

  const ToolCard({
    super.key,
    required this.tool,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final appColors = theme.extension<AppColorsExtension>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(AppTheme.opacityOverlay),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      tool.accentColor.withOpacity(0.2),
                      tool.accentColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(
                  tool.icon,
                  color: tool.accentColor,
                  size: AppTheme.iconMd,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                tool.name,
                style: text.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Expanded(
                child: Text(
                  tool.description,
                  style: text.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Row(
                children: [
                  Text(
                    'Open',
                    style: text.labelSmall?.copyWith(color: tool.accentColor),
                  ),
                  const SizedBox(width: AppTheme.spacingXs),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: AppTheme.iconSm,
                    color: tool.accentColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
