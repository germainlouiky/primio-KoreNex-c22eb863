import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/theme.dart';

const _accent = Color(0xFF06B6D4);

const _kCertFilters = [
  'All',
  'Small Business',
  'Woman-Owned (WOSB)',
  'Veteran-Owned (VOSB)',
  'Service-Disabled Veteran-Owned (SDVOSB)',
  '8(a)',
  'HUBZone',
  'Minority-Owned (MBE)',
];

/// US state abbreviations for the State dropdown.
const _kStates = [
  'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
  'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
  'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
  'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
  'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',
  'DC',
];

class VendorMatchingScreen extends StatefulWidget {
  const VendorMatchingScreen({super.key});

  @override
  State<VendorMatchingScreen> createState() => _VendorMatchingScreenState();
}

class _VendorMatchingScreenState extends State<VendorMatchingScreen> {
  final _searchController = TextEditingController();
  final _naicsController = TextEditingController();

  String _filterCert = 'All';
  String? _filterState;

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _vendors = [];

  @override
  void initState() {
    super.initState();
    _loadVendors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _naicsController.dispose();
    super.dispose();
  }

  Future<void> _loadVendors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Supabase.instance.client
          .from('vendor_profiles')
          .select()
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _vendors = List<Map<String, dynamic>>.from(results);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  /// Client-side filtering: keyword search + NAICS + certification + state.
  List<Map<String, dynamic>> get _filtered {
    var list = _vendors;

    // Keyword search against company_name + description + services_offered
    final q = _searchController.text.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list.where((v) {
        final name = (v['company_name'] ?? '').toString().toLowerCase();
        final desc = (v['description'] ?? '').toString().toLowerCase();
        final svcs = (v['services_offered'] ?? '').toString().toLowerCase();
        return name.contains(q) || desc.contains(q) || svcs.contains(q);
      }).toList();
    }

    // NAICS filter
    final naicsQ = _naicsController.text.trim();
    if (naicsQ.isNotEmpty) {
      list = list.where((v) {
        final codes = v['naics_codes'];
        if (codes is! List) return false;
        return codes.any((c) => c.toString().contains(naicsQ));
      }).toList();
    }

    // Certification chip filter
    if (_filterCert != 'All') {
      list = list.where((v) {
        final certs = v['certifications'];
        if (certs is! List) return false;
        return certs.any((c) =>
            c.toString().toLowerCase().contains(_filterCert.toLowerCase()));
      }).toList();
    }

    // State filter
    if (_filterState != null) {
      list = list
          .where((v) =>
              (v['state'] ?? '').toString().toUpperCase() ==
              _filterState!.toUpperCase())
          .toList();
    }

