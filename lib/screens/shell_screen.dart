import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';

class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      body: navigationShell,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.tertiary],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'nex_fab',
          onPressed: () => context.push('/nex'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: colors.onPrimary,
            size: AppTheme.iconMd,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(index),
          backgroundColor: colors.surface,
          indicatorColor: colors.primary.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: appColors.subtleText),
              selectedIcon: Icon(Icons.dashboard_rounded, color: colors.primary),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_offer_outlined, color: appColors.subtleText),
              selectedIcon: Icon(Icons.local_offer_rounded, color: colors.primary),
              label: 'Pricing',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: appColors.subtleText),
              selectedIcon: Icon(Icons.search_rounded, color: colors.primary),
              label: 'Contracts',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: appColors.subtleText),
              selectedIcon: Icon(Icons.person_rounded, color: colors.primary),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
