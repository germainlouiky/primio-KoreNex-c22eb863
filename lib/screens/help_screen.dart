import 'package:flutter/material.dart';
import '../theme/theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: text.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: colors.primary,
            unselectedLabelColor: appColors.subtleText,
            indicatorColor: colors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'FAQs'),
              Tab(text: 'Troubleshoot'),
              Tab(text: 'Contact'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _SearchBar(
            controller: _searchController,
            colors: colors,
            text: text,
            appColors: appColors,
            onChanged: (value) => setState(() => _searchQuery = value),
            onClear: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _FaqTab(searchQuery: _searchQuery, appColors: appColors),
                _TroubleshootTab(appColors: appColors),
                _ContactTab(colors: colors, text: text, appColors: appColors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const _SearchBar({
    required this.controller,
    required this.colors,
    required this.text,
    required this.appColors,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: text.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search FAQs and troubleshooting…',
          hintStyle: text.bodyMedium?.copyWith(color: appColors.subtleText),
          prefixIcon: Icon(Icons.search_rounded, color: appColors.subtleText, size: AppTheme.iconMd),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: appColors.subtleText, size: AppTheme.iconSm),
                  onPressed: onClear,
                )
              : null,
        ),
      ),
    );
  }
}

// ─── FAQ TAB ───────────────────────────────────────────────────────────────

class _FaqTab extends StatelessWidget {
  final String searchQuery;
  final AppColorsExtension appColors;

  const _FaqTab({required this.searchQuery, required this.appColors});

