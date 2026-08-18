import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BidWriterScreen extends StatefulWidget {
  const BidWriterScreen({super.key});

  @override
  State<BidWriterScreen> createState() => _BidWriterScreenState();
}

class _BidWriterScreenState extends State<BidWriterScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _rfpController = TextEditingController();
  String _selectedTone = 'Technical';
  bool _isGenerating = false;
  String? _generatedBid;
  final List<_BidDraft> _drafts = [
    _BidDraft(title: 'IT Modernization — DoD', status: 'Draft', date: 'Aug 15, 2026', progress: 0.6),
    _BidDraft(title: 'Cloud Migration — GSA MAS', status: 'Review', date: 'Aug 12, 2026', progress: 0.85),
    _BidDraft(title: 'Cybersecurity Assessment — DHS', status: 'Submitted', date: 'Aug 8, 2026', progress: 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _rfpController.dispose();
    super.dispose();
  }

  Future<void> _generateBid() async {
    if (_rfpController.text.trim().isEmpty) return;
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _generatedBid = '''Executive Summary:
Our team brings 15+ years of proven experience delivering solutions aligned with the requirements outlined in this solicitation. We propose a comprehensive approach that leverages our certified workforce, established processes, and innovative technology stack.

Technical Approach:
We will execute a phased methodology encompassing discovery, planning, implementation, and optimization. Each phase includes defined milestones, deliverables, and quality gates to ensure on-time, on-budget delivery.

Past Performance:
Our organization has successfully completed 47 contracts of similar scope and complexity, maintaining a 98% on-time delivery rate and consistently receiving "Exceptional" CPARS ratings.

Management Plan:
A dedicated Program Manager will oversee daily operations with weekly status reports, monthly executive reviews, and real-time dashboard access for all stakeholders.''';
      _drafts.insert(0, _BidDraft(
        title: _rfpController.text.length > 40 ? '${_rfpController.text.substring(0, 40)}...' : _rfpController.text,
        status: 'Draft',
        date: 'Aug 18, 2026',
        progress: 0.15,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF8B5CF6);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Bid Writer'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'New Bid'),
            Tab(text: 'My Drafts'),
            Tab(text: 'Content Library'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewBidTab(colors, text, appColors, accent),
          _buildDraftsTab(colors, text, appColors, accent),
          _buildLibraryTab(colors, text, appColors, accent),
        ],
      ),
    );
  }

  Widget _buildNewBidTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Paste or describe the RFP requirements', style: text.titleMedium),
          const SizedBox(height: AppTheme.spacingSm),
          TextField(
            controller: _rfpController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'e.g., "IT modernization services for the Department of Defense, including cloud migration and cybersecurity..."',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text('Writing Tone', style: text.titleSmall),
          const SizedBox(height: AppTheme.spacingSm),
          Wrap(
            spacing: AppTheme.spacingSm,
            children: ['Technical', 'Executive', 'Narrative'].map((tone) {
              final selected = _selectedTone == tone;
              return ChoiceChip(
                label: Text(tone),
                selected: selected,
                selectedColor: accent.withOpacity(0.2),
                onSelected: (_) => setState(() => _selectedTone = tone),
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            width: double.infinity,
            height: AppTheme.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateBid,
              style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
              icon: _isGenerating
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(_isGenerating ? 'Generating bid response...' : 'Generate Bid Response'),
            ),
          ),
          if (_generatedBid != null) ...[
            const SizedBox(height: AppTheme.spacingLg),
            Row(
              children: [
                Icon(Icons.check_circle, color: appColors.success, size: AppTheme.iconMd),
                const SizedBox(width: AppTheme.spacingSm),
                Text('AI-Generated Response', style: text.titleMedium),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: appColors.toolCardBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: accent.withOpacity(0.3)),
              ),
              child: SelectableText(_generatedBid!, style: text.bodyMedium?.copyWith(height: 1.6)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDraftsTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: _drafts.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, index) {
        final draft = _drafts[index];
        final statusColor = draft.status == 'Submitted' ? appColors.success : draft.status == 'Review' ? appColors.warning : accent;
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(draft.title, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: AppTheme.spacingXs),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                    child: Text(draft.status, style: text.labelSmall?.copyWith(color: statusColor)),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              LinearProgressIndicator(value: draft.progress, backgroundColor: colors.surfaceContainerHighest, color: accent),
              const SizedBox(height: AppTheme.spacingXs),
              Text('${(draft.progress * 100).toInt()}% complete · ${draft.date}', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLibraryTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    final items = [
      _LibraryItem('Past Performance — IT Services', Icons.history_rounded, '12 records'),
      _LibraryItem('Team Bios — Key Personnel', Icons.people_rounded, '8 bios'),
      _LibraryItem('Corporate Qualifications', Icons.business_rounded, '5 documents'),
      _LibraryItem('Standard Compliance Language', Icons.gavel_rounded, '23 clauses'),
      _LibraryItem('Technical Approach Templates', Icons.architecture_rounded, '7 templates'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
            child: Icon(item.icon, color: accent, size: AppTheme.iconMd),
          ),
          title: Text(item.title, style: text.titleSmall),
          subtitle: Text(item.count, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
          trailing: Icon(Icons.chevron_right, color: appColors.subtleText),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
          tileColor: appColors.toolCardBg,
          onTap: () {},
        );
      },
    );
  }
}

class _BidDraft {
  final String title;
  final String status;
  final String date;
  final double progress;
  _BidDraft({required this.title, required this.status, required this.date, required this.progress});
}

class _LibraryItem {
  final String title;
  final IconData icon;
  final String count;
  _LibraryItem(this.title, this.icon, this.count);
}
