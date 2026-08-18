import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/contracts_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/pricing_provider.dart';
import '../screens/account_screen.dart';
import '../screens/billing_screen.dart';
import '../screens/contracts_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/help_screen.dart';
import '../screens/integrations_screen.dart';
import '../screens/legal_screen.dart';
import '../screens/login_screen.dart';
import '../screens/nex_chat_screen.dart';
import '../screens/notifications_screen.dart';
import '../providers/nex_provider.dart';
import '../screens/pricing_detail_screen.dart';
import '../screens/pricing_screen.dart';
import '../screens/security_screen.dart';
import '../screens/shell_screen.dart';
import '../screens/team_screen.dart';
import '../screens/tool_detail_screen.dart';
import '../screens/tools/bid_writer_screen.dart';
import '../screens/tools/capability_statement_screen.dart';
import '../screens/tools/compliance_tracker_screen.dart';
import '../screens/tools/contract_finder_screen.dart';
import '../screens/tools/crm_screen.dart';
import '../screens/tools/deadline_calendar_screen.dart';
import '../screens/tools/price_estimator_screen.dart';
import '../screens/tools/proposal_manager_screen.dart';
import '../screens/tools/vendor_matching_screen.dart';
import '../services/procurement_service.dart';
import '../services/supabase_service.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isOnLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/tool/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final service = context.read<ProcurementService>();
          final tool = service.getTools().firstWhere(
            (t) => t.id == id,
            orElse: () => service.getTools().first,
          );
          return ToolDetailScreen(tool: tool);
        },
      ),
      GoRoute(
        path: '/tool/:id/workspace',
        builder: (context, state) {
          switch (state.pathParameters['id']) {
            case 'contract_finder':
              return const ContractFinderScreen();
            case 'bid_writer':
              return const BidWriterScreen();
            case 'price_estimator':
              return const PriceEstimatorScreen();
            case 'compliance_tracker':
              return const ComplianceTrackerScreen();
            case 'vendor_matching':
              return const VendorMatchingScreen();
            case 'proposal_manager':
              return const ProposalManagerScreen();
            case 'crm':
              return const CrmScreen();
            case 'calendar':
              return const DeadlineCalendarScreen();
            case 'capability_gen':
              return const CapabilityStatementScreen();
            default:
              return const ContractFinderScreen();
          }
        },
      ),
      GoRoute(
        path: '/plan/:name',
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          final service = context.read<ProcurementService>();
          final tier = service.getPricingTiers().firstWhere(
            (t) => t.name.toLowerCase() == name.toLowerCase(),
            orElse: () => service.getPricingTiers().first,
          );
          return PricingDetailScreen(tier: tier);
        },
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const LegalScreen(initialTab: LegalTab.privacy),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const LegalScreen(initialTab: LegalTab.terms),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/security',
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: '/billing',
        builder: (context, state) => const BillingScreen(),
      ),
      GoRoute(
        path: '/team',
        builder: (context, state) => const TeamScreen(),
      ),
      GoRoute(
        path: '/integrations',
        builder: (context, state) => const IntegrationsScreen(),
      ),
      GoRoute(
        path: '/nex',
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) => NexProvider(supabaseService: ctx.read<SupabaseService>()),
          child: const NexChatScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) {
                  final service = context.read<ProcurementService>();
                  return ChangeNotifierProvider(
                    create: (_) => DashboardProvider(service: service)..loadDashboard(),
                    child: const DashboardScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pricing',
                builder: (context, state) {
                  final service = context.read<ProcurementService>();
                  return ChangeNotifierProvider(
                    create: (_) => PricingProvider(service: service)..loadTiers(),
                    child: const PricingScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contracts',
                builder: (context, state) => ChangeNotifierProvider(
                  create: (_) => ContractsProvider(),
                  child: const ContractsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
