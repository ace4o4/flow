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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          border: Border(
              top: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          )),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Home',
                  isSelected: navigationShell.currentIndex == 0,
                  onTap: () => _goBranch(0),
                  isDark: isDark,
                ),
                _NavBarItem(
                  icon: Icons.check_circle_outline_rounded,
                  activeIcon: Icons.check_circle_rounded,
                  label: 'Track',
                  isSelected: navigationShell.currentIndex == 1,
                  onTap: () => _goBranch(1),
                  isDark: isDark,
                ),
                _NavBarItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reports',
                  isSelected: navigationShell.currentIndex == 2,
                  onTap: () => _goBranch(2),
                  isDark: isDark,
                ),
                _NavBarItem(
                  icon: Icons.star_outline_rounded,
                  activeIcon: Icons.star_rounded,
                  label: 'Rewards',
                  isSelected: navigationShell.currentIndex == 3,
                  onTap: () => _goBranch(3),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? AppTheme.neoCard(isDark: isDark, radius: 16)
            : BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? (activeIcon ?? icon) : icon,
              color: isSelected
                  ? AppTheme.accent
                  : (isDark ? AppTheme.darkText3 : AppTheme.lightText3),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : AppTheme.lightText1)
                    : (isDark ? AppTheme.darkText3 : AppTheme.lightText3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
