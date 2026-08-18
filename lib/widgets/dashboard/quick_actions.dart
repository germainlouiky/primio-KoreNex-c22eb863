import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';

class _QuickAction {
  final String label;
  final IconData icon;
  final Color Function(ColorScheme, AppColorsExtension) colorFn;
  final void Function(BuildContext) onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.colorFn,
    required this.onTap,
  });
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    final actions = <_QuickAction>[
      _QuickAction(
        label: 'Find\nContracts',
        icon: Icons.search_rounded,
        colorFn: (c, a) => c.primary,
        onTap: (ctx) => ctx.go('/contracts'),
      ),
      _QuickAction(
        label: 'Ask\nNex',
        icon: Icons.auto_awesome_rounded,
        colorFn: (c, a) => c.tertiary,
        onTap: (ctx) => ctx.push('/nex'),
      ),
      _QuickAction(
        label: 'Write\nBid',
        icon: Icons.edit_note_rounded,
        colorFn: (c, a) => a.success,
        onTap: (ctx) => ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Opening Bid Writer...')),
        ),
      ),
      _QuickAction(
        label: 'Check\nCompliance',
        icon: Icons.verified_outlined,
        colorFn: (c, a) => a.warning,
        onTap: (ctx) => ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Opening Compliance Checker...')),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: text.titleLarge),
        const SizedBox(height: AppTheme.spacingMd),
        Row(
          children: actions.map((action) {
            final accentColor = action.colorFn(colors, appColors);
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == actions.last ? 0 : AppTheme.spacingSm,
                ),
                child: GestureDetector(
                  onTap: () => action.onTap(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingMd,
                      horizontal: AppTheme.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.toolCardBg,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                        color: accentColor.withOpacity(AppTheme.opacityOverlay),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSm),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(AppTheme.opacityOverlay),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Icon(action.icon, color: accentColor, size: AppTheme.iconMd),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          action.label,
                          textAlign: TextAlign.center,
                          style: text.labelSmall?.copyWith(
                            color: colors.onSurface,
                            height: 1.3,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
