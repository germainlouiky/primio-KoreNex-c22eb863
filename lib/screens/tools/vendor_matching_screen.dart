import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class VendorMatchingScreen extends StatefulWidget {
  const VendorMatchingScreen({super.key});

  @override
  State<VendorMatchingScreen> createState() => _VendorMatchingScreenState();
}

class _VendorMatchingScreenState extends State<VendorMatchingScreen> {
  final _searchController = TextEditingController();
  String _filterCert = 'All';
  final List<_Vendor> _allVendors = [
    _Vendor('TechForward Solutions', 'IT Services & Cloud', '541512', 'SDVOSB', 4.8, 23, 'Washington, DC', true),
    _Vendor('CyberShield Corp', 'Cybersecurity', '541519', '8(a)', 4.6, 18, 'Reston, VA', true),
    _Vendor('Apex Logistics', 'Supply Chain & Logistics', '541614', 'Small Business', 4.3, 31, 'San Antonio, TX', true),
    _Vendor('GreenBuild Contractors', 'Construction & Facilities', '236220', 'HUBZone', 4.5, 14, 'Atlanta, GA', false),
    _Vendor('DataPulse Analytics', 'Data Science & AI/ML', '541511', 'WOSB', 4.9, 9, 'Austin, TX', true),
    _Vendor('SecureNet Partners', 'Network Infrastructure', '541513', 'SDVOSB', 4.2, 27, 'Colorado Springs, CO', true),
    _Vendor('Meridian Consulting', 'Management Consulting', '541611', 'Small Business', 4.7, 42, 'Arlington, VA', false),
    _Vendor('Quantum Engineering', 'Systems Engineering', '541330', '8(a)', 4.4, 16, 'Huntsville, AL', true),
  ];

  List<_Vendor> get _filtered {
    var list = _allVendors;
    if (_filterCert != 'All') list = list.where((v) => v.certType == _filterCert).toList();
    final q = _searchController.text.toLowerCase();
    if (q.isNotEmpty) list = list.where((v) => v.name.toLowerCase().contains(q) || v.specialty.toLowerCase().contains(q) || v.naics.contains(q)).toList();
    return list;
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
    const accent = Color(0xFF06B6D4);
    final vendors = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Matching')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search vendors, NAICS codes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Row(
              children: ['All', 'SDVOSB', '8(a)', 'WOSB', 'HUBZone', 'Small Business'].map((c) {
                final sel = _filterCert == c;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                  child: ChoiceChip(label: Text(c), selected: sel, selectedColor: accent.withOpacity(0.2), onSelected: (_) => setState(() => _filterCert = c)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Align(alignment: Alignment.centerLeft, child: Text('${vendors.length} vendors found', style: text.bodySmall?.copyWith(color: appColors.subtleText))),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              itemCount: vendors.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
              itemBuilder: (context, i) {
                final v = vendors[i];
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
                        CircleAvatar(backgroundColor: accent.withOpacity(0.15), child: Text(v.name[0], style: text.titleMedium?.copyWith(color: accent))),
                        const SizedBox(width: AppTheme.spacingSm),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Flexible(child: Text(v.name, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            if (v.samVerified) ...[
                              const SizedBox(width: AppTheme.spacingXs),
                              Icon(Icons.verified, color: accent, size: AppTheme.iconSm),
                            ],
                          ]),
                          Text(v.specialty, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                        ])),
                      ]),
                      const SizedBox(height: AppTheme.spacingSm),
                      Row(children: [
                        _Tag(v.certType, accent, text),
                        const SizedBox(width: AppTheme.spacingSm),
                        _Tag('NAICS ${v.naics}', colors.primary, text),
                        const Spacer(),
                        Icon(Icons.star_rounded, color: appColors.warning, size: AppTheme.iconSm),
                        const SizedBox(width: 2),
                        Text('${v.rating}', style: text.labelSmall),
                        Text(' (${v.contracts})', style: text.labelSmall?.copyWith(color: appColors.subtleText)),
                      ]),
                      const SizedBox(height: AppTheme.spacingXs),
                      Row(children: [
                        Icon(Icons.location_on_outlined, size: AppTheme.iconSm, color: appColors.subtleText),
                        const SizedBox(width: AppTheme.spacingXs),
                        Text(v.location, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.send_rounded, size: AppTheme.iconSm, color: accent),
                          label: Text('Connect', style: text.labelSmall?.copyWith(color: accent)),
                        ),
                      ]),
                    ],
                  ),
                );
              },
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

class _Vendor {
  final String name, specialty, naics, certType, location;
  final double rating;
  final int contracts;
  final bool samVerified;
  _Vendor(this.name, this.specialty, this.naics, this.certType, this.rating, this.contracts, this.location, this.samVerified);
}
