import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard.dart';
import 'finance/financedashboard.dart';
import 'mobility/mobility.dart';
import 'revenuesectors/revenuesectors.dart';
import 'revenuestreams/revenuestreams.dart';
import 'revenuesubtype/revenuesubtypes.dart';
import 'settings/settings.dart';

enum SideBarItem {
  dashboard(
    value: 'Dashboard',
    iconData: Icons.home,
    body: DashboardPage(),
  ),
  // test(
  //   value: '',
  //   iconData: Icons.business,
  //   body: RevenueStreamsPage(),
  // ),
  revenuestreams(
    value: 'Revenue Streams',
    iconData: Icons.business,
    body: RevenueStreamsPage(),
  ),
  sectorcategories(
    value: 'Sector Categories',
    iconData: Icons.group,
    body: SectorSubtypePage(),
  ),
  revenuesectors(
      value: 'Revenue Sectors',
      iconData: Icons.campaign,
      body: DashboardPage()),
  mobility(
      value: 'Mobility Management',
      iconData: Icons.bus_alert,
      body: MobilityPage()),
  finance(
    value: 'Finance',
    iconData: Icons.balance,
    body: FinanceDashboardPage(),
  ),
  enforcement(
    value: 'Enforcement',
    iconData: Icons.policy,
    body: RevenuesectorsPage(),
  ),
  settings(
    value: 'Settings',
    iconData: Icons.settings,
    body: SettingsPage(),
  );
  // dashboard(
  //     value: 'Dashboard', iconData: Icons.dashboard, body: DashboardPage()),
  // units(value: 'Units', iconData: Icons.business, body: UnitsScreen()),
  // tenants(value: 'Tenats', iconData: Icons.group, body: TenantsScreen()),
  // notices(value: 'Notices', iconData: Icons.campaign, body: NoticesScreen()),
  // settings(value: 'Settings', iconData: Icons.settings, body: SettingsScreen());

  const SideBarItem(
      {required this.value, required this.iconData, required this.body});
  final String value;
  final IconData iconData;
  final Widget body;
}

final sideBarItemProvider =
    StateProvider<SideBarItem>((ref) => SideBarItem.dashboard);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  SideBarItem getSideBarItem(AdminMenuItem item) {
    for (var value in SideBarItem.values) {
      if (item.route == value.name) {
        return value;
      }
    }
    return SideBarItem.dashboard;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideBarItem = ref.watch(sideBarItemProvider);
    final sideBarkey = ValueKey(Random().nextInt(1000000));
    const String stringParam = 'String parameter';
    const int intParam = 1000000;
    return AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(''),
          // toolbarHeight: 50,
          // elevation: 8.0,
          actions: [_accountToggle(context)],
        ),
        sideBar: SideBar(
            header: Container(
              height: 60,
            ),
            key: sideBarkey,
            textStyle: TextStyle(
              // color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            activeBackgroundColor: Colors.white,
            activeTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (item) => ref
                .read(sideBarItemProvider.notifier)
                .update((state) => getSideBarItem(item)),
            items: SideBarItem.values
                .map((e) => AdminMenuItem(
                    title: e.value, icon: e.iconData, route: e.name))
                .toList(),
            selectedRoute: sideBarItem.name),
        body: ProviderScope(overrides: [
          paramProvider.overrideWithValue((stringParam, intParam))
        ], child: sideBarItem.body));
  }

  Widget _accountToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.only(right: 12.0),
      child: PopupMenuButton(
        splashRadius: 0.0,
        tooltip: '',
        position: PopupMenuPosition.under,
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage("https://picsum.photos/id/28/50"),
                    radius: 20.0,
                  ),
                  SizedBox(width: 16 * 0.5),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin User"),
                      Text("admin@email.com"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.logout),
                Text("Sign Out"),
              ],
            ),
          ),
        ],
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("https://picsum.photos/id/28/50"),
              radius: 16.0,
            ),
            SizedBox(width: 16 * 0.5),
            const Text(
              'Hi, Admin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final paramProvider = Provider<(String, int)>((ref) {
  throw UnimplementedError();
});
