import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../theme/theme.dart';

class NexMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const NexMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: message.isUser ? AppTheme.spacingXl : AppTheme.spacingMd,
        right: message.isUser ? AppTheme.spacingMd : AppTheme.spacingXl,
        bottom: AppTheme.spacingSm,
      ),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _NexAvatar(colors: colors),
            const SizedBox(width: AppTheme.spacingSm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingMd - 4,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? colors.primary
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppTheme.radiusMedium),
                  topRight: const Radius.circular(AppTheme.radiusMedium),
                  bottomLeft: Radius.circular(
                      message.isUser ? AppTheme.radiusMedium : 0),
                  bottomRight: Radius.circular(
                      message.isUser ? 0 : AppTheme.radiusMedium),
                ),
              ),
              child: _RichText(
                text: message.text,
                style: textTheme.bodyMedium!.copyWith(
                  color: message.isUser
                      ? colors.onPrimary
                      : colors.onSurface,
                  height: 1.5,
                ),
                boldStyle: textTheme.bodyMedium!.copyWith(
                  color: message.isUser
                      ? colors.onPrimary
                      : colors.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NexAvatar extends StatelessWidget {
  final ColorScheme colors;

  const _NexAvatar({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.tertiary],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Center(
        child: Text(
          'N',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

/// Renders text with **bold** markdown support.
class _RichText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle boldStyle;

  const _RichText({
    required this.text,
    required this.style,
    required this.boldStyle,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start), style: style));
      }
      spans.add(TextSpan(text: match.group(1), style: boldStyle));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: style));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
