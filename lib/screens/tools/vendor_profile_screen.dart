import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/theme.dart';

/// All certification options shown as checkboxes.
const _kCertOptions = [
  'Small Business',
  'Woman-Owned (WOSB)',
  'Veteran-Owned (VOSB)',
  'Service-Disabled Veteran-Owned (SDVOSB)',
  '8(a)',
  'HUBZone',
  'Minority-Owned (MBE)',
  'Disadvantaged Business (SDB)',
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

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _companyNameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _servicesCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _naicsInputCtrl = TextEditingController();

  // State
  String? _selectedState;
  final List<String> _naicsCodes = [];
  final Set<String> _certifications = {};

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  bool _profileExists = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _servicesCtrl.dispose();
    _websiteCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _naicsInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final data = await Supabase.instance.client
          .from('vendor_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (!mounted) return;
      if (data != null) {
        _profileExists = true;
        _companyNameCtrl.text = data['company_name'] ?? '';
        _descriptionCtrl.text = data['description'] ?? '';
        _servicesCtrl.text = data['services_offered'] ?? '';
        _websiteCtrl.text = data['website'] ?? '';
        _emailCtrl.text = data['contact_email'] ?? '';
        _phoneCtrl.text = data['contact_phone'] ?? '';
        _selectedState = data['state'];

        final naics = data['naics_codes'];
        if (naics is List) {
          _naicsCodes
            ..clear()
            ..addAll(naics.map((e) => e.toString()));
        }

        final certs = data['certifications'];
        if (certs is List) {
          _certifications
            ..clear()
            ..addAll(certs.map((e) => e.toString()));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addNaicsCode() {
    final code = _naicsInputCtrl.text.trim();
    if (code.isEmpty) return;
    if (!_naicsCodes.contains(code)) {
      setState(() => _naicsCodes.add(code));
    }
    _naicsInputCtrl.clear();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      await Supabase.instance.client.from('vendor_profiles').upsert(
        {
          'user_id': userId,
          'company_name': _companyNameCtrl.text.trim(),
          'description': _descriptionCtrl.text.trim(),
          'naics_codes': _naicsCodes,
          'certifications': _certifications.toList(),
          'services_offered': _servicesCtrl.text.trim(),
          'state': _selectedState,
          'website': _websiteCtrl.text.trim(),
          'contact_email': _emailCtrl.text.trim(),
          'contact_phone': _phoneCtrl.text.trim(),
        },
        onConflict: 'user_id',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_profileExists
              ? 'Profile updated successfully.'
              : 'Profile created! You\'re now listed in the Vendor Directory.'),
          backgroundColor: Theme.of(context).extension<AppColorsExtension>()!.success,
        ),
      );
      Navigator.of(context).pop(true); // return true = refresh parent
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF06B6D4);

    return Scaffold(
      appBar: AppBar(
        title: Text(_profileExists ? 'Edit My Vendor Profile' : 'Create Vendor Profile'),
        actions: [
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacingSm),
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                style: FilledButton.styleFrom(backgroundColor: accent),
                child: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save'),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                children: [
                  // Error banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      decoration: BoxDecoration(
                        color: appColors.danger.withOpacity(AppTheme.opacityOverlay),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(
                            color: appColors.danger
                                .withOpacity(AppTheme.opacityHint)),
                      ),
                      child: Text(_errorMessage!,
                          style: text.bodySmall
                              ?.copyWith(color: appColors.danger)),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                  ],

                  // ── Company Info ────────────────────────────────────────
                  _SectionHeader('Company Info', text),
                  const SizedBox(height: AppTheme.spacingSm),

                  TextFormField(
                    controller: _companyNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Company Name *',
                      hintText: 'Your business legal name',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Company name is required'
                        : null,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  TextFormField(
                    controller: _descriptionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Company Description',
                      hintText: 'Brief overview of your company and mission',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  TextFormField(
                    controller: _servicesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Services Offered',
                      hintText: 'Describe the services you provide',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // ── Location & Contact ──────────────────────────────────
                  _SectionHeader('Location & Contact', text),
                  const SizedBox(height: AppTheme.spacingSm),

                  // State dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    hint: const Text('Select state'),
                    isExpanded: true,
                    items: _kStates
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedState = v),
                    dropdownColor: appColors.cardHighlight,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  TextFormField(
                    controller: _websiteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Website',
                      hintText: 'https://yourcompany.com',
                      prefixIcon: Icon(Icons.language_outlined),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Contact Email',
                      hintText: 'contact@yourcompany.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone',
                      hintText: '(555) 555-5555',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // ── NAICS Codes ─────────────────────────────────────────
                  _SectionHeader('NAICS Codes', text),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Add the NAICS codes that describe your primary services.',
                    style: text.bodySmall?.copyWith(color: appColors.subtleText),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _naicsInputCtrl,
                          decoration: InputDecoration(
                            hintText: 'e.g. 541512',
                            prefixIcon: const Icon(Icons.tag_rounded),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingMd,
                                vertical: AppTheme.spacingSm),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) => _addNaicsCode(),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      OutlinedButton(
                        onPressed: _addNaicsCode,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          side: BorderSide(color: colors.outline),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),

                  if (_naicsCodes.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingSm),
                    Wrap(
                      spacing: AppTheme.spacingSm,
                      runSpacing: AppTheme.spacingXs,
                      children: _naicsCodes
                          .map(
                            (code) => Chip(
                              label: Text(code),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () =>
                                  setState(() => _naicsCodes.remove(code)),
                              backgroundColor:
                                  accent.withOpacity(AppTheme.opacityOverlay),
                              labelStyle: text.labelSmall
                                  ?.copyWith(color: accent),
                              side: BorderSide(
                                  color: accent
                                      .withOpacity(AppTheme.opacityHint)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingLg),

                  // ── Certifications ──────────────────────────────────────
                  _SectionHeader('Certifications', text),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Select all that apply to your business.',
                    style: text.bodySmall?.copyWith(color: appColors.subtleText),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),

                  ..._kCertOptions.map(
                    (cert) => CheckboxListTile(
                      value: _certifications.contains(cert),
                      title: Text(cert, style: text.bodyMedium),
                      activeColor: accent,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _certifications.add(cert);
                          } else {
                            _certifications.remove(cert);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // ── Save button (bottom) ────────────────────────────────
                  SizedBox(
                    height: AppTheme.buttonHeight,
                    child: FilledButton(
                      onPressed: _isSaving ? null : _save,
                      style: FilledButton.styleFrom(backgroundColor: accent),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_profileExists
                              ? 'Update Profile'
                              : 'Publish to Directory'),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final TextTheme text;
  const _SectionHeader(this.title, this.text);

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.titleSmall),
        const SizedBox(height: AppTheme.spacingXs),
        Divider(color: appColors.cardHighlight, height: 1),
      ],
    );
  }
}
