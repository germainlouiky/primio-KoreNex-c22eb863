import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/tool_item.dart';
import '../../theme/theme.dart';
import '../common/tool_card.dart';

class ToolsGrid extends StatelessWidget {
  final List<ToolItem> tools;

  const ToolsGrid({super.key, required this.tools});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Tools', style: text.titleLarge),
        const SizedBox(height: AppTheme.spacingMd),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppTheme.spacingSm,
            crossAxisSpacing: AppTheme.spacingSm,
            childAspectRatio: 0.7,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            return ToolCard(
              tool: tools[index],
              onTap: () => context.push('/tool/${tools[index].id}'),
            );
          },
        ),
      ],
    );
  }
}
