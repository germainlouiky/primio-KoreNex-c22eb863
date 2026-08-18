import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CapabilityStatementScreen extends StatefulWidget {
  const CapabilityStatementScreen({super.key});

  @override
  State<CapabilityStatementScreen> createState() => _CapabilityStatementScreenState();
}

class _CapabilityStatementScreenState extends State<CapabilityStatementScreen> {
  final _companyController = TextEditingController(text: 'Acme Federal Solutions');
  final _cageController = TextEditingController(text: '5ABC7');
  final _dunsController = TextEditingController(text: '123456789');
  final _naicsController = TextEditingController(text: '541512, 541519, 541611');
  final _coreController = TextEditingController(text: 'Cloud migration, cybersecurity, IT modernization, data analytics');
  bool _isGenerating = false;
  bool _showPreview = false;

  @override
  void dispose() {
    _companyController.dispose();
    _cageController.dispose();
    _dunsController.dispose();
    _naicsController.dispose();
    _coreController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _showPreview = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF14B8A6);

    return Scaffold(
      appBar: AppBar(title: const Text('Capability Statement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: _showPreview ? _preview(colors, text, appColors, accent) : _form(colors, text, appColors, accent),
      ),
    );
  }

  Widget _form(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company Information', style: text.titleMedium),
        const SizedBox(height: AppTheme.spacingSm),
        _field(_companyController, 'Company Name'),
        _field(_cageController, 'CAGE Code'),
        _field(_dunsController, 'UEI / DUNS Number'),
        _field(_naicsController, 'NAICS Codes (comma separated)'),
        const SizedBox(height: AppTheme.spacingMd),
        Text('Core Competencies', style: text.titleMedium),
        const SizedBox(height: AppTheme.spacingSm),
        TextField(
          controller: _coreController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe your core capabilities...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Text('Certifications', style: text.titleMedium),
        const SizedBox(height: AppTheme.spacingSm),
        Wrap(
          spacing: AppTheme.spacingSm,
          runSpacing: AppTheme.spacingSm,
          children: ['8(a)', 'SDVOSB', 'WOSB', 'HUBZone', 'ISO 9001', 'CMMC L2'].map((c) {
            return FilterChip(label: Text(c), selected: c == '8(a)' || c == 'ISO 9001', selectedColor: accent.withOpacity(0.2), onSelected: (_) {});
          }).toList(),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        SizedBox(
          width: double.infinity,
          height: AppTheme.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: _isGenerating ? null : _generate,
            style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
            icon: _isGenerating
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.auto_fix_high_rounded),
            label: Text(_isGenerating ? 'Generating...' : 'Generate Capability Statement'),
          ),
        ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        ),
      ),
    );
  }

  Widget _preview(ColorScheme colors, TextTheme text, AppColorsExtension appColors, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.check_circle, color: appColors.success, size: AppTheme.iconMd),
          const SizedBox(width: AppTheme.spacingSm),
          Text('Capability Statement Generated', style: text.titleMedium),
        ]),
        const SizedBox(height: AppTheme.spacingMd),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: appColors.toolCardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: accent.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(_companyController.text.toUpperCase(), style: text.headlineSmall?.copyWith(color: accent, letterSpacing: 1.5))),
              Center(child: Text('CAPABILITY STATEMENT', style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 2))),
              const Divider(height: AppTheme.spacingXl),
              _section('ABOUT US', 'A leading provider of IT solutions and professional services to federal agencies. Our team of cleared professionals delivers mission-critical solutions across defense, intelligence, and civilian markets.', text, appColors),
              _section('CORE COMPETENCIES', '• Cloud Migration & Modernization\n• Cybersecurity & Risk Management\n• IT Modernization & Digital Transformation\n• Data Analytics & AI/ML Solutions', text, appColors),
              _section('PAST PERFORMANCE', '• DoD JEDI Cloud Task Order — \$4.2M\n• DHS Cybersecurity Assessment — \$2.8M\n• VA IT Helpdesk Support — \$1.5M\n• GSA Network Infrastructure — \$3.6M', text, appColors),
              _section('COMPANY DATA', 'CAGE: ${_cageController.text}\nUEI: ${_dunsController.text}\nNAICS: ${_naicsController.text}\nCertifications: 8(a), ISO 9001', text, appColors),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _showPreview = false),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Edit'),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF export ready for download')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: const Text('Export PDF'),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _section(String title, String body, TextTheme text, AppColorsExtension appColors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.5)),
        const SizedBox(height: AppTheme.spacingXs),
        Text(body, style: text.bodyMedium?.copyWith(height: 1.6)),
      ]),
    );
  }
}
