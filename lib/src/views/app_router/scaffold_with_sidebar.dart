import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constants.dart';
import '../../../provider/app_preferences_provider.dart';
import '../../../provider/user_data_provider.dart';

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
    final themeData = Theme.of(context);
    final selectedRoute = ref.watch(selectedRouteProvider);
    final sideBarkey = ValueKey(Random().nextInt(1000000));
    return AdminScaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // foregroundColor: Colors.white,
        title: const Text(''),
        // toolbarHeight: 50,
        // elevation: 8.0,
        // backgroundColor: Colors.white,
        actions: [
          _toggleThemeButton(context),
          SizedBox(width: kDefaultPadding),
          _accountToggle(context)
        ],
      ),
      body: navigationShell,
      sideBar: SideBar(
          header: Container(
              // height: 60,
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
          backgroundColor: themeData.appBarTheme.backgroundColor!,
          // backgroundColor: Colors.white,
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

  Widget _toggleThemeButton(BuildContext context) {
    final themeData = Theme.of(context);
    final isFullWidthButton =
        (MediaQuery.of(context).size.width > kScreenWidthMd);

    return SizedBox(
      width: (isFullWidthButton ? null : 48.0),
      child: TextButton(
        onPressed: () async {
          final provider = context.read<AppPreferencesProvider>();
          final currentThemeMode = provider.themeMode;
          final themeMode = (currentThemeMode != ThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light);

          provider.setThemeModeAsync(themeMode: themeMode);
        },
        style: TextButton.styleFrom(
          foregroundColor: themeData.colorScheme.onPrimary,
          disabledForegroundColor: AppConstants.primaryColor.withOpacity(0.38),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Selector<AppPreferencesProvider, ThemeMode>(
          selector: (context, provider) => provider.themeMode,
          builder: (context, value, child) {
            var icon = Icons.dark_mode_rounded;
            var text = "Dark";

            if (value == ThemeMode.dark) {
              icon = Icons.light_mode_rounded;
              text = "Light";
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                ),
                Visibility(
                  // visible: false,
                  visible: isFullWidthButton,
                  child: Padding(
                    padding: const EdgeInsets.only(left: kDefaultPadding * 0.5),
                    child: Text(text),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _accountToggle(BuildContext context) {
    final goRouter = GoRouter.of(context);
    //Logout Function
    clearPrefs() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      goRouter.go("/sign-in");
    }

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
                  Selector<UserDataProvider, String>(
                    selector: (context, provider) =>
                        provider.userProfileImageUrl,
                    builder: (context, value, child) {
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(value),
                        radius: 20.0,
                      );
                    },
                  ),
                  SizedBox(width: 16 * 0.5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Selector<UserDataProvider, String>(
                        selector: (context, provider) => provider.fullname,
                        builder: (context, value, child) {
                          return Text("$value");
                        },
                      ),
                      Selector<UserDataProvider, String>(
                        selector: (context, provider) => provider.email,
                        builder: (context, value, child) {
                          return Text(
                            "$value",
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(
            onTap: () {
              clearPrefs();
            },
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
            Selector<UserDataProvider, String>(
              selector: (context, provider) => provider.userProfileImageUrl,
              builder: (context, value, child) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(value),
                  radius: 16.0,
                );
              },
            ),
            SizedBox(width: 16 * 0.5),
            Selector<UserDataProvider, String>(
              selector: (context, provider) => provider.username,
              builder: (context, value, child) {
                return Text("Hi $value");
              },
            ),
          ],
        ),
      ),
    );
  }
}
