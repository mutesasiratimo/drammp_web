import 'package:entebbe_dramp_web/config/constants.dart';
import 'package:entebbe_dramp_web/home/settings/entityassociates.dart';
import 'package:entebbe_dramp_web/home/settings/operators.dart';
import 'package:entebbe_dramp_web/home/settings/tarrifs.dart';
import 'package:entebbe_dramp_web/home/settings/travelcards.dart';
import 'package:entebbe_dramp_web/home/settings/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import '../../config/base.dart';
import '../appbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends Base<SettingsPage> {
  String selectedInterval = "Today";
  late TabController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
      setState(() {
        selectedIndex = _controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomAppBar(
                    title: "System Configurations",
                    backgroundColor: Colors.white,
                    actions: [
                      _accountToggle(context),
                    ],
                  ),
                ),
              ],
            ),
            BootstrapContainer(
              fluid: true,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
              ),
              padding: const EdgeInsets.only(top: 0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.white,
                    child: SizedBox(
                      height: size.height * .85,
                      child: Column(
                        children: [
                          TabBar(
                            unselectedLabelColor: Colors.grey[700],
                            labelColor: AppConstants.primaryColor,
                            indicatorColor: AppConstants.primaryColor,
                            tabs: [
                              Tab(
                                text: "System Users",
                              ),
                              Tab(
                                text: "Operators/Drivers",
                              ),
                              Tab(
                                text: "Entity Associates",
                              ),
                              Tab(
                                text: "Tarrifs",
                              ),
                              Tab(
                                text: "Travel Cards",
                              ),
                            ],
                            controller: _controller,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _controller,
                              children: [
                                UsersPage(),
                                OperatorsPage(),
                                AssociatesPage(),
                                TarrifsPage(),
                                TravelCardsPage()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                  SizedBox(width: kDefaultPadding * 0.5),
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
            SizedBox(width: kDefaultPadding * 0.5),
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
