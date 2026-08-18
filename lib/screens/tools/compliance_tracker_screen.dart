import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class ComplianceTrackerScreen extends StatefulWidget {
  const ComplianceTrackerScreen({super.key});

  @override
  State<ComplianceTrackerScreen> createState() => _ComplianceTrackerScreenState();
}

class _ComplianceTrackerScreenState extends State<ComplianceTrackerScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<_Certification> _certs = [
    _Certification('8(a) Business Development', 'Active', 'Expires Dec 15, 2027', Icons.verified_rounded, const Color(0xFF10B981)),
    _Certification('SDVOSB', 'Active', 'Expires Mar 22, 2028', Icons.military_tech_rounded, const Color(0xFF3B82F6)),
    _Certification('ISO 9001:2015', 'Renewal Due', 'Expires Oct 1, 2026', Icons.workspace_premium_rounded, const Color(0xFFF59E0B)),
    _Certification('CMMC Level 2', 'In Progress', '62% complete', Icons.security_rounded, const Color(0xFF8B5CF6)),
    _Certification('WOSB', 'Active', 'Expires Jul 8, 2027', Icons.badge_rounded, const Color(0xFFEC4899)),
    _Certification('SAM.gov Registration', 'Active', 'Renew by Feb 2027', Icons.account_balance_rounded, const Color(0xFF06B6D4)),
  ];
  final List<_ComplianceTask> _tasks = [
    _ComplianceTask('Update System Security Plan (SSP)', 'CMMC Level 2', 'High', false),
    _ComplianceTask('Submit annual 8(a) update to SBA', '8(a) Program', 'Medium', false),
    _ComplianceTask('Complete ISO internal audit', 'ISO 9001:2015', 'High', true),
    _ComplianceTask('Update employee security training records', 'CMMC Level 2', 'Medium', false),
    _ComplianceTask('Review FAR 52.204-21 compliance', 'General', 'Low', true),
    _ComplianceTask('Renew state business license', 'General', 'Medium', false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFFF59E0B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compliance Tracker'),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'Certifications'),
          Tab(text: 'Tasks'),
          Tab(text: 'Alerts'),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _buildCertsTab(colors, text, appColors),
        _buildTasksTab(colors, text, appColors, accent),
        _buildAlertsTab(colors, text, appColors),
      ]),
    );
  }

  Widget _buildCertsTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: _certs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, i) {
        final c = _certs[i];
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(color: c.color.withOpacity(0.12), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                child: Icon(c.icon, color: c.color, size: AppTheme.iconMd),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.name, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppTheme.spacingXs),
                Text(c.detail, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: AppTheme.spacingXs),
                decoration: BoxDecoration(color: c.color.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                child: Text(c.status, style: text.labelSmall?.copyWith(color: c.color)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTasksTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: _tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, i) {
        final t = _tasks[i];
        final priorityColor = t.priority == 'High' ? appColors.danger : t.priority == 'Medium' ? appColors.warning : appColors.success;
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
          ),
          child: Row(
            children: [
              Checkbox(
                value: t.done,
                activeColor: accent,
                onChanged: (v) => setState(() => _tasks[i] = _ComplianceTask(t.title, t.source, t.priority, v ?? false)),
              ),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.title, style: text.bodyMedium?.copyWith(decoration: t.done ? TextDecoration.lineThrough : null), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppTheme.spacingXs),
                Row(children: [
                  Text(t.source, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                  const SizedBox(width: AppTheme.spacingSm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: priorityColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(t.priority, style: text.labelSmall?.copyWith(color: priorityColor, fontSize: 10)),
                  ),
                ]),
              ])),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertsTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors) {
    final alerts = [
      _Alert('ISO 9001 renewal deadline in 44 days', Icons.warning_rounded, appColors.warning, 'Aug 18, 2026'),
      _Alert('FAR 52.204-26 updated — review required', Icons.policy_rounded, appColors.danger, 'Aug 16, 2026'),
      _Alert('CMMC Level 2 assessment scheduled', Icons.event_rounded, const Color(0xFF8B5CF6), 'Aug 14, 2026'),
      _Alert('Annual 8(a) report due in 90 days', Icons.schedule_rounded, const Color(0xFF3B82F6), 'Aug 10, 2026'),
      _Alert('SAM.gov entity validation renewed', Icons.check_circle_rounded, appColors.success, 'Aug 5, 2026'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: alerts.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, i) {
        final a = alerts[i];
        return ListTile(
          leading: Icon(a.icon, color: a.color),
          title: Text(a.message, style: text.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(a.date, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
          tileColor: appColors.toolCardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        );
      },
    );
  }
}

class _Certification {
  final String name, status, detail;
  final IconData icon;
  final Color color;
  _Certification(this.name, this.status, this.detail, this.icon, this.color);
}

class _ComplianceTask {
  final String title, source, priority;
  final bool done;
  _ComplianceTask(this.title, this.source, this.priority, this.done);
}

class _Alert {
  final String message, date;
  final IconData icon;
  final Color color;
  _Alert(this.message, this.icon, this.color, this.date);
}
