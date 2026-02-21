import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/presentation/widgets/tactile_background.dart';

/// Frosted-glass bottom navigation with TactileBackground — Neo Tactile style.
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : null,
      body: TactileBackground(child: navigationShell),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurface.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.8),
              border: Border(
                  top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
              )),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 64,
              indicatorColor:
                  AppTheme.accent.withValues(alpha: isDark ? 0.08 : 0.06),
              indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (i) => navigationShell.goBranch(i,
                  initialLocation: i == navigationShell.currentIndex),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded,
                        color:
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                        size: 22),
                    selectedIcon: Icon(Icons.grid_view_rounded,
                        color: AppTheme.accent, size: 22),
                    label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.check_circle_outline_rounded,
                        color:
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                        size: 22),
                    selectedIcon: Icon(Icons.check_circle_rounded,
                        color: AppTheme.accent, size: 22),
                    label: 'Track'),
                NavigationDestination(
                    icon: Icon(Icons.bar_chart_rounded,
                        color:
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                        size: 22),
                    selectedIcon: Icon(Icons.bar_chart_rounded,
                        color: AppTheme.accent, size: 22),
                    label: 'Reports'),
                NavigationDestination(
                    icon: Icon(Icons.star_outline_rounded,
                        color:
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                        size: 22),
                    selectedIcon: Icon(Icons.star_rounded,
                        color: AppTheme.accent, size: 22),
                    label: 'Rewards'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
