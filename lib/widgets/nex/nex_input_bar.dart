import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class NexInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;

  const NexInputBar({super.key, required this.onSend});

  @override
  State<NexInputBar> createState() => _NexInputBarState();
}

class _NexInputBarState extends State<NexInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSend(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Container(
      padding: EdgeInsets.only(
        left: AppTheme.spacingMd,
        right: AppTheme.spacingSm,
        top: AppTheme.spacingSm,
        bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: TextField(
                controller: _controller,
                style: textTheme.bodyMedium!.copyWith(color: colors.onSurface),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Ask Nex anything...',
                  hintStyle: textTheme.bodyMedium!.copyWith(
                    color: appColors.subtleText,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingMd - 4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: _hasText ? _send : null,
              style: IconButton.styleFrom(
                backgroundColor:
                    _hasText ? colors.primary : colors.surfaceContainerHighest,
                disabledBackgroundColor: colors.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: _hasText ? colors.onPrimary : appColors.subtleText,
                size: AppTheme.iconMd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
