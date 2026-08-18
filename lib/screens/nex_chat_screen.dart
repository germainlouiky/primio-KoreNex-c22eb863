import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nex_provider.dart';
import '../theme/theme.dart';
import '../widgets/nex/nex_input_bar.dart';
import '../widgets/nex/nex_message_bubble.dart';
import '../widgets/nex/nex_suggested_prompts.dart';
import '../widgets/nex/nex_typing_indicator.dart';

class NexChatScreen extends StatefulWidget {
  const NexChatScreen({super.key});

  @override
  State<NexChatScreen> createState() => _NexChatScreenState();
}

class _NexChatScreenState extends State<NexChatScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Consumer<NexProvider>(
      builder: (context, nex, _) {
        // Auto-scroll on new messages
        if (nex.messages.isNotEmpty) _scrollToBottom();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: colors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.primary, colors.tertiary],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      'N',
                      style: textTheme.labelSmall!.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nex',
                      style: textTheme.titleMedium!.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      nex.isTyping ? 'Thinking...' : 'AI Assistant',
                      style: textTheme.bodySmall!.copyWith(
                        color: nex.isTyping
                            ? colors.primary
                            : appColors.subtleText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              if (nex.messages.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.refresh_rounded,
                      color: appColors.subtleText),
                  onPressed: () => nex.clearChat(),
                  tooltip: 'Clear chat',
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(AppTheme.borderDefault),
              child: Container(
                height: AppTheme.borderDefault,
                color: colors.outlineVariant
                    .withOpacity(AppTheme.opacityOverlay),
              ),
            ),
          ),
          backgroundColor: colors.surface,
          body: Column(
            children: [
              Expanded(
                child: nex.messages.isEmpty
                    ? SingleChildScrollView(
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: AppTheme.spacingXl),
                            child: NexSuggestedPrompts(
                              onSelect: (prompt) => nex.sendMessage(prompt),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingMd),
                        itemCount:
                            nex.messages.length + (nex.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == nex.messages.length) {
                            return const NexTypingIndicator();
                          }
                          return NexMessageBubble(
                              message: nex.messages[index]);
                        },
                      ),
              ),
              NexInputBar(
                onSend: (text) => nex.sendMessage(text),
              ),
            ],
          ),
        );
      },
    );
  }
}
