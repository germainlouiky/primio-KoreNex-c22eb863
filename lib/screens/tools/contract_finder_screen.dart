import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class ContractFinderScreen extends StatefulWidget {
  const ContractFinderScreen({super.key});

  @override
  State<ContractFinderScreen> createState() => _ContractFinderScreenState();
}

class _ContractFinderScreenState extends State<ContractFinderScreen> {
  final _searchController = TextEditingController();
  String _setAside = 'All';
  bool _isSearching = false;
  bool _hasResults = false;

  final List<_FoundContract> _results = [
    _FoundContract('Enterprise Cloud Hosting Services', 'DoD / DISA', '\$8.5M', '541512', 'SDVOSB', 'Sep 30, 2026', 87, 'FFP'),
    _FoundContract('Cybersecurity Operations Center', 'DHS / CISA', '\$4.2M', '541519', '8(a)', 'Oct 15, 2026', 74, 'T&M'),
    _FoundContract('IT Service Management Support', 'VA', '\$2.1M', '541512', 'Small Business', 'Sep 5, 2026', 68, 'FFP'),
    _FoundContract('Data Analytics & Visualization', 'HHS / CDC', '\$3.7M', '541511', 'Full & Open', 'Nov 1, 2026', 55, 'Cost-Plus'),
    _FoundContract('Network Infrastructure Upgrade', 'Army / CECOM', '\$6.3M', '541513', 'SDVOSB', 'Oct 20, 2026', 81, 'IDIQ'),
    _FoundContract('Software Development Services', 'GSA / FAS', '\$1.8M', '541511', 'WOSB', 'Sep 22, 2026', 63, 'T&M'),
  ];

  Future<void> _search() async {
    setState(() => _isSearching = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() { _isSearching = false; _hasResults = true; });
  }

  List<_FoundContract> get _filtered {
    if (_setAside == 'All') return _results;
    return _results.where((c) => c.setAside == _setAside).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF3B82F6);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Contract Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search contracts, NAICS codes, agencies...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(_isSearching ? Icons.hourglass_top : Icons.radar_rounded, color: accent),
                    onPressed: _isSearching ? null : _search,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                ),
                onSubmitted: (_) => _search(),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'SDVOSB', '8(a)', 'WOSB', 'HUBZone', 'Small Business', 'Full & Open'].map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                      child: ChoiceChip(label: Text(s), selected: _setAside == s, selectedColor: accent.withOpacity(0.2), onSelected: (_) => setState(() => _setAside = s)),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          if (_isSearching)
            const Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(height: AppTheme.spacingMd),
              Text('AI is scanning contract databases...'),
            ])))
          else if (!_hasResults)
            Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.search_rounded, size: 48, color: appColors.subtleText),
              const SizedBox(height: AppTheme.spacingSm),
              Text('Search to find matching contracts', style: text.bodyMedium?.copyWith(color: appColors.subtleText)),
            ])))
          else
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                    child: Row(children: [
                      Text('${_filtered.length} contracts found', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                      const Spacer(),
                      Icon(Icons.sort, size: AppTheme.iconSm, color: appColors.subtleText),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text('Win Score', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                    ]),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
                      itemBuilder: (context, i) {
                        final c = _filtered[i];
                        final scoreColor = c.winScore >= 75 ? appColors.success : c.winScore >= 50 ? appColors.warning : appColors.danger;
                        return Container(
                          padding: const EdgeInsets.all(AppTheme.spacingMd),
                          decoration: BoxDecoration(
                            color: appColors.toolCardBg,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(child: Text(c.title, style: text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: AppTheme.spacingXs),
                                decoration: BoxDecoration(color: scoreColor.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                                child: Text('${c.winScore}%', style: text.labelSmall?.copyWith(color: scoreColor, fontWeight: FontWeight.bold)),
                              ),
                            ]),
                            const SizedBox(height: AppTheme.spacingXs),
                            Text(c.agency, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                            const SizedBox(height: AppTheme.spacingSm),
                            Row(children: [
                              _Tag(c.setAside, accent, text),
                              const SizedBox(width: AppTheme.spacingSm),
                              _Tag(c.naics, colors.primary, text),
                              const SizedBox(width: AppTheme.spacingSm),
                              _Tag(c.type, appColors.warning, text),
                              const Spacer(),
                              Text(c.value, style: text.titleSmall?.copyWith(color: appColors.success)),
                            ]),
                            const SizedBox(height: AppTheme.spacingXs),
                            Row(children: [
                              Icon(Icons.calendar_today_rounded, size: 12, color: appColors.subtleText),
                              const SizedBox(width: AppTheme.spacingXs),
                              Text('Due ${c.dueDate}', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                              const Spacer(),
                              Icon(Icons.bookmark_outline, size: AppTheme.iconSm, color: appColors.subtleText),
                            ]),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final TextTheme text;
  const _Tag(this.label, this.color, this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: text.labelSmall?.copyWith(color: color, fontSize: 10)),
    );
  }
}

class _FoundContract {
  final String title, agency, value, naics, setAside, dueDate, type;
  final int winScore;
  _FoundContract(this.title, this.agency, this.value, this.naics, this.setAside, this.dueDate, this.winScore, this.type);
}
