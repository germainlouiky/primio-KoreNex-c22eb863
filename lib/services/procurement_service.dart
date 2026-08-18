import 'package:flutter/material.dart';
import '../models/tool_item.dart';

class ProcurementService {
  List<ToolItem> getTools() {
    return const [
      ToolItem(
        id: 'contract_finder',
        name: 'AI Contract Finder',
        description: 'Discover relevant government and private contracts matched to your capabilities.',
        icon: Icons.search_rounded,
        accentColor: Color(0xFF3B82F6),
        tagline: 'Find the right contracts before your competitors do.',
        features: [
          ToolFeature(
            icon: Icons.radar_rounded,
            title: 'Smart Contract Matching',
            description: 'AI scans thousands of databases daily and surfaces only the contracts that match your NAICS codes, past performance, and capability profile.',
          ),
          ToolFeature(
            icon: Icons.filter_alt_rounded,
            title: 'Advanced Filters',
            description: 'Filter by agency, set-aside type, contract value, location, and due date to zero in on your best opportunities.',
          ),
          ToolFeature(
            icon: Icons.notifications_active_rounded,
            title: 'Real-Time Alerts',
            description: 'Receive instant notifications when new solicitations matching your profile are posted on SAM.gov, GovWin, or private portals.',
          ),
          ToolFeature(
            icon: Icons.bar_chart_rounded,
            title: 'Win Probability Score',
            description: 'Each contract receives an AI-calculated win probability score based on your past performance and competitive landscape.',
          ),
        ],
        useCases: [
          'Federal small businesses targeting set-aside contracts',
          'State & local government contractors',
          'Commercial procurement teams monitoring RFPs',
          'Teaming partners seeking prime opportunities',
        ],
      ),
      ToolItem(
        id: 'bid_writer',
        name: 'AI Bid Writer',
        description: 'Generate compliant, compelling bid responses in minutes.',
        icon: Icons.edit_note_rounded,
        accentColor: Color(0xFF8B5CF6),
        tagline: 'Write winning bids in a fraction of the time.',
        features: [
          ToolFeature(
            icon: Icons.auto_awesome_rounded,
            title: 'RFP Analysis',
            description: 'AI reads and interprets the full RFP, identifying key requirements, evaluation criteria, and mandatory elements automatically.',
          ),
          ToolFeature(
            icon: Icons.library_books_rounded,
            title: 'Content Library',
            description: 'Pull from your approved past-performance records, team bios, and corporate qualifications with a single click.',
          ),
          ToolFeature(
            icon: Icons.spellcheck_rounded,
            title: 'Compliance Check',
            description: 'Real-time compliance scanning ensures your response addresses every requirement before you submit.',
          ),
          ToolFeature(
            icon: Icons.tune_rounded,
            title: 'Tone & Style Control',
            description: 'Choose from technical, executive, or narrative tones. AI adapts to match the agency\'s preferred communication style.',
          ),
        ],
        useCases: [
          'Proposal managers handling multiple active bids',
          'Small businesses without dedicated proposal staff',
          'Capture managers compressing bid cycles',
          'Subcontractors writing teaming proposals',
        ],
      ),
      ToolItem(
        id: 'price_estimator',
        name: 'AI Price Estimator',
        description: 'Get data-driven pricing recommendations for competitive bids.',
        icon: Icons.attach_money_rounded,
        accentColor: Color(0xFF10B981),
        tagline: 'Price to win — backed by real market data.',
        features: [
          ToolFeature(
            icon: Icons.insights_rounded,
            title: 'Market Rate Analysis',
            description: 'Benchmarks your pricing against historical award data from FPDS, USASpending, and proprietary databases.',
          ),
          ToolFeature(
            icon: Icons.account_balance_rounded,
            title: 'Labor Rate Builder',
            description: 'Build fully-burdened labor rate structures using BLS wage data and your company\'s fringe and overhead rates.',
          ),
          ToolFeature(
            icon: Icons.compare_arrows_rounded,
            title: 'Should-Cost Modeling',
            description: 'Generate should-cost estimates to understand true contract costs before committing to a price.',
          ),
          ToolFeature(
            icon: Icons.trending_up_rounded,
            title: 'Competitive Positioning',
            description: 'See how your price compares to likely competitor ranges and adjust to maximize both margin and win probability.',
          ),
        ],
        useCases: [
          'Contracts officers validating fair and reasonable pricing',
          'Proposal teams building cost volumes',
          'Program managers tracking cost performance',
          'Businesses entering new contract vehicles',
        ],
      ),
      ToolItem(
        id: 'compliance_tracker',
        name: 'Compliance Tracker',
        description: 'Monitor regulatory requirements and certification deadlines.',
        icon: Icons.verified_user_rounded,
        accentColor: Color(0xFFF59E0B),
        tagline: 'Stay compliant. Stay eligible. Stay in the running.',
        features: [
          ToolFeature(
            icon: Icons.checklist_rounded,
            title: 'Certification Dashboard',
            description: 'Track all your active certifications — 8(a), SDVOSB, WOSB, ISO, CMMC — with expiry dates and renewal workflows.',
          ),
          ToolFeature(
            icon: Icons.policy_rounded,
            title: 'Regulatory Change Alerts',
            description: 'Automatic monitoring of FAR, DFARS, and agency-specific clause changes that affect your contracts.',
          ),
          ToolFeature(
            icon: Icons.assignment_turned_in_rounded,
            title: 'Compliance Task Manager',
            description: 'Generate actionable compliance checklists tailored to each contract\'s specific regulatory requirements.',
          ),
          ToolFeature(
            icon: Icons.security_rounded,
            title: 'CMMC Readiness',
            description: 'Track your Cybersecurity Maturity Model Certification progress with gap analysis and remediation guidance.',
          ),
        ],
        useCases: [
          'DoD contractors managing CMMC compliance',
          'SBA-certified businesses tracking certification renewals',
          'Compliance officers overseeing multi-contract portfolios',
          'Companies pursuing new set-aside certifications',
        ],
      ),
      ToolItem(
        id: 'vendor_matching',
        name: 'Vendor Matching',
        description: 'Find and connect with pre-vetted subcontractors and partners.',
        icon: Icons.handshake_rounded,
        accentColor: Color(0xFF06B6D4),
        tagline: 'Build the perfect team for every opportunity.',
        features: [
          ToolFeature(
            icon: Icons.manage_search_rounded,
            title: 'Capability-Based Search',
            description: 'Search our network of verified vendors by NAICS code, certifications, location, and past performance records.',
          ),
          ToolFeature(
            icon: Icons.verified_rounded,
            title: 'Verified Profiles',
            description: 'Every vendor is verified against SAM.gov registration, ensuring active, eligible partners for your teaming agreements.',
          ),
          ToolFeature(
            icon: Icons.chat_rounded,
            title: 'In-Platform Outreach',
            description: 'Send teaming inquiries, share NDA templates, and track responses without leaving the platform.',
          ),
          ToolFeature(
            icon: Icons.star_rounded,
            title: 'Performance Ratings',
            description: 'Access performance ratings from other primes and subs who have worked with each vendor previously.',
          ),
        ],
        useCases: [
          'Prime contractors fulfilling small business subcontracting plans',
          'Small businesses seeking large-business mentors',
          'Teaming partners assembling joint venture bids',
          'Program managers identifying specialty subcontractors',
        ],
      ),
      ToolItem(
        id: 'proposal_manager',
        name: 'Proposal Manager',
        description: 'Organize, track, and collaborate on proposals end-to-end.',
        icon: Icons.folder_open_rounded,
        accentColor: Color(0xFFEC4899),
        tagline: 'From kickoff to submission — all in one place.',
        features: [
          ToolFeature(
            icon: Icons.account_tree_rounded,
            title: 'Proposal Workspaces',
            description: 'Dedicated workspaces for each opportunity with volume-level organization, file storage, and version tracking.',
          ),
          ToolFeature(
            icon: Icons.group_rounded,
            title: 'Team Collaboration',
            description: 'Assign sections to writers, reviewers, and SMEs. Track contributions and resolve comments in real time.',
          ),
          ToolFeature(
            icon: Icons.schedule_rounded,
            title: 'Milestone Tracking',
            description: 'Set pink team, red team, gold team review milestones with automated reminders for each contributor.',
          ),
          ToolFeature(
            icon: Icons.upload_file_rounded,
            title: 'Submission Packaging',
            description: 'Auto-format and package your final response to meet specific agency submission requirements.',
          ),
        ],
        useCases: [
          'Capture teams managing large IDIQ proposals',
          'Proposal coordinators juggling multiple deadlines',
          'Distributed teams collaborating across time zones',
          'Program managers tracking bid portfolio performance',
        ],
      ),
      ToolItem(
        id: 'crm',
        name: 'CRM',
        description: 'Manage contacts, relationships, and deal pipelines effortlessly.',
        icon: Icons.people_rounded,
        accentColor: Color(0xFF6366F1),
        tagline: 'Your procurement relationships, fully organized.',
        features: [
          ToolFeature(
            icon: Icons.contacts_rounded,
            title: 'Contact Management',
            description: 'Centralize all agency contacts, contracting officers, and procurement leads with full interaction history.',
          ),
          ToolFeature(
            icon: Icons.view_kanban_rounded,
            title: 'Opportunity Pipeline',
            description: 'Visualize your entire bid pipeline from capture through award with drag-and-drop stage management.',
          ),
          ToolFeature(
            icon: Icons.history_rounded,
            title: 'Interaction Logging',
            description: 'Log calls, emails, and meetings automatically, with AI-generated follow-up recommendations.',
          ),
          ToolFeature(
            icon: Icons.analytics_rounded,
            title: 'Win/Loss Analytics',
            description: 'Analyze win and loss patterns to refine your capture strategy and target the right opportunities.',
          ),
        ],
        useCases: [
          'Business development teams managing agency relationships',
          'Capture managers tracking opportunity progression',
          'Executives overseeing the full business development funnel',
          'Companies building long-term agency partnerships',
        ],
      ),
      ToolItem(
        id: 'calendar',
        name: 'Deadline Calendar',
        description: 'Never miss a submission deadline with smart reminders.',
        icon: Icons.calendar_month_rounded,
        accentColor: Color(0xFFEF4444),
        tagline: 'Every deadline. Every reminder. Zero misses.',
        features: [
          ToolFeature(
            icon: Icons.event_available_rounded,
            title: 'Unified Deadline View',
            description: 'See all submission deadlines, Q&A periods, site visits, and award dates in a single procurement calendar.',
          ),
          ToolFeature(
            icon: Icons.alarm_rounded,
            title: 'Smart Reminders',
            description: 'AI automatically creates layered reminders at 30, 14, 7, 3, and 1 days before each critical date.',
          ),
          ToolFeature(
            icon: Icons.sync_rounded,
            title: 'Calendar Sync',
            description: 'Sync deadlines directly to Google Calendar, Outlook, or Apple Calendar so nothing falls through the cracks.',
          ),
          ToolFeature(
            icon: Icons.timeline_rounded,
            title: 'Workback Scheduling',
            description: 'Generate automated workback schedules from submission dates to identify your earliest required start date.',
          ),
        ],
        useCases: [
          'Proposal managers tracking multiple simultaneous deadlines',
          'BD teams planning resource allocation across pursuits',
          'Executives reviewing the forward-looking opportunity pipeline',
          'Compliance officers tracking certification renewal dates',
        ],
      ),
      ToolItem(
        id: 'capability_gen',
        name: 'Capability Statement',
        description: 'Auto-generate professional capability statements from your data.',
        icon: Icons.description_rounded,
        accentColor: Color(0xFF14B8A6),
        tagline: 'A polished capability statement in minutes, not days.',
        features: [
          ToolFeature(
            icon: Icons.auto_fix_high_rounded,
            title: 'AI-Powered Generation',
            description: 'Input your company data once. AI generates a fully-formatted, professional capability statement tailored to any agency or opportunity.',
          ),
          ToolFeature(
            icon: Icons.palette_rounded,
            title: 'Custom Branding',
            description: 'Upload your logo, choose brand colors, and select from professional templates for polished, on-brand output.',
          ),
          ToolFeature(
            icon: Icons.content_copy_rounded,
            title: 'Version Management',
            description: 'Maintain agency-specific and opportunity-specific versions, with a master library of all generated statements.',
          ),
          ToolFeature(
            icon: Icons.picture_as_pdf_rounded,
            title: 'Multi-Format Export',
            description: 'Export as PDF, Word, or PowerPoint to meet any agency\'s submission format requirement.',
          ),
        ],
        useCases: [
          'Small businesses attending industry days and matchmaking events',
          'BD representatives preparing for agency outreach meetings',
          'Contractors responding to sources sought notices',
          'New market entrants establishing their procurement brand',
        ],
      ),
    ];
  }

