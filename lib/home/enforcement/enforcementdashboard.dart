import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import '../../config/base.dart';
import '../appbar.dart';

class EnforcementDashboardPage extends StatefulWidget {
  const EnforcementDashboardPage({super.key});

  @override
  State<EnforcementDashboardPage> createState() =>
      _EnforcementDashboardPageState();
}

class _EnforcementDashboardPageState extends Base<EnforcementDashboardPage> {
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
                    title: "Enforcement and Collections",
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
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Payment/Subscription Statistics",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: Card(
                                child: SizedBox(
                                  height: size.height * .15,
                                  child: Container(
                                    margin: EdgeInsets.all(0.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        color: Colors.green.shade50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 32,
                                          color: Colors.green.shade900,
                                        ),
                                        SizedBox(width: 18),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "225",
                                              style: TextStyle(
                                                color: Colors.green.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Compliant.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: Card(
                                child: SizedBox(
                                  height: size.height * .15,
                                  child: Container(
                                    margin: EdgeInsets.all(0.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        color: Colors.red.shade50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.cancel_outlined,
                                          size: 32,
                                          color: Colors.red.shade900,
                                        ),
                                        SizedBox(width: 18),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "322",
                                              style: TextStyle(
                                                color: Colors.red.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Past 60 Days \nOverdue",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: Card(
                                child: SizedBox(
                                  height: size.height * .15,
                                  child: Container(
                                    margin: EdgeInsets.all(0.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        color: Colors.amber.shade50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.warning,
                                          size: 32,
                                          color: Colors.amber.shade900,
                                        ),
                                        SizedBox(width: 18),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "245",
                                              style: TextStyle(
                                                color: Colors.amber.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Past 30 Days \nOverdue.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: Card(
                                child: SizedBox(
                                  height: size.height * .15,
                                  child: Container(
                                    margin: EdgeInsets.all(0.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        color: Colors.blue.shade50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.info_outline,
                                          size: 32,
                                          color: Colors.blue.shade900,
                                        ),
                                        SizedBox(width: 18),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "812",
                                              style: TextStyle(
                                                color: Colors.blue.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Under 30 Days \nOverdue.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: "col-lg-8 col-md-12 col-sm-12",
                              child: SizedBox(
                                height: size.height * .7,
                              ),
                            ),
                            BootstrapCol(
                              sizes: "col-lg-4 col-md-12 col-sm-12",
                              child: SizedBox(
                                height: size.height * .7,
                              ),
                            ),
                          ],
                        ),
                      ],
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