  static const List<_FaqCategory> _categories = [
    _FaqCategory(
      title: 'Getting Started',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF3B82F6),
      items: [
        _FaqItem(
          q: 'How do I find my first contract opportunity?',
          a: 'Head to the Contracts tab and tap "Load Matched Contracts." KoreNex uses AI to match opportunities to your NAICS codes and past performance profile. Use the filter bar to narrow by agency, set-aside type, or dollar value.',
        ),
        _FaqItem(
          q: 'How do I set up my organization profile?',
          a: 'Go to Account → Edit Profile. Enter your CAGE code, UEI number, NAICS codes, and company size standard. A complete profile improves AI matching accuracy across all 9 tools.',
        ),
        _FaqItem(
          q: 'What is a NAICS code and why does it matter?',
          a: 'NAICS codes classify your business type and determine which federal contracts you are eligible to bid on. KoreNex uses your selected codes to filter and rank contract opportunities automatically.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'AI Tools',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF8B5CF6),
      items: [
        _FaqItem(
          q: 'How does the AI Bid Writer work?',
          a: 'Paste or upload your RFP, then tap "Write Bid." The AI extracts requirements, generates compliant bid sections (technical approach, management plan, past performance), and presents them for your review and editing.',
        ),
        _FaqItem(
          q: 'How accurate is the AI Price Estimator?',
          a: 'The estimator queries historical award data from USASpending.gov filtered by your NAICS code and target agency. It returns a price range with a confidence score — use it as a benchmark, not a final number.',
        ),
        _FaqItem(
          q: 'What does the Compliance Tracker check?',
          a: 'It checks your organization against FAR (Federal Acquisition Regulation) and DFAR clauses relevant to your contracts. Each gap includes a plain-language explanation and recommended remediation steps.',
        ),
        _FaqItem(
          q: 'Can the Capability Statement Generator output a PDF?',
          a: 'Yes. Fill in the structured form, review the AI-generated content, then tap "Export PDF." The output is formatted to federal contracting standards and ready to attach to solicitation responses.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Subscription & Billing',
      icon: Icons.payment_rounded,
      color: Color(0xFF10B981),
      items: [
        _FaqItem(
          q: 'What is the difference between Starter, Professional, and Enterprise?',
          a: 'Starter (\$49/mo) covers 1 user, 5 bids/month, and basic FAR compliance. Professional (\$149/mo) unlocks unlimited usage for up to 5 users. Enterprise (\$399+/mo) adds API access, white-labeling, SAML SSO, and a dedicated Customer Success Manager.',
        ),
        _FaqItem(
          q: 'How does annual billing work?',
          a: 'Switching to annual billing gives you 20% off — effectively two months free. Toggle the Annual switch on the Pricing screen to see your discounted price before subscribing.',
        ),
        _FaqItem(
          q: 'Can I change my plan at any time?',
          a: 'Yes. Upgrades take effect immediately and are prorated. Downgrades take effect at the end of your current billing cycle. Visit Account → Manage Plan to make changes.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Data & Privacy',
      icon: Icons.shield_outlined,
      color: Color(0xFFF59E0B),
      items: [
        _FaqItem(
          q: 'Is my bid and proposal data secure?',
          a: 'All data is encrypted at rest (AES-256) and in transit (TLS 1.3). Your proposal content is never used to train AI models. Enterprise customers can request a data processing agreement (DPA).',
        ),
        _FaqItem(
          q: 'Can I export or delete my data?',
          a: 'Yes. Go to Account → Security & Password → Data Export to download all your data as a ZIP archive. To delete your account and all associated data, contact support — deletion is permanent and completed within 30 days.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = searchQuery.isEmpty
        ? _categories
        : _categories
            .map((cat) => _FaqCategory(
                  title: cat.title,
                  icon: cat.icon,
                  color: cat.color,
                  items: cat.items
                      .where((item) =>
                          item.q.toLowerCase().contains(searchQuery) ||
                          item.a.toLowerCase().contains(searchQuery))
                      .toList(),
                ))
            .where((cat) => cat.items.isNotEmpty)
            .toList();

    if (filtered.isEmpty) {
      return _EmptySearch(appColors: appColors);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        0,
        AppTheme.spacingMd,
        AppTheme.spacingXl,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _FaqCategorySection(
        category: filtered[index],
        appColors: appColors,
      ),
    );
  }
}

class _FaqCategorySection extends StatelessWidget {
  final _FaqCategory category;
  final AppColorsExtension appColors;

  const _FaqCategorySection({required this.category, required this.appColors});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppTheme.spacingLg),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingXs),
              decoration: BoxDecoration(
                color: category.color.withOpacity(AppTheme.opacityOverlay),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(category.icon, color: category.color, size: AppTheme.iconSm),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              category.title,
              style: text.titleMedium?.copyWith(color: category.color),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        ...category.items.map((item) => _FaqTile(item: item, appColors: appColors)),
      ],
    );
  }
}

class _FaqTile extends StatefulWidget {
  final _FaqItem item;
  final AppColorsExtension appColors;

  const _FaqTile({required this.item, required this.appColors});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: widget.appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: _expanded
              ? colors.primary.withOpacity(0.30)
              : colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.q,
                        style: text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: widget.appColors.subtleText,
                        size: AppTheme.iconMd,
                      ),
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: AppTheme.spacingMd),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    widget.item.a,
                    style: text.bodySmall?.copyWith(
                      color: widget.appColors.subtleText,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── TROUBLESHOOT TAB ──────────────────────────────────────────────────────

class _TroubleshootTab extends StatelessWidget {
  final AppColorsExtension appColors;

  const _TroubleshootTab({required this.appColors});

  static const List<_TroubleshootItem> _items = [
    _TroubleshootItem(
      title: 'Contract search returns no results',
      icon: Icons.search_off_rounded,
      color: Color(0xFF3B82F6),
      steps: [
        'Ensure your NAICS codes are set in Account → Edit Profile.',
        'Remove all active filters — agency, set-aside, and value range.',
        'Tap "Load Matched Contracts" again to refresh the data feed.',
        'Check your internet connection; the AI search requires a live connection.',
        'If the issue persists, contact support with your account email.',
      ],
    ),
    _TroubleshootItem(
      title: 'AI Bid Writer produces incomplete output',
      icon: Icons.edit_off_rounded,
      color: Color(0xFF8B5CF6),
      steps: [
        'Check that your subscription includes AI writing (Starter: 5 bids/month).',
        'Ensure the RFP you pasted is plain text — remove tables and images first.',
        'Break very long RFPs into sections and run the writer per section.',
        'If output cuts off mid-sentence, your token limit may be reached — upgrade to Professional for unlimited tokens.',
      ],
    ),
    _TroubleshootItem(
      title: 'Compliance Tracker shows unexpected gaps',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFF59E0B),
      steps: [
        'Verify the contract type selected matches your actual contract (FAR vs DFAR).',
        'Upload supporting documentation (certifications, past audits) to close evidence gaps.',
        'Some gaps are informational warnings, not blockers — read the severity label on each item.',
        'Contact support if a gap is marked critical but you believe it is incorrect.',
      ],
    ),
    _TroubleshootItem(
      title: 'App is slow or not loading',
      icon: Icons.speed_rounded,
      color: Color(0xFF06B6D4),
      steps: [
        'Check your internet connection — KoreNex requires a live connection for AI features.',
        'Close and reopen the app to clear any cached state.',
        'If on mobile, ensure Background App Refresh is enabled in device settings.',
        'If the issue persists on web, try a different browser or clear browser cache.',
      ],
    ),
    _TroubleshootItem(
      title: 'Cannot log in to my account',
      icon: Icons.lock_outline_rounded,
      color: Color(0xFFEC4899),
      steps: [
        'Double-check your email address for typos.',
        'Use "Forgot Password" on the login screen to reset your credentials.',
        'If using SSO (Google/Microsoft), ensure your work account is active.',
        'Check that your subscription has not lapsed — expired accounts are locked automatically.',
        'Contact support if you still cannot access your account.',
      ],
    ),
    _TroubleshootItem(
      title: 'Deadline Calendar not syncing',
      icon: Icons.calendar_today_rounded,
      color: Color(0xFF10B981),
      steps: [
        'Go to Account → Integrations and check that Google or Outlook calendar is connected.',
        'Re-authorize the calendar integration if the connection shows as expired.',
        'Ensure the KoreNex app has calendar permission in your device settings.',
        'Deadlines added manually sync within 5 minutes — contract deadlines sync every 15 minutes.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingMd,
        AppTheme.spacingMd,
        AppTheme.spacingXl,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) => _TroubleshootTile(
        item: _items[index],
        appColors: appColors,
        text: text,
      ),
    );
  }
}

class _TroubleshootTile extends StatefulWidget {
  final _TroubleshootItem item;
  final AppColorsExtension appColors;
  final TextTheme text;

  const _TroubleshootTile({
    required this.item,
    required this.appColors,
    required this.text,
  });

  @override
  State<_TroubleshootTile> createState() => _TroubleshootTileState();
}

class _TroubleshootTileState extends State<_TroubleshootTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: widget.appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: _expanded
              ? widget.item.color.withOpacity(0.35)
              : colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingXs + 2),
                      decoration: BoxDecoration(
                        color: widget.item.color.withOpacity(AppTheme.opacityOverlay),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Icon(widget.item.icon, color: widget.item.color, size: AppTheme.iconSm),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Text(
                        widget.item.title,
                        style: widget.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: widget.appColors.subtleText,
                        size: AppTheme.iconMd,
                      ),
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: AppTheme.spacingMd),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  ...widget.item.steps.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: widget.item.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: widget.text.labelSmall?.copyWith(
                                  color: widget.item.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: widget.text.bodySmall?.copyWith(
                                color: widget.appColors.subtleText,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── CONTACT TAB ───────────────────────────────────────────────────────────

class _ContactTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _ContactTab({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingSm),
          _StatusBanner(colors: colors, text: text, appColors: appColors),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'REACH US',
            style: text.labelSmall?.copyWith(
              color: appColors.subtleText,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _ContactCard(
            icon: Icons.chat_bubble_outline_rounded,
            color: colors.primary,
            title: 'Live Chat',
            subtitle: 'Typical response: under 2 minutes',
            badge: 'Online Now',
            badgeColor: appColors.success,
            appColors: appColors,
            text: text,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _ContactCard(
            icon: Icons.email_outlined,
            color: const Color(0xFF8B5CF6),
            title: 'Email Support',
            subtitle: 'support@korenex.com',
            badge: 'Reply within 4 hrs',
            badgeColor: colors.primary,
            appColors: appColors,
            text: text,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _ContactCard(
            icon: Icons.video_call_outlined,
            color: const Color(0xFF06B6D4),
            title: 'Schedule a Call',
            subtitle: 'Professional & Enterprise plans',
            badge: 'Pro+',
            badgeColor: const Color(0xFFF59E0B),
            appColors: appColors,
            text: text,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'RESOURCES',
            style: text.labelSmall?.copyWith(
              color: appColors.subtleText,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _ResourceTile(
            icon: Icons.menu_book_outlined,
            label: 'Documentation',
            subtitle: 'Full product guides and API docs',
            appColors: appColors,
            text: text,
          ),
          _ResourceTile(
            icon: Icons.play_circle_outline_rounded,
            label: 'Video Tutorials',
            subtitle: 'Step-by-step walkthroughs for every tool',
            appColors: appColors,
            text: text,
          ),
          _ResourceTile(
            icon: Icons.forum_outlined,
            label: 'Community Forum',
            subtitle: 'Connect with other GovCon professionals',
            appColors: appColors,
            text: text,
          ),
          _ResourceTile(
            icon: Icons.new_releases_outlined,
            label: 'Release Notes',
            subtitle: 'What\'s new in each KoreNex update',
            appColors: appColors,
            text: text,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          _FeedbackCard(colors: colors, text: text, appColors: appColors),
          const SizedBox(height: AppTheme.spacingXl),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _StatusBanner({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: appColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: appColors.success.withOpacity(0.25),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: appColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              'All systems operational',
              style: text.bodySmall?.copyWith(color: appColors.success, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            'View status page →',
            style: text.labelSmall?.copyWith(color: appColors.subtleText),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final AppColorsExtension appColors;
  final TextTheme text;

  const _ContactCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.appColors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title coming soon')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm + 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(AppTheme.opacityOverlay),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(icon, color: color, size: AppTheme.iconMd),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.titleSmall),
                      const SizedBox(height: AppTheme.spacingXs),
                      Text(
                        subtitle,
                        style: text.bodySmall?.copyWith(color: appColors.subtleText),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: AppTheme.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    badge,
                    style: text.labelSmall?.copyWith(color: badgeColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final AppColorsExtension appColors;
  final TextTheme text;

  const _ResourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.appColors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label coming soon')),
            );
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
            child: Row(
              children: [
                Icon(icon, color: appColors.subtleText, size: AppTheme.iconMd),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      Text(
                        subtitle,
                        style: text.bodySmall?.copyWith(color: appColors.subtleText),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: appColors.subtleText, size: AppTheme.iconSm),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _FeedbackCard({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withOpacity(0.12),
            colors.secondary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: colors.primary.withOpacity(0.25),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_outline_rounded, color: colors.primary, size: AppTheme.iconMd),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Rate Your Experience',
                style: text.titleSmall?.copyWith(color: colors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Help us improve KoreNex by sharing your feedback.',
            style: text.bodySmall?.copyWith(color: appColors.subtleText),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['😞', '😐', '🙂', '😊', '🤩'].map((emoji) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thanks for your feedback!')),
                  );
                },
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── EMPTY SEARCH ─────────────────────────────────────────────────────────

class _EmptySearch extends StatelessWidget {
  final AppColorsExtension appColors;
  const _EmptySearch({required this.appColors});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: appColors.subtleText),
            const SizedBox(height: AppTheme.spacingMd),
            Text('No results found', style: text.titleMedium),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Try different keywords or browse the tabs above.',
              style: text.bodySmall?.copyWith(color: appColors.subtleText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── DATA CLASSES ──────────────────────────────────────────────────────────

class _FaqCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_FaqItem> items;

  const _FaqCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
}

class _TroubleshootItem {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> steps;

  const _TroubleshootItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.steps,
  });
}
