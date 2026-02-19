import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for transparent/floating navbar
      body: navigationShell,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2))),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              indicatorColor: const Color(0xFF00FFAA).withOpacity(0.2), // Neon Teal with opacity
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => _onTap(context, index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined, color: Colors.white),
                  selectedIcon: Icon(Icons.dashboard, color: Color(0xFF00FFAA)),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                  selectedIcon: Icon(Icons.check_circle, color: Color(0xFF00FFAA)),
                  label: 'Track',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined, color: Colors.white),
                  selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF00FFAA)),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.emoji_events_outlined, color: Colors.white),
                  selectedIcon: Icon(Icons.emoji_events, color: Color(0xFF00FFAA)),
                  label: 'Rewards',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
