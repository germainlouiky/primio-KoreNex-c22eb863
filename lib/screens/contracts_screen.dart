import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contracts_provider.dart';
import '../theme/theme.dart';
import '../widgets/contracts/contract_filter_bar.dart';
import '../widgets/contracts/contract_result_card.dart';
import '../widgets/contracts/contract_detail_sheet.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractsProvider>();
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingSm),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: Icon(Icons.search_rounded,
                            color: colors.primary, size: AppTheme.iconMd),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Contract Finder', style: text.titleLarge),
                            Text(
                              'Find the right contracts before your competitors',
                              style: text.bodySmall
                                  ?.copyWith(color: appColors.subtleText),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: provider.setQuery,
                          onSubmitted: (_) => provider.search(),
                          style: text.bodyMedium,
                          decoration: InputDecoration(
                            hintText:
                                'Search by title, agency, NAICS code...',
                            hintStyle: text.bodyMedium
                                ?.copyWith(color: appColors.subtleText),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: appColors.subtleText,
                                size: AppTheme.iconMd),
                            suffixIcon: provider.query.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear_rounded,
                                        color: appColors.subtleText,
                                        size: AppTheme.iconSm),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.setQuery('');
                                      provider.search();
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: provider.search,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingMd),
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radiusMedium),
                            ),
                          ),
                          child:
                              Text('Search', style: text.labelLarge?.copyWith(color: colors.onPrimary)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tab bar
            _ContractTabBar(provider: provider, colors: colors, text: text, appColors: appColors),
            const SizedBox(height: AppTheme.spacingSm),
            // Filter bar (only on search tab)
            if (provider.activeTab == ContractTab.search) ...[
              ContractFilterBar(provider: provider),
              const SizedBox(height: AppTheme.spacingMd),
            ],
            // Content
            Expanded(
              child: _buildTabContent(
                  context, provider, colors, text, appColors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    ContractsProvider provider,
    ColorScheme colors,
    TextTheme text,
    AppColorsExtension appColors,
  ) {
    switch (provider.activeTab) {
      case ContractTab.search:
        return _SearchTabContent(
            provider: provider,
            colors: colors,
            text: text,
            appColors: appColors);
      case ContractTab.saved:
        return _SavedTabContent(
            provider: provider,
            colors: colors,
            text: text,
            appColors: appColors);
      case ContractTab.alerts:
        return _AlertsTabContent(colors: colors, text: text, appColors: appColors);
    }
  }
}

class _ContractTabBar extends StatelessWidget {
  final ContractsProvider provider;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _ContractTabBar({
    required this.provider,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Row(
        children: [
          _TabChip(
            label: 'Search',
            icon: Icons.search_rounded,
            isSelected: provider.activeTab == ContractTab.search,
            onTap: () => provider.setActiveTab(ContractTab.search),
            colors: colors,
            text: text,
            appColors: appColors,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _TabChip(
            label: 'Saved',
            icon: Icons.bookmark_rounded,
            isSelected: provider.activeTab == ContractTab.saved,
            onTap: () => provider.setActiveTab(ContractTab.saved),
            badge: provider.savedContracts.length,
            colors: colors,
            text: text,
            appColors: appColors,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _TabChip(
            label: 'Alerts',
            icon: Icons.notifications_active_rounded,
            isSelected: provider.activeTab == ContractTab.alerts,
            onTap: () => provider.setActiveTab(ContractTab.alerts),
            badge: provider.alertCount,
            colors: colors,
            text: text,
            appColors: appColors,
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int badge;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _TabChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.text,
    required this.appColors,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.15)
              : appColors.toolCardBg,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected
                ? colors.primary.withOpacity(0.5)
                : colors.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: AppTheme.iconSm,
                color:
                    isSelected ? colors.primary : appColors.subtleText),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              label,
              style: text.labelMedium?.copyWith(
                color: isSelected ? colors.primary : appColors.subtleText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (badge > 0) ...[
              const SizedBox(width: AppTheme.spacingXs),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : appColors.subtleText,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  '$badge',
                  style: text.labelSmall?.copyWith(
                    color: isSelected
                        ? colors.onPrimary
                        : colors.surface,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchTabContent extends StatelessWidget {
  final ContractsProvider provider;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _SearchTabContent({
    required this.provider,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                color: colors.primary, strokeWidth: 2),
            const SizedBox(height: AppTheme.spacingMd),
            Text('Scanning contract databases...',
                style: text.bodyMedium
                    ?.copyWith(color: appColors.subtleText)),
          ],
        ),
      );
    }

    if (!provider.hasSearched) {
      return _EmptySearchState(colors: colors, text: text, appColors: appColors, provider: provider);
    }

    if (provider.results.isEmpty) {
      return _NoResultsState(colors: colors, text: text, appColors: appColors);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          child: Row(
            children: [
              Text(
                '${provider.results.length} contracts found',
                style: text.labelMedium?.copyWith(color: appColors.subtleText),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd),
            itemCount: provider.results.length,
            itemBuilder: (context, index) {
              final contract = provider.results[index];
              return ContractResultCard(
                contract: contract,
                onSaveToggle: () => provider.toggleSaved(contract),
                onTap: () => ContractDetailSheet.show(
                  context,
                  contract: contract,
                  onSaveToggle: () => provider.toggleSaved(contract),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;
  final ContractsProvider provider;

  const _EmptySearchState({
    required this.colors,
    required this.text,
    required this.appColors,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.travel_explore_rounded,
                  color: colors.primary, size: 48),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text('Find Your Next Contract',
                style: text.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Search thousands of federal and commercial opportunities matched to your capabilities.',
              style: text.bodyMedium
                  ?.copyWith(color: appColors.subtleText, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXl),
            SizedBox(
              width: double.infinity,
              height: AppTheme.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: provider.loadInitialContracts,
                icon: const Icon(Icons.auto_awesome_rounded,
                    size: AppTheme.iconSm),
                label: const Text('Load Matched Contracts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _NoResultsState({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              color: appColors.subtleText, size: 48),
          const SizedBox(height: AppTheme.spacingMd),
          Text('No contracts found',
              style: text.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Try adjusting your filters or search terms.',
            style:
                text.bodySmall?.copyWith(color: appColors.subtleText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SavedTabContent extends StatelessWidget {
  final ContractsProvider provider;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _SavedTabContent({
    required this.provider,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final saved = provider.savedContracts;

    if (saved.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_rounded,
                color: appColors.subtleText, size: 48),
            const SizedBox(height: AppTheme.spacingMd),
            Text('No saved contracts yet',
                style: text.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              'Bookmark contracts from your search results to track them here.',
              style: text.bodySmall?.copyWith(color: appColors.subtleText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      itemCount: saved.length,
      itemBuilder: (context, index) {
        final contract = saved[index];
        return ContractResultCard(
          contract: contract,
          onSaveToggle: () => provider.toggleSaved(contract),
          onTap: () => ContractDetailSheet.show(
            context,
            contract: contract,
            onSaveToggle: () => provider.toggleSaved(contract),
          ),
        );
      },
    );
  }
}

class _AlertsTabContent extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _AlertsTabContent({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final alerts = [
      _AlertItem(
        title: 'New Match: DoD Cybersecurity IDIQ',
        subtitle: '3 new solicitations match your profile',
        time: '2 hours ago',
        icon: Icons.auto_awesome_rounded,
        color: colors.primary,
      ),
      _AlertItem(
        title: 'Deadline in 3 Days',
        subtitle: 'Veteran Benefits Management System — Phase III',
        time: 'Jul 8, 2026',
        icon: Icons.alarm_rounded,
        color: appColors.warning,
      ),
      _AlertItem(
        title: 'Win Score Updated',
        subtitle: 'Cybersecurity Operations Support: 82% → 87%',
        time: 'Yesterday',
        icon: Icons.trending_up_rounded,
        color: appColors.success,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      children: [
        Text(
          'Recent Activity',
          style: text.labelSmall?.copyWith(
              color: appColors.subtleText, letterSpacing: 1.2),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        ...alerts.map((alert) => _AlertCard(
            alert: alert,
            colors: colors,
            text: text,
            appColors: appColors)),
        const SizedBox(height: AppTheme.spacingLg),
        // Alert setup CTA
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
                color: colors.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.notifications_active_rounded,
                  color: colors.primary, size: AppTheme.iconMd),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set Up Smart Alerts',
                        style: text.titleSmall),
                    Text(
                      'Get notified when contracts matching your profile are posted.',
                      style: text.bodySmall
                          ?.copyWith(color: appColors.subtleText, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: appColors.subtleText, size: AppTheme.iconSm),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const _AlertItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class _AlertCard extends StatelessWidget {
  final _AlertItem alert;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _AlertCard({
    required this.alert,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
            color: colors.outlineVariant
                .withOpacity(AppTheme.opacityOverlay)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: alert.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child:
                Icon(alert.icon, color: alert.color, size: AppTheme.iconSm),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: text.titleSmall),
                const SizedBox(height: 2),
                Text(
                  alert.subtitle,
                  style: text.bodySmall
                      ?.copyWith(color: appColors.subtleText, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Flexible(
            flex: 0,
            child: Text(
              alert.time,
              style: text.labelSmall?.copyWith(color: appColors.subtleText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