    return list;
  }

  Future<void> _goToProfile() async {
    final refreshed = await context.push<bool>('/vendor-profile');
    if (refreshed == true) _loadVendors();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    final vendors = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Directory'),
        actions: [
          IconButton(
            tooltip: 'My Vendor Profile',
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: _goToProfile,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToProfile,
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('My Profile'),
      ),
      body: Column(
        children: [
          // ── Search panel ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd, AppTheme.spacingMd,
                AppTheme.spacingMd, AppTheme.spacingXs),
            child: Column(
              children: [
                // Keyword search
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search vendors, services…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium)),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),

                // NAICS + State row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _naicsController,
                        onChanged: (_) => setState(() {}),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'NAICS code',
                          prefixIcon: const Icon(Icons.category_outlined,
                              size: AppTheme.iconSm),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterState,
                        decoration: InputDecoration(
                          hintText: 'State',
                          prefixIcon: const Icon(Icons.location_on_outlined,
                              size: AppTheme.iconSm),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text('State'),
                        items: [
                          const DropdownMenuItem<String>(
                              value: null, child: Text('Any')),
                          ..._kStates
                              .map((s) => DropdownMenuItem(
                                  value: s, child: Text(s)))
                              .toList(),
                        ],
                        dropdownColor: appColors.cardHighlight,
                        onChanged: (v) => setState(() => _filterState = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Certification chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Row(
              children: _kCertFilters.map((c) {
                final sel = _filterCert == c;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    selectedColor: _accent.withOpacity(0.2),
                    onSelected: (_) => setState(() => _filterCert = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Result count / reload
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Row(
              children: [
                Text(
                  _isLoading
                      ? 'Loading…'
                      : '${vendors.length} vendor${vendors.length == 1 ? '' : 's'} found',
                  style:
                      text.bodySmall?.copyWith(color: appColors.subtleText),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh',
                  icon: Icon(Icons.refresh_rounded,
                      size: AppTheme.iconSm, color: appColors.subtleText),
                  onPressed: _loadVendors,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // ── Body ───────────────────────────────────────────────────────
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLg),
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
                          onPressed: _loadVendors,
                          child: const Text('Try Again')),
                    ],
                  ),
                ),
              ),
            )
          else if (vendors.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group_outlined,
                        size: 56, color: appColors.subtleText),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      _vendors.isEmpty
                          ? 'No vendors in the directory yet.\nBe the first — create your profile!'
                          : 'No vendors matched your filters.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium
                          ?.copyWith(color: appColors.subtleText),
                    ),
                    if (_vendors.isEmpty) ...[
                      const SizedBox(height: AppTheme.spacingMd),
                      FilledButton.icon(
                        onPressed: _goToProfile,
                        style:
                            FilledButton.styleFrom(backgroundColor: _accent),
                        icon: const Icon(Icons.add),
                        label: const Text('Create My Profile'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingXs),
                itemCount: vendors.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppTheme.spacingSm),
                itemBuilder: (context, i) =>
                    _VendorCard(vendor: vendors[i], onProfile: _goToProfile),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Vendor card ───────────────────────────────────────────────────────────────

class _VendorCard extends StatelessWidget {
  final Map<String, dynamic> vendor;
  final VoidCallback onProfile;
  const _VendorCard({required this.vendor, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    final colors = Theme.of(context).colorScheme;

    final companyName = (vendor['company_name'] ?? '').toString();
    final description = (vendor['description'] ?? '').toString();
    final services = (vendor['services_offered'] ?? '').toString();
    final state = (vendor['state'] ?? '').toString();
    final email = (vendor['contact_email'] ?? '').toString();
    final phone = (vendor['contact_phone'] ?? '').toString();
    final website = (vendor['website'] ?? '').toString();

    final List<String> certs = vendor['certifications'] is List
        ? List<String>.from(
            (vendor['certifications'] as List).map((e) => e.toString()))
        : [];
    final List<String> naics = vendor['naics_codes'] is List
        ? List<String>.from(
            (vendor['naics_codes'] as List).map((e) => e.toString()))
        : [];

    final initial =
        companyName.isNotEmpty ? companyName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: appColors.toolCardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
            color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _accent.withOpacity(0.15),
                child:
                    Text(initial, style: text.titleMedium?.copyWith(color: _accent)),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: text.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 12, color: appColors.subtleText),
                          const SizedBox(width: 2),
                          Text(state,
                              style: text.bodySmall
                                  ?.copyWith(color: appColors.subtleText)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Description
          if (description.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Text(description,
                style: text.bodySmall?.copyWith(color: appColors.subtleText),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],

          // Services
          if (services.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              'Services: $services',
              style: text.bodySmall?.copyWith(color: appColors.subtleText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Tags row: certifications + NAICS
          if (certs.isNotEmpty || naics.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Wrap(
              spacing: AppTheme.spacingXs,
              runSpacing: AppTheme.spacingXs,
              children: [
                ...certs.map((c) => _Tag(c, _accent, text)),
                ...naics.map((n) => _Tag('NAICS $n', colors.primary, text)),
              ],
            ),
          ],

          // Contact row
          if (email.isNotEmpty || phone.isNotEmpty || website.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Wrap(
              spacing: AppTheme.spacingMd,
              runSpacing: AppTheme.spacingXs,
              children: [
                if (email.isNotEmpty)
                  _ContactItem(Icons.email_outlined, email, appColors, text),
                if (phone.isNotEmpty)
                  _ContactItem(Icons.phone_outlined, phone, appColors, text),
                if (website.isNotEmpty)
                  _ContactItem(Icons.language_outlined, website, appColors, text),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColorsExtension appColors;
  final TextTheme text;
  const _ContactItem(this.icon, this.label, this.appColors, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: appColors.subtleText),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            label,
            style: text.bodySmall?.copyWith(
                color: appColors.subtleText, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: text.labelSmall?.copyWith(color: color, fontSize: 10)),
    );
  }
}
