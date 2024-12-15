import 'package:entebbe_dramp_web/src/views/admin_panel/revenuestreams/transport/addindividualrevenuestream.dart';
import 'package:entebbe_dramp_web/src/views/app_router/scaffold_with_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../admin_panel/dashboard.dart';
import '../admin_panel/enforcement/enforcementdashboard.dart';
import '../admin_panel/finance/financedashboard.dart';
import '../admin_panel/mobility/mobility.dart';
import '../admin_panel/revenuesectors/revenuesectors.dart';
import '../admin_panel/revenuestreams/accommodation/addindividualrensporthospitalityrevenuestream.dart';
import '../admin_panel/revenuestreams/accommodation/addnonindividualhospitalityrevenuestream.dart';
import '../admin_panel/revenuestreams/fisheries/addindividualfishrevenuestream.dart';
import '../admin_panel/revenuestreams/fisheries/addnonindividualfishrevenuestream.dart';
import '../admin_panel/revenuestreams/property/addindividualpropertyrevenuestream.dart';
import '../admin_panel/revenuestreams/property/addnonindividualpropertyrevenuestream.dart';
import '../admin_panel/revenuestreams/revenuestreams.dart';
import '../admin_panel/revenuestreams/transport/addnonindividualrevenuestream.dart';
import '../admin_panel/revenuestreams/transport/test.dart';
import '../admin_panel/revenuesubtype/revenuesubtypes.dart';
import '../admin_panel/settings/settings.dart';
import '../auth/signin.dart';

String? userId;
String defaultRoute = '/sign-in';

void checkLoggedin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getString("userid") ?? "";
  debugPrint("+=+=+=+=+=+=+=+ $userId");
}

final goRouterProvider = Provider<GoRouter>((ref) {
  checkLoggedin();
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: defaultRoute,
    // initialLocation: (userId == "") ? '/sign-in' : '/',

    routes: [
      GoRoute(
          name: 'signin',
          path: '/sign-in',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignInPage());
          }),
      GoRoute(
          name: 'signup',
          path: '/sign-up',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignInPage());
          }),
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
            StatefulShellBranch(routes: [
              // ADD DUMMY LINK BEFORE PARAMETERIZED LINK,
              GoRoute(
                name: 'test3',
                path: '/test3',
                builder: (context, state) => TestPage(
                  testVar: "yes",
                ),
              ),
              GoRoute(
                name: 'addindividualstreamhospitality',
                path:
                    '/addstream-ih/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) =>
                    AddIndividualHospitalityRevenueStreamPage(
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
                name: 'test4',
                path: '/test4',
                builder: (context, state) => TestPage(
                  testVar: "no",
                ),
              ),
              GoRoute(
                name: 'addnonindividualstreamhospitality',
                path:
                    '/addstream-nih/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) =>
                    AddNonIndividualHospitalityRevenueStreamPage(
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
                name: 'test5',
                path: '/test5',
                builder: (context, state) => TestPage(
                  testVar: "yes",
                ),
              ),
              GoRoute(
                name: 'addindividualstreamfisheries',
                path:
                    '/addstream-if/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) => AddIndividualFishRevenueStreamPage(
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
                name: 'test6',
                path: '/test6',
                builder: (context, state) => TestPage(
                  testVar: "no",
                ),
              ),
              GoRoute(
                name: 'addnonindividualstreamfisheries',
                path:
                    '/addstream-nif/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) =>
                    AddNonIndividualFishRevenueStreamPage(
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
                name: 'test7',
                path: '/test7',
                builder: (context, state) => TestPage(
                  testVar: "yes",
                ),
              ),
              GoRoute(
                name: 'addindividualstreamproperty',
                path:
                    '/addstream-ip/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) =>
                    AddIndividualPropertyRevenueStreamPage(
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
                name: 'test8',
                path: '/test8',
                builder: (context, state) => TestPage(
                  testVar: "no",
                ),
              ),
              GoRoute(
                name: 'addnonindividualstreamproperty',
                path:
                    '/addstream-nip/:ownerType/:category/:categoryId/:sector/:sectorId',
                builder: (context, state) =>
                    AddNonIndividualPropertyRevenueStreamPage(
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
