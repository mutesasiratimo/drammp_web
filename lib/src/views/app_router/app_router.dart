import 'package:entebbe_dramp_web/src/views/admin_panel/revenuestreams/transport/addindividualrevenuestream.dart';
import 'package:entebbe_dramp_web/src/views/app_router/scaffold_with_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../admin_panel/dashboard.dart';
import '../admin_panel/enforcement/enforcementdashboard.dart';
import '../admin_panel/finance/financedashboard.dart';
import '../admin_panel/mobility/mobility.dart';
import '../admin_panel/revenuesectors/revenuesectors.dart';
import '../admin_panel/revenuestreams/revenuestreams.dart';
import '../admin_panel/revenuestreams/transport/addnonindividualrevenuestream.dart';
import '../admin_panel/revenuestreams/transport/test.dart';
import '../admin_panel/revenuesubtype/revenuesubtypes.dart';
import '../admin_panel/settings/settings.dart';
import '../auth/signin.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/sign-in',
    routes: [
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return ScaffoldWithSideBar(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'root',
                  path: '/',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: DashboardPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'revenuestreams',
                  path: '/revenuestreams',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: RevenueStreamsPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'sectorcategories',
                  path: '/sectorcategories',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: SectorSubtypePage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'sectors',
                  path: '/sectors',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: RevenuesectorsPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'mobility',
                  path: '/mobility',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: MobilityPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'finance',
                  path: '/finance',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: FinanceDashboardPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'enforcement',
                  path: '/enforcement',
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: EnforcementDashboardPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'settings',
                  path: '/settings',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: SettingsPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'signin',
                  path: '/sign-in',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: SignInPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: 'signup',
                  path: '/sign-up',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: SignInPage());
                  }),
            ]),
            StatefulShellBranch(routes: [
              // ADD DUMMY LINK BEFORE PARAMETERIZED LINK,
              GoRoute(
                name: 'test',
                path: '/test',
                builder: (context, state) => TestPage(
                  testVar: "yes",
                ),
              ),
              GoRoute(
                name: 'addindividualstreamtransport',
                path:
                    '/addstream-it/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) => AddIndividualRevenueStreamPage(
                  category: "${state.pathParameters['category']}",
                  ownerType: "${state.pathParameters['ownerType']}",
                  categoryId: "${state.pathParameters['categoryId']}",
                  sector: "${state.pathParameters['sector']}",
                  sectorId: "${state.pathParameters['sectorId']}",
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              // ADD DUMMY LINK BEFORE PARAMETERIZED LINK,
              GoRoute(
                name: 'test2',
                path: '/test2',
                builder: (context, state) => TestPage(
                  testVar: "no",
                ),
              ),
              GoRoute(
                name: 'addnonindividualstreamtransport',
                path:
                    '/addstream-nit/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) => AddNonIndividualRevenueStreamPage(
                  category: "${state.pathParameters['category']}",
                  ownerType: "${state.pathParameters['ownerType']}",
                  categoryId: "${state.pathParameters['categoryId']}",
                  sector: "${state.pathParameters['sector']}",
                  sectorId: "${state.pathParameters['sectorId']}",
                ),
              ),
            ]),
          ]),
    ],
  );
});
