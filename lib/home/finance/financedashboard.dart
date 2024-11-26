import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import '../../config/base.dart';
import '../appbar.dart';

class FinanceDashboardPage extends StatefulWidget {
  const FinanceDashboardPage({super.key});

  @override
  State<FinanceDashboardPage> createState() => _FinanceDashboardPageState();
}

class _FinanceDashboardPageState extends Base<FinanceDashboardPage> {
  String selectedInterval = "Today";
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
                    title: "Finance and Monetary Evaluation",
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
                    child: BootstrapRow(
                      children: <BootstrapCol>[
                        BootstrapCol(
                          sizes: "col-lg-8 col-md-12 col-sm-12",
                          child: SizedBox(
                            height: size.height * .8,
                            child: Container(
                              padding: EdgeInsets.all(24.0),
                              margin: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                gradient: LinearGradient(
                                    colors: [
                                      const Color.fromRGBO(54, 41, 183, 1),
                                      const Color.fromRGBO(54, 41, 183, 100),
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Subscription Overview",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ))
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FilterChip(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade200,
                                      label: Text(
                                        "Annual",
                                        style: TextStyle(
                                            color: selectedInterval == "Annual"
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      selected: selectedInterval == "Annual",
                                      onSelected: (bool value) {
                                        setState(() {
                                          selectedInterval = "Annual";
                                        });
                                      },
                                    ),
                                    FilterChip(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade200,
                                      label: Text(
                                        "Quarterly",
                                        style: TextStyle(
                                            color:
                                                selectedInterval == "Quarterly"
                                                    ? Colors.black
                                                    : Colors.white),
                                      ),
                                      selected: selectedInterval == "Quarterly",
                                      onSelected: (bool value) {
                                        setState(() {
                                          selectedInterval = "Quarterly";
                                        });
                                      },
                                    ),
                                    FilterChip(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade200,
                                      label: Text(
                                        "Monthly",
                                        style: TextStyle(
                                            color: selectedInterval == "Monthly"
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      selected: selectedInterval == "Monthly",
                                      onSelected: (bool value) {
                                        setState(() {
                                          selectedInterval = "Monthly";
                                        });
                                      },
                                    ),
                                    FilterChip(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade200,
                                      label: Text(
                                        "Weekly",
                                        style: TextStyle(
                                            color: selectedInterval == "Weekly"
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      selected: selectedInterval == "Weekly",
                                      onSelected: (bool value) {
                                        setState(() {
                                          selectedInterval = "Weekly";
                                        });
                                      },
                                    ),
                                    FilterChip(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade200,
                                      showCheckmark: true,
                                      label: Text(
                                        "Today",
                                        style: TextStyle(
                                            color: selectedInterval == "Today"
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      selected: selectedInterval == "Today",
                                      onSelected: (bool value) {
                                        setState(() {
                                          selectedInterval = "Today";
                                        });
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: 24,
                                        ))
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          sizes: "col-lg-4 col-md-12 col-sm-12",
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * .2,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color.fromRGBO(
                                              212, 252, 121, 100),
                                          const Color.fromRGBO(
                                              212, 252, 121, 72),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * .2,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color.fromRGBO(
                                              0, 242, 252, 100),
                                          const Color.fromRGBO(0, 242, 252, 72),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * .2,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(254, 225, 64, 100),
                                          const Color.fromRGBO(
                                              254, 225, 64, 72),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * .2,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color.fromRGBO(
                                              243, 126, 0, 100),
                                          const Color.fromRGBO(243, 126, 0, 72),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
