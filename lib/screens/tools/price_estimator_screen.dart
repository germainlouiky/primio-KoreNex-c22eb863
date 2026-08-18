import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class PriceEstimatorScreen extends StatefulWidget {
  const PriceEstimatorScreen({super.key});

  @override
  State<PriceEstimatorScreen> createState() => _PriceEstimatorScreenState();
}

class _PriceEstimatorScreenState extends State<PriceEstimatorScreen> {
  final _titleController = TextEditingController();
  final _naicsController = TextEditingController(text: '541512');
  String _contractType = 'FFP';
  double _duration = 12;
  bool _isAnalyzing = false;
  bool _showResults = false;

  @override
  void dispose() {
    _titleController.dispose();
    _naicsController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isAnalyzing = false;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFF10B981);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Price Estimator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contract Details', style: text.titleMedium),
            const SizedBox(height: AppTheme.spacingSm),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Contract Title / Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextField(
              controller: _naicsController,
              decoration: InputDecoration(
                labelText: 'NAICS Code',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text('Contract Type', style: text.titleSmall),
            const SizedBox(height: AppTheme.spacingSm),
            Wrap(
              spacing: AppTheme.spacingSm,
              children: ['FFP', 'T&M', 'Cost-Plus', 'IDIQ'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _contractType == type,
                  selectedColor: accent.withOpacity(0.2),
                  onSelected: (_) => setState(() => _contractType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text('Duration: ${_duration.toInt()} months', style: text.titleSmall),
            Slider(
              value: _duration,
              min: 3,
              max: 60,
              divisions: 19,
              activeColor: accent,
              label: '${_duration.toInt()} months',
              onChanged: (v) => setState(() => _duration = v),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            SizedBox(
              width: double.infinity,
              height: AppTheme.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyze,
                style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
                icon: _isAnalyzing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.insights_rounded),
                label: Text(_isAnalyzing ? 'Analyzing market data...' : 'Analyze Pricing'),
              ),
            ),
            if (_showResults) ...[
              const SizedBox(height: AppTheme.spacingLg),
              _ResultCard(
                title: 'Recommended Price Range',
                value: '\$1.2M — \$1.8M',
                subtitle: 'Based on 34 comparable awards in NAICS ${_naicsController.text}',
                icon: Icons.attach_money_rounded,
                accent: accent,
                appColors: appColors,
                colors: colors,
                text: text,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _ResultCard(
                title: 'Price-to-Win Estimate',
                value: '\$1.45M',
                subtitle: 'Optimal competitive position with 72% win probability',
                icon: Icons.emoji_events_rounded,
                accent: accent,
                appColors: appColors,
                colors: colors,
                text: text,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _ResultCard(
                title: 'Market Average',
                value: '\$1.55M',
                subtitle: 'Average award value for similar contracts (FY24–FY26)',
                icon: Icons.bar_chart_rounded,
                accent: accent,
                appColors: appColors,
                colors: colors,
                text: text,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: appColors.toolCardBg,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: accent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Labor Rate Breakdown', style: text.titleSmall),
                    const SizedBox(height: AppTheme.spacingSm),
                    _RateRow(role: 'Senior Engineer', rate: '\$165/hr', text: text, appColors: appColors),
                    _RateRow(role: 'Project Manager', rate: '\$145/hr', text: text, appColors: appColors),
                    _RateRow(role: 'Systems Analyst', rate: '\$125/hr', text: text, appColors: appColors),
                    _RateRow(role: 'Junior Developer', rate: '\$95/hr', text: text, appColors: appColors),
                    const Divider(height: AppTheme.spacingLg),
                    _RateRow(role: 'Blended Rate', rate: '\$132/hr', text: text, appColors: appColors, bold: true),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final AppColorsExtension appColors;
  final ColorScheme colors;
  final TextTheme text;

  const _ResultCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.appColors,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
            child: Icon(icon, color: accent, size: AppTheme.iconMd),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                Text(value, style: text.titleLarge?.copyWith(color: accent)),
                Text(subtitle, style: text.bodySmall?.copyWith(color: appColors.subtleText), maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final String role;
  final String rate;
  final TextTheme text;
  final AppColorsExtension appColors;
  final bool bold;

  const _RateRow({required this.role, required this.rate, required this.text, required this.appColors, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(role, style: bold ? text.titleSmall : text.bodyMedium),
          Text(rate, style: bold ? text.titleSmall : text.bodyMedium?.copyWith(color: appColors.subtleText)),
        ],
      ),
    );
  }
}