  List<PricingTier> getPricingTiers() {
    return const [
      PricingTier(
        name: 'Starter',
        price: '\$49',
        period: '/month',
        annualPrice: '\$39',
        ctaLabel: 'Start Free Trial',
        subtitle: 'Perfect for solopreneurs and small teams just getting started.',
        description: 'Get immediate access to core AI tools to start finding and winning contracts faster.',
        features: [
          'AI Contract Finder',
          'AI Bid Writer (5/month)',
          'Deadline Calendar',
          'Capability Statement Generator',
          'Email support',
        ],
      ),
      PricingTier(
        name: 'Professional',
        price: '\$149',
        period: '/month',
        annualPrice: '\$119',
        isPopular: true,
        ctaLabel: 'Start Free Trial',
        subtitle: 'For growing businesses serious about winning more contracts.',
        description: 'Unlock the full AI procurement suite to automate your entire workflow and scale your win rate.',
        badgeColor: Color(0xFF3B82F6),
        features: [
          'Everything in Starter',
          'Unlimited AI Bid Writer',
          'AI Price Estimator',
          'Compliance Tracker',
          'Vendor Matching',
          'Proposal Manager',
          'Priority support',
        ],
      ),
      PricingTier(
        name: 'Enterprise',
        price: '\$399+',
        period: '/month',
        annualPrice: '\$319+',
        ctaLabel: 'Contact Sales',
        subtitle: 'Custom solutions for large teams and complex procurement needs.',
        description: 'Tailored AI training, team collaboration, and dedicated support for organizations with sophisticated procurement requirements.',
        badgeColor: Color(0xFF6366F1),
        features: [
          'Everything in Professional',
          'Full CRM integration',
          'Custom AI training',
          'Team collaboration',
          'Dedicated account manager',
          'SSO & advanced security',
          'API access',
        ],
      ),
    ];
  }
}
