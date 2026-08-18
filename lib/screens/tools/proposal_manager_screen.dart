import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class ProposalManagerScreen extends StatefulWidget {
  const ProposalManagerScreen({super.key});

  @override
  State<ProposalManagerScreen> createState() => _ProposalManagerScreenState();
}

class _ProposalManagerScreenState extends State<ProposalManagerScreen> {
  final List<_Proposal> _proposals = [
    _Proposal('Cloud Migration — GSA MAS', 'DoD / DISA', 'In Progress', 'Pink Team', 0.45, 'Sep 12, 2026', ['J. Smith', 'A. Chen']),
    _Proposal('IT Helpdesk Support Services', 'VA', 'In Progress', 'Writing', 0.25, 'Oct 3, 2026', ['M. Brown']),
    _Proposal('Cybersecurity Assessment & Auth', 'DHS / CISA', 'Review', 'Red Team', 0.75, 'Aug 28, 2026', ['L. Garcia', 'R. Patel', 'K. Jones']),
    _Proposal('Data Analytics Platform', 'HHS / CDC', 'Final', 'Gold Team', 0.92, 'Aug 22, 2026', ['J. Smith', 'T. Wilson']),
    _Proposal('Network Modernization IDIQ', 'Army / PEO EIS', 'Submitted', 'Complete', 1.0, 'Aug 15, 2026', ['A. Chen', 'M. Brown', 'L. Garcia']),
    _Proposal('Facilities Maintenance BPA', 'GSA', 'Won', 'Awarded', 1.0, 'Jul 30, 2026', ['K. Jones']),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFFEC4899);

    return Scaffold(
      appBar: AppBar(title: const Text('Proposal Manager')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Proposal'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        itemCount: _proposals.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
        itemBuilder: (context, i) {
          final p = _proposals[i];
          final stageColor = _stageColor(p.stage, appColors, accent);
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
                Row(children: [
                  Expanded(child: Text(p.title, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: AppTheme.spacingXs),
                    decoration: BoxDecoration(color: stageColor.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                    child: Text(p.stage, style: text.labelSmall?.copyWith(color: stageColor)),
                  ),
                ]),
                const SizedBox(height: AppTheme.spacingXs),
                Text(p.agency, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                const SizedBox(height: AppTheme.spacingSm),
                if (p.progress < 1.0) ...[
                  LinearProgressIndicator(value: p.progress, backgroundColor: colors.surfaceContainerHighest, color: accent),
                  const SizedBox(height: AppTheme.spacingXs),
                ],
                Row(children: [
                  Icon(Icons.calendar_today_rounded, size: AppTheme.iconSm, color: appColors.subtleText),
                  const SizedBox(width: AppTheme.spacingXs),
                  Text('Due ${p.dueDate}', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                  const Spacer(),
                  ...p.team.take(3).map((name) => Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: accent.withOpacity(0.2),
                      child: Text(name.split(' ').map((n) => n[0]).join(), style: text.labelSmall?.copyWith(color: accent, fontSize: 9)),
                    ),
                  )),
                  if (p.team.length > 3) Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: colors.surfaceContainerHighest,
                      child: Text('+${p.team.length - 3}', style: text.labelSmall?.copyWith(fontSize: 9)),
                    ),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _stageColor(String stage, AppColorsExtension appColors, Color accent) {
    switch (stage) {
      case 'Writing': return const Color(0xFF3B82F6);
      case 'Pink Team': return accent;
      case 'Red Team': return appColors.warning;
      case 'Gold Team': return const Color(0xFF8B5CF6);
      case 'Complete': return appColors.success;
      case 'Awarded': return appColors.success;
      default: return appColors.subtleText;
    }
  }
}

class _Proposal {
  final String title, agency, status, stage, dueDate;
  final double progress;
  final List<String> team;
  _Proposal(this.title, this.agency, this.status, this.stage, this.progress, this.dueDate, this.team);
}
