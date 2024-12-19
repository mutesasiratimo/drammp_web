import 'package:entebbe_dramp_web/src/views/admin_panel/settings/fares.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import 'entityassociates.dart';
import 'operators.dart';
import 'tarrifs.dart';
import 'travelcards.dart';
import 'users.dart';

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
    _controller = TabController(length: 6, vsync: this);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BootstrapContainer(
              fluid: true,
              padding: const EdgeInsets.only(top: 0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: Card(
                    // color: Colors.white,
                    child: SizedBox(
                      height: size.height * .85,
                      child: Column(
                        children: [
                          TabBar(
                            labelStyle: TextStyle(fontWeight: FontWeight.w600),
                            // unselectedLabelColor: Colors.grey[700],
                            labelColor: Colors.grey.shade500,
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
                                text: "Tarrifs/Charges",
                              ),
                              Tab(
                                text: "Trip Fares",
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
                                FaresPage(),
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
}
