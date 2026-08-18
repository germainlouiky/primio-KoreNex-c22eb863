import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/pricing_provider.dart';
import '../theme/theme.dart';
import '../widgets/common/pricing_card.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PricingProvider>();
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spacingMd),
              Text('Choose Your Plan', style: text.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                'Automate your entire procurement workflow',
                style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              ...provider.tiers.map(
                (tier) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                  child: PricingCard(
                    tier: tier,
                    onSelect: () => context.push('/plan/${tier.name.toLowerCase()}'),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}
