import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/theme.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/stats_row.dart';
import '../widgets/dashboard/tools_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(userName: provider.userName),
              const SizedBox(height: AppTheme.spacingLg),
              StatsRow(
                activeProposals: provider.activeProposals,
                upcomingDeadlines: provider.upcomingDeadlines,
                winRate: provider.winRate,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              ToolsGrid(tools: provider.tools),
              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}
