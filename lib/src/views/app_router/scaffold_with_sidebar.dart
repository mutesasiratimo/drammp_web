import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum SidebarItem {
  dashboard(value: 'Dashboard', iconData: Icons.home),
  revenuestreams(value: 'Revenue Streams', iconData: Icons.business),
  sectorcategories(value: 'Sector Categories', iconData: Icons.group),
  revenuesectors(value: 'Revenue Sectors', iconData: Icons.campaign),
  mobility(value: 'Mobility Management', iconData: Icons.bus_alert),
  finance(value: 'Finance', iconData: Icons.balance),
  enforcement(value: 'Enforcement', iconData: Icons.policy),
  settings(value: 'Settings', iconData: Icons.settings);

  const SidebarItem({required this.value, required this.iconData});
  final String value;
  final IconData iconData;
}

final selectedRouteProvider = StateProvider<String>((ref) {
  return SidebarItem.dashboard.name;
});

class ScaffoldWithSideBar extends ConsumerWidget {
  const ScaffoldWithSideBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  SidebarItem getSideBarItem(AdminMenuItem item) {
    for (var value in SidebarItem.values) {
      if (item.route == value.name) {
        return value;
      }
    }
    return SidebarItem.dashboard;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoute = ref.watch(selectedRouteProvider);
    final sideBarkey = ValueKey(Random().nextInt(1000000));
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // foregroundColor: Colors.white,
        title: const Text(''),
        // toolbarHeight: 50,
        // elevation: 8.0,
        // backgroundColor: Colors.white,
        actions: [_accountToggle(context)],
      ),
      body: navigationShell,
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
          activeTextStyle: TextStyle(
            color: Colors.indigo.shade900,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: Colors.white,
          activeBackgroundColor: Colors.indigo.shade200,
          onSelected: (item) {
            final index = getSideBarItem(item).index;
            ref
                .read(selectedRouteProvider.notifier)
                .update((state) => item.route ?? '');

            navigationShell.goBranch(
              index,
              // A common pattern when using bottom navigation bars is to support
              // navigating to the initial location when tapping the item that is
              // already active. This example demonstrates how to support this behavior,
              // using the initialLocation parameter of goBranch.
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          items: SidebarItem.values
              .map((e) => AdminMenuItem(
                  title: e.value, icon: e.iconData, route: e.name))
              .toList(),
          selectedRoute: selectedRoute),
    );
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
            // onTap: ,
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
