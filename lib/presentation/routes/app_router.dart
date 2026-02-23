import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forgeflow/presentation/screens/build/build_screen.dart';
import 'package:forgeflow/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:forgeflow/presentation/screens/track/track_screen.dart';
import 'package:forgeflow/presentation/screens/reports/reports_screen.dart';
import 'package:forgeflow/presentation/screens/rewards/rewards_screen.dart';
import 'package:forgeflow/presentation/widgets/scaffold_with_navbar.dart';
import 'package:forgeflow/presentation/screens/detox/detox_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellDashboard');
final _shellNavigatorTrackKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTrack');
final _shellNavigatorReportsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellReports');
final _shellNavigatorRewardsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellRewards');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const DashboardScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTrackKey,
            routes: [
              GoRoute(
                path: '/track',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const TrackScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorReportsKey,
            routes: [
              GoRoute(
                path: '/reports',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ReportsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorRewardsKey,
            routes: [
              GoRoute(
                path: '/rewards',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const RewardsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/build',
        parentNavigatorKey: _rootNavigatorKey, // Full screen
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const BuildRoutineScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/detox',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DetoxScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
});
