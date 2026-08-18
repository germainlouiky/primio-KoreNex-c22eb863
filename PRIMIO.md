# KoreNex

## Overview
KoreNex is an AI-powered procurement suite for businesses automating contract discovery, bid writing, pricing, compliance, vendor management, and proposal workflows. B2B SaaS with three pricing tiers (Starter $49, Professional $149, Enterprise $399+/month). Frontend-only — requires backend integration for real functionality.

## Tech Stack & Key Decisions
- Dark theme chosen to convey modern tech sophistication appropriate for B2B AI tooling
- go_router with StatefulShellRoute for bottom navigation — preserves tab state across switches
- Route-scoped providers for dashboard and pricing screens — each tab gets its own provider lifecycle
- ProcurementService holds tool/tier definitions — single source of truth for all product data
- Supabase backend for auth (email/password sign up, sign in, password reset, password update) and Nex chat persistence

## Architecture
- UI → providers → services → models flow; SupabaseService wraps all Supabase client calls
- AuthProvider is global (main.dart MultiProvider) — listens to Supabase auth state changes
- Dashboard and Pricing each get route-scoped ChangeNotifierProviders created in router
- GoRouter redirect guard: unauthenticated users → /login, authenticated users on /login → /dashboard
- Shell screen manages bottom navigation with 4 tabs: Dashboard, Pricing, Contracts, Account
- Nex AI assistant is route-scoped at `/nex` with its own NexProvider — opened via gradient FAB on shell screen

## Conventions
- All tool definitions (names, icons, colors, descriptions, features, useCases, tagline) centralized in ProcurementService
- Pricing tiers also in ProcurementService — subtitle, description, annualPrice, badgeColor are all defined there
- Screen-specific widgets in `widgets/<screen_name>/`, shared widgets in `widgets/common/`
- New tools added by extending the tools list in ProcurementService; route `/tool/:id` resolves by ToolItem.id
- New pricing tiers resolved at `/plan/:name` by tier.name.toLowerCase()
- ContractsScreen replaces the placeholder — full search, filter, saved, and alerts tabs via ContractsProvider
- ContractDetailSheet uses DraggableScrollableSheet for a modal contract detail view with Write Bid CTA
- Nex AI assistant widgets live in `widgets/nex/` — message bubble, typing indicator, input bar, suggested prompts
- NexProvider uses keyword matching for responses — replace _generateResponse with real AI API when ready
- NexProvider accepts optional SupabaseService; loads chat history on init, persists messages to `chat_messages` table
- Supabase credentials are in main.dart Supabase.initialize(); URL and anon key are hardcoded (move to env vars for production)

## Key Patterns & Gotchas
- Login uses real Supabase auth; sign-up shows email confirmation message; sign-in navigates via context.go('/dashboard')
- Account screen reads user email from AuthProvider; sign out calls auth.signOut() then navigates to /login
- StatefulShellRoute preserves each tab's scroll position and state independently
- Tool accent colors are defined in the model (ToolItem.accentColor) — drives hero gradient, icon bg, feature icon color, and CTA button color on detail screen
- PricingTier.isPopular flag drives visual emphasis; PricingTier.badgeColor overrides accent color on detail screen
- Tool detail and plan detail use context.push() (not go()) — preserves back navigation from shell tabs
- PricingCard wraps in Material + InkWell so the whole card is tappable; the button's onPressed and card's onTap are both wired to the same onSelect callback
- Account screen is a standalone StatelessWidget with mock data — requires backend for real profile/usage

## Design System
- Dark theme with blue (#3B82F6) primary — conveys tech sophistication and trust for B2B audience
- Inter font throughout for maximum readability on data-dense screens
- Cards use subtle borders over elevation — lighter visual weight suits the dark background
- Each tool has a unique accent color for quick visual identification across the grid
- 8px spacing grid (spacingXs=4, spacingSm=8, spacingMd=16, spacingLg=24, spacingXl=32)
