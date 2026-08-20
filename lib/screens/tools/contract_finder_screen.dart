import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/theme.dart';

class ContractFinderScreen extends StatefulWidget {
  const ContractFinderScreen({super.key});

  @override
  State<ContractFinderScreen> createState() => _ContractFinderScreenState();
}

class _ContractFinderScreenState extends State<ContractFinderScreen> {
  final _keywordsController = TextEditingController();
  final _naicsController = TextEditingController();
  final _stateController = TextEditingController();

  String _setAside = 'All';
  bool _isSearching = false;
  bool _hasSearched = false;
  String? _errorMessage;
  List<_Contract> _results = [];

  static const _edgeFunctionUrl =
      'https://zxwhkgcrtlvemqabcint.supabase.co/functions/v1/search-contracts';

  static const _setAsideFilters = [
    'All',
    'SDVOSB',
    '8(a)',
    'WOSB',
    'HUBZone',
    'Small Business',
    'Full & Open',
  ];

  Future<void> _search() async {
    final keywords = _keywordsController.text.trim();
    final naics = _naicsController.text.trim();
    final state = _stateController.text.trim();

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        throw Exception('Please log in first');
      }

      final response = await http.post(
        Uri.parse(_edgeFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          if (keywords.isNotEmpty) 'keywords': keywords,
          if (naics.isNotEmpty) 'naicsCode': naics,
          if (state.isNotEmpty) 'state': state,
          'limit': 25,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> opportunities = data['opportunities'] ?? [];
        if (!mounted) return;
        setState(() {
          _results = opportunities.map((o) => _Contract.fromJson(o)).toList();
          _hasSearched = true;
          _isSearching = false;
        });
      } else {
        throw Exception('Server error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isSearching = false;
        _hasSearched = true;
      });
    }
  }

  List<_Contract> get _filtered {
    if (_setAside == 'All') return _results;
    return _results
        .where((c) =>
            (c.setAside ?? '').toLowerCase().contains(_setAside.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _keywordsController.dispose();
    _naicsController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF3B82F6);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Contract Finder')),
      body: Column(
        children: [
          // ── Search panel ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Keywords row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _keywordsController,
                        decoration: InputDecoration(
                          hintText: 'Keywords, agency, or topic…',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    FilledButton.icon(
                      onPressed: _isSearching ? null : _search,
                      icon: _isSearching
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.radar_rounded, size: 18),
                      label: const Text('Search'),
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMd,
                            vertical: AppTheme.spacingMd),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                // NAICS + State row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _naicsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'NAICS code (optional)',
                          prefixIcon: const Icon(Icons.category_outlined,
                              size: AppTheme.iconSm),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: TextField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          hintText: 'State (e.g. VA)',
                          prefixIcon: const Icon(Icons.location_on_outlined,
                              size: AppTheme.iconSm),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                // Set-aside chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _setAsideFilters.map((s) {
                      final selected = _setAside == s;
                      return Padding(
                        padding:
                            const EdgeInsets.only(right: AppTheme.spacingSm),
                        child: ChoiceChip(
                          label: Text(s),
                          selected: selected,
                          selectedColor: accent.withOpacity(0.2),
                          onSelected: (_) => setState(() => _setAside = s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ── Body area ────────────────────────────────────────────────
          if (_isSearching)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      'Scanning contract databases…',
                      style: text.bodyMedium
                          ?.copyWith(color: appColors.subtleText),
                    ),
                  ],
                ),
              ),
            )
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 48, color: appColors.danger),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: text.bodyMedium
                            ?.copyWith(color: appColors.subtleText),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      OutlinedButton(
                        onPressed: _search,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (!_hasSearched)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.manage_search_rounded,
                        size: 56, color: appColors.subtleText),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      'Enter keywords to find matching\ngovernment contracts',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium
                          ?.copyWith(color: appColors.subtleText),
                    ),
                  ],
                ),
              ),
            )
          else if (_filtered.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 48, color: appColors.subtleText),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      'No contracts matched your search',
                      style: text.bodyMedium
                          ?.copyWith(color: appColors.subtleText),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd),
                    child: Row(
                      children: [
                        Text(
                          '${_filtered.length} contract${_filtered.length == 1 ? '' : 's'} found',
                          style: text.bodySmall
                              ?.copyWith(color: appColors.subtleText),
                        ),
                        const Spacer(),
                        Icon(Icons.open_in_new_rounded,
                            size: 12, color: appColors.subtleText),
                        const SizedBox(width: AppTheme.spacingXs),
                        Text('Tap card to open on SAM.gov',
                            style: text.bodySmall
                                ?.copyWith(color: appColors.subtleText)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingXs),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppTheme.spacingSm),
                      itemBuilder: (context, i) =>
                          _ContractCard(contract: _filtered[i]),
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

// ── Contract card ─────────────────────────────────────────────────────────────

class _ContractCard extends StatelessWidget {
  final _Contract contract;
  const _ContractCard({required this.contract});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF3B82F6);

    final deadline = _formatDate(contract.responseDeadline);
    final posted = _formatDate(contract.postedDate);

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      onTap: contract.link != null && contract.link!.isNotEmpty
          ? () => _openLink(context, contract.link!)
          : null,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: appColors.toolCardBg,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
              color: scheme.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Text(
              contract.title,
              style: text.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacingXs),
            // Department
            if (contract.department != null && contract.department!.isNotEmpty)
              Text(
                contract.department!,
                style: text.bodySmall?.copyWith(color: appColors.subtleText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: AppTheme.spacingSm),
            // Tags row
            Wrap(
              spacing: AppTheme.spacingSm,
              runSpacing: AppTheme.spacingXs,
              children: [
                if (contract.setAside != null && contract.setAside!.isNotEmpty)
                  _Tag(contract.setAside!, accent, text),
                if (contract.naicsCode != null && contract.naicsCode!.isNotEmpty)
                  _Tag('NAICS ${contract.naicsCode!}', scheme.primary, text),
                if (contract.type != null && contract.type!.isNotEmpty)
                  _Tag(contract.type!, appColors.warning, text),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            // Meta row: solicitation + dates
            Row(
              children: [
                if (contract.solicitationNumber != null &&
                    contract.solicitationNumber!.isNotEmpty) ...[
                  Icon(Icons.tag_rounded,
                      size: 12, color: appColors.subtleText),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      contract.solicitationNumber!,
                      style: text.bodySmall
                          ?.copyWith(color: appColors.subtleText, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                ],
                if (posted != null) ...[
                  Icon(Icons.schedule_rounded,
                      size: 12, color: appColors.subtleText),
                  const SizedBox(width: 3),
                  Text(
                    'Posted $posted',
                    style: text.bodySmall
                        ?.copyWith(color: appColors.subtleText, fontSize: 11),
                  ),
                ],
              ],
            ),
            if (deadline != null) ...[
              const SizedBox(height: AppTheme.spacingXs),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 12, color: appColors.danger),
                  const SizedBox(width: 3),
                  Text(
                    'Due $deadline',
                    style: text.bodySmall?.copyWith(
                        color: appColors.danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  const Spacer(),
                  if (contract.link != null && contract.link!.isNotEmpty)
                    Icon(Icons.open_in_new_rounded,
                        size: 14, color: appColors.subtleText),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openLink(BuildContext context, String url) {
    // url_launcher is available — use launchUrl when this widget is wired up.
    // For now show a snackbar with the URL so user can copy it.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(url, maxLines: 2, overflow: TextOverflow.ellipsis),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw; // return as-is if not ISO format
    }
  }
}

// ── Tag chip ──────────────────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final TextTheme text;
  const _Tag(this.label, this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: text.labelSmall?.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Contract {
  final String? noticeId;
  final String title;
  final String? solicitationNumber;
  final String? department;
  final String? postedDate;
  final String? type;
  final String? responseDeadline;
  final String? naicsCode;
  final String? setAside;
  final String? link;

  const _Contract({
    this.noticeId,
    required this.title,
    this.solicitationNumber,
    this.department,
    this.postedDate,
    this.type,
    this.responseDeadline,
    this.naicsCode,
    this.setAside,
    this.link,
  });

  factory _Contract.fromJson(Map<String, dynamic> j) => _Contract(
        noticeId: j['noticeId']?.toString(),
        title: j['title']?.toString() ?? '(No title)',
        solicitationNumber: j['solicitationNumber']?.toString(),
        department: j['department']?.toString(),
        postedDate: j['postedDate']?.toString(),
        type: j['type']?.toString(),
        responseDeadline: j['responseDeadline']?.toString(),
        naicsCode: j['naicsCode']?.toString(),
        setAside: j['setAside']?.toString(),
        link: j['link']?.toString(),
      );
}
