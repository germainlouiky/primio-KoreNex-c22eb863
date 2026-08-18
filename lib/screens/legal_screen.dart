import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum LegalTab { privacy, terms }

class LegalScreen extends StatefulWidget {
  final LegalTab initialTab;

  const LegalScreen({super.key, this.initialTab = LegalTab.privacy});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.index,
    );
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Legal', style: text.titleLarge),
        leading: BackButton(color: colors.onSurface),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: appColors.subtleText,
          indicatorColor: colors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Privacy Policy'),
            Tab(text: 'Terms of Service'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PrivacyPolicyTab(colors: colors, text: text, appColors: appColors),
          _TermsOfServiceTab(colors: colors, text: text, appColors: appColors),
        ],
      ),
    );
  }
}

// ─── Privacy Policy ───────────────────────────────────────────────────────────

class _PrivacyPolicyTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _PrivacyPolicyTab({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      children: [
        _LegalHeader(
          icon: Icons.shield_outlined,
          iconColor: colors.primary,
          title: 'Privacy Policy',
          subtitle: 'Last updated: June 27, 2026',
          colors: colors,
          text: text,
          appColors: appColors,
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _LegalSection(
          title: '1. Information We Collect',
          body:
              'We collect information you provide directly to us when creating an account, '
              'subscribing to a plan, or using our AI-powered procurement tools. This includes:\n\n'
              '• Account information: name, email address, organization name, and password\n'
              '• Organization details: NAICS codes, CAGE code, UEI number, and business size standard\n'
              '• Usage data: contracts searched, bids written, proposals submitted, and feature interactions\n'
              '• Payment information: processed securely via Stripe — KoreNex never stores full card numbers\n'
              '• Communications: messages sent to our support team or through in-app feedback',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '2. How We Use Your Information',
          body:
              'KoreNex uses collected information to:\n\n'
              '• Provide, maintain, and improve our AI procurement tools\n'
              '• Personalize contract recommendations and bid-writing suggestions\n'
              '• Process payments and manage your subscription\n'
              '• Send transactional emails such as deadline reminders and bid status updates\n'
              '• Analyze aggregate usage patterns to improve product features\n'
              '• Respond to your support requests and communications\n'
              '• Comply with legal obligations and enforce our Terms of Service',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '3. AI Processing & Your Data',
          body:
              'When you use AI features such as the Bid Writer, Contract Finder, or Capability '
              'Statement Generator, your input text is sent to third-party AI providers (including '
              'OpenAI and Anthropic) for processing. We do not use your procurement data to train '
              'third-party AI models. Prompts are processed transiently and are not stored by AI '
              'providers beyond the immediate API call per their current data retention policies.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '4. Data Sharing',
          body:
              'We do not sell your personal information. We may share data with:\n\n'
              '• Service providers: Supabase (database), Stripe (payments), SendGrid (email), '
              'OpenAI and Anthropic (AI processing) — all under contractual data protection obligations\n'
              '• SAM.gov and other public procurement data sources for contract matching\n'
              '• Law enforcement or regulators when required by applicable law\n'
              '• A successor entity in the event of a merger or acquisition, with prior notice to users',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '5. Data Retention',
          body:
              'We retain your account data for as long as your account is active or as needed to '
              'provide services. You may request deletion of your account and associated data at any '
              'time by contacting privacy@korenex.com. We will process deletion requests within 30 '
              'days, subject to legal retention requirements.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '6. Security',
          body:
              'We implement industry-standard security measures including TLS encryption in transit, '
              'AES-256 encryption at rest, and row-level security on all database records. Access to '
              'production systems is restricted to authorized personnel. We perform regular security '
              'audits. No system is 100% secure — please use a strong, unique password and enable '
              'two-factor authentication when available.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '7. Your Rights',
          body:
              'Depending on your jurisdiction, you may have rights to:\n\n'
              '• Access the personal data we hold about you\n'
              '• Correct inaccurate or incomplete data\n'
              '• Request deletion of your data ("right to be forgotten")\n'
              '• Data portability — receive your data in a machine-readable format\n'
              '• Opt out of marketing communications at any time\n\n'
              'To exercise these rights, contact us at privacy@korenex.com.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '8. Cookies & Tracking',
          body:
              'Our web app uses essential cookies required for authentication and session management. '
              'We use analytics cookies (via privacy-respecting tools) to understand feature usage '
              'in aggregate. You can disable non-essential cookies in your browser settings without '
              'affecting core functionality.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '9. Contact Us',
          body:
              'For privacy-related questions or to exercise your data rights:\n\n'
              'Email: privacy@korenex.com\n'
              'KoreNex, Inc.\n'
              'United States',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        const SizedBox(height: AppTheme.spacingXl),
      ],
    );
  }
}

// ─── Terms of Service ─────────────────────────────────────────────────────────

class _TermsOfServiceTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _TermsOfServiceTab({
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      children: [
        _LegalHeader(
          icon: Icons.gavel_rounded,
          iconColor: colors.secondary,
          title: 'Terms of Service',
          subtitle: 'Last updated: June 27, 2026',
          colors: colors,
          text: text,
          appColors: appColors,
        ),
        const SizedBox(height: AppTheme.spacingLg),
        _LegalSection(
          title: '1. Acceptance of Terms',
          body:
              'By accessing or using KoreNex ("the Service"), you agree to be bound by these Terms '
              'of Service. If you are using the Service on behalf of an organization, you represent '
              'that you have authority to bind that organization to these terms. If you do not agree, '
              'do not access or use the Service.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '2. Description of Service',
          body:
              'KoreNex is a B2B SaaS platform providing AI-assisted procurement tools including '
              'contract discovery, bid writing, price estimation, compliance tracking, vendor '
              'matching, proposal management, CRM, deadline calendar, and capability statement '
              'generation. Features available depend on your subscription tier.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '3. Accounts & Subscriptions',
          body:
              'You must provide accurate, current information when creating an account. You are '
              'responsible for maintaining the confidentiality of your credentials and for all '
              'activity under your account.\n\n'
              'Subscriptions are billed in advance on a monthly or annual basis. You may cancel '
              'at any time; cancellation takes effect at the end of the current billing period. '
              'No refunds are issued for partial billing periods unless required by applicable law.\n\n'
              'We reserve the right to modify pricing with 30 days notice. Continued use after '
              'a price change constitutes acceptance of the new pricing.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '4. Acceptable Use',
          body:
              'You agree not to:\n\n'
              '• Use the Service to submit false, fraudulent, or misleading bid or proposal content\n'
              '• Attempt to reverse-engineer, scrape, or extract our AI models or proprietary data\n'
              '• Share account credentials with unauthorized users outside your purchased seat count\n'
              '• Use the Service in any way that violates applicable federal procurement regulations\n'
              '• Upload malicious code, conduct denial-of-service attacks, or attempt unauthorized access\n'
              '• Resell or sublicense the Service without our express written permission',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '5. AI-Generated Content',
          body:
              'KoreNex provides AI-generated content as a drafting aid only. All bid submissions, '
              'compliance determinations, price estimates, and proposals are your sole responsibility. '
              'You must review all AI-generated output for accuracy, regulatory compliance, and '
              'fitness for purpose before use. KoreNex is not liable for errors in AI-generated '
              'content or for any bid outcomes, contract awards, or regulatory decisions.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '6. Intellectual Property',
          body:
              'KoreNex and its licensors own all rights in the Service, including software, AI '
              'models, and product design. You retain ownership of your input data and any content '
              'you create. You grant KoreNex a limited license to process your data solely to '
              'provide the Service.\n\n'
              'Output generated by AI tools in response to your inputs is owned by you, subject '
              'to applicable AI provider terms and any third-party data included in that output.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '7. Disclaimer of Warranties',
          body:
              'THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, '
              'EXPRESS OR IMPLIED, INCLUDING WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR '
              'PURPOSE, OR NON-INFRINGEMENT. WE DO NOT WARRANT THAT THE SERVICE WILL BE '
              'UNINTERRUPTED, ERROR-FREE, OR THAT AI OUTPUT WILL BE ACCURATE OR COMPLETE.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '8. Limitation of Liability',
          body:
              'TO THE MAXIMUM EXTENT PERMITTED BY LAW, KORENEX SHALL NOT BE LIABLE FOR ANY '
              'INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, OR ANY LOSS '
              'OF PROFITS, REVENUE, DATA, OR BUSINESS OPPORTUNITIES, EVEN IF ADVISED OF THE '
              'POSSIBILITY OF SUCH DAMAGES.\n\n'
              'OUR TOTAL LIABILITY FOR ANY CLAIM ARISING FROM YOUR USE OF THE SERVICE SHALL NOT '
              'EXCEED THE FEES PAID BY YOU IN THE THREE MONTHS PRECEDING THE CLAIM.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '9. Termination',
          body:
              'We may suspend or terminate your account for material violation of these Terms, '
              'non-payment, or fraudulent activity, with or without notice depending on severity. '
              'You may terminate your account at any time. Upon termination, your right to access '
              'the Service ceases immediately. We will retain your data for 30 days post-termination '
              'before deletion, during which you may request an export.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        _LegalSection(
          title: '10. Governing Law',
          body:
              'These Terms are governed by the laws of the United States. Any disputes shall be '
              'resolved through binding arbitration in accordance with AAA Commercial Arbitration '
              'Rules, except that either party may seek injunctive relief in a court of competent '
              'jurisdiction.\n\n'
              'For questions about these Terms, contact legal@korenex.com.',
          text: text,
          appColors: appColors,
          colors: colors,
        ),
        const SizedBox(height: AppTheme.spacingXl),
      ],
    );
  }
}

// ─── Shared components ────────────────────────────────────────────────────────

class _LegalHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final ColorScheme colors;
  final TextTheme text;
  final AppColorsExtension appColors;

  const _LegalHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.text,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: iconColor.withOpacity(0.20),
          width: AppTheme.borderDefault,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, color: iconColor, size: AppTheme.iconMd),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  subtitle,
                  style: text.bodySmall?.copyWith(color: appColors.subtleText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  final String title;
  final String body;
  final TextTheme text;
  final AppColorsExtension appColors;
  final ColorScheme colors;

  const _LegalSection({
    required this.title,
    required this.body,
    required this.text,
    required this.appColors,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleSmall),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            body,
            style: text.bodyMedium?.copyWith(
              color: appColors.subtleText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
