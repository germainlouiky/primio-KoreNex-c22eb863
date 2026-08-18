import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  final List<_Contact> _contacts = [
    _Contact('Col. James Mitchell', 'Contracting Officer', 'U.S. Army PEO EIS', 'james.mitchell@army.mil', '3 days ago'),
    _Contact('Sarah Chen', 'Program Manager', 'DHS / CISA', 'sarah.chen@cisa.dhs.gov', '1 week ago'),
    _Contact('Robert Williams', 'Contract Specialist', 'GSA FAS', 'robert.williams@gsa.gov', '2 weeks ago'),
    _Contact('Dr. Priya Patel', 'Technical Director', 'NIH / OD', 'priya.patel@nih.gov', '3 weeks ago'),
    _Contact('Mark Thompson', 'Small Business Director', 'VA / OSDBU', 'mark.thompson@va.gov', '1 month ago'),
    _Contact('Lisa Garcia', 'Procurement Analyst', 'DoD / OUSD(A&S)', 'lisa.garcia@osd.mil', '1 month ago'),
  ];

  final List<_Deal> _deals = [
    _Deal('Cloud Services BPA', '\$2.4M', 'Capture', const Color(0xFF3B82F6)),
    _Deal('IT Staffing Augmentation', '\$850K', 'Proposal', const Color(0xFF8B5CF6)),
    _Deal('Cybersecurity SOC', '\$3.1M', 'Negotiation', const Color(0xFFF59E0B)),
    _Deal('Data Analytics Support', '\$1.7M', 'Capture', const Color(0xFF3B82F6)),
    _Deal('Network Infrastructure', '\$4.2M', 'Won', const Color(0xFF10B981)),
    _Deal('Help Desk Services', '\$960K', 'Lost', const Color(0xFFEF4444)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF6366F1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM'),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'Contacts'),
          Tab(text: 'Pipeline'),
          Tab(text: 'Activity'),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: accent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add_rounded),
      ),
      body: TabBarView(controller: _tabController, children: [
        _buildContactsTab(colors, text, appColors, accent),
        _buildPipelineTab(colors, text, appColors),
        _buildActivityTab(text, appColors),
      ]),
    );
  }

  Widget _buildContactsTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search contacts...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            itemCount: _contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
            itemBuilder: (context, i) {
              final c = _contacts[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: accent.withOpacity(0.15),
                  child: Text(c.name.split(' ').map((n) => n[0]).take(2).join(), style: text.labelMedium?.copyWith(color: accent)),
                ),
                title: Text(c.name, style: text.titleSmall),
                subtitle: Text('${c.title} · ${c.org}', style: text.bodySmall?.copyWith(color: appColors.subtleText), maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(c.lastContact, style: text.labelSmall?.copyWith(color: appColors.subtleText)),
                tileColor: appColors.toolCardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineTab(ColorScheme colors, TextTheme text, AppColorsExtension appColors) {
    final stages = ['Capture', 'Proposal', 'Negotiation', 'Won', 'Lost'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stages.map((stage) {
          final stageDeals = _deals.where((d) => d.stage == stage).toList();
          if (stageDeals.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: stageDeals.first.color, shape: BoxShape.circle)),
                const SizedBox(width: AppTheme.spacingSm),
                Text(stage.toUpperCase(), style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2)),
                const SizedBox(width: AppTheme.spacingSm),
                Text('(${stageDeals.length})', style: text.labelSmall?.copyWith(color: appColors.subtleText)),
              ]),
              const SizedBox(height: AppTheme.spacingSm),
              ...stageDeals.map((d) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: appColors.toolCardBg,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: d.color.withOpacity(0.3)),
                ),
                child: Row(children: [
                  Expanded(child: Text(d.title, style: text.titleSmall)),
                  Text(d.value, style: text.titleSmall?.copyWith(color: d.color)),
                ]),
              )),
              const SizedBox(height: AppTheme.spacingSm),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityTab(TextTheme text, AppColorsExtension appColors) {
    final activities = [
      _Activity('Called Col. Mitchell re: Cloud BPA scope', Icons.phone_rounded, '2 hours ago'),
      _Activity('Email sent to Sarah Chen — SOW draft attached', Icons.email_rounded, '5 hours ago'),
      _Activity('Meeting with GSA FAS team scheduled', Icons.event_rounded, 'Yesterday'),
      _Activity('Updated Cybersecurity SOC proposal status', Icons.edit_rounded, '2 days ago'),
      _Activity('Added Dr. Patel as new contact', Icons.person_add_rounded, '3 days ago'),
      _Activity('Won Network Infrastructure contract 🎉', Icons.emoji_events_rounded, '1 week ago'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, i) {
        final a = activities[i];
        return ListTile(
          leading: Icon(a.icon, color: appColors.subtleText),
          title: Text(a.description, style: text.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(a.time, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
          tileColor: appColors.toolCardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        );
      },
    );
  }
}

class _Contact {
  final String name, title, org, email, lastContact;
  _Contact(this.name, this.title, this.org, this.email, this.lastContact);
}

class _Deal {
  final String title, value, stage;
  final Color color;
  _Deal(this.title, this.value, this.stage, this.color);
}

class _Activity {
  final String description, time;
  final IconData icon;
  _Activity(this.description, this.icon, this.time);
}
