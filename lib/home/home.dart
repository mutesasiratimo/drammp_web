import 'dart:async';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:entebbe_dramp_web/config/base.dart';
import 'package:entebbe_dramp_web/config/constants.dart';
import 'package:entebbe_dramp_web/home/appbar.dart';
import 'package:entebbe_dramp_web/home/dashboard.dart';
import 'package:entebbe_dramp_web/home/revenuesectors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

// import '../config/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends Base<HomePage> {
  var today = DateTime.now();
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  String salutation = "";
  WeatherFactory wf = WeatherFactory(AppConstants.weatherApiKey);
  Weather? weather;
  Timer? timer;
  final dateFormat = new DateFormat('dd-MM-yyyy');

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    salutation = greeting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    // final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              // showTooltip: false,
              compactSideMenuWidth: 70,
              openSideMenuWidth: 300,
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              backgroundColor: Colors.white,
              hoverColor: Colors.purple.shade100,
              selectedHoverColor: Colors.purple.shade100,
              selectedColor: Colors.purple.shade200,
              selectedTitleTextStyle: const TextStyle(color: Colors.black),
              selectedIconColor: AppConstants.primaryColor,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.grey[200]
            ),
            title: const SizedBox(
              height: 30,
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Powered by Spesho',
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/images/spesho.png"))
                    ],
                  ),
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
                badgeContent: const Text(
                  '3',
                  style: TextStyle(color: Colors.white),
                ),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                title: 'Revenue Streams',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.star_half_outlined),
                // badgeContent: const Text(
                //   '3',
                //   style: TextStyle(color: Colors.white),
                // ),
                tooltipContent: "Revenue Streams",
              ),
              SideMenuItem(
                title: 'Revenue Sectors',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.folder_copy_outlined),
                // badgeContent: const Text(
                //   '3',
                //   style: TextStyle(color: Colors.white),
                // ),
                tooltipContent: "Revenue generating industries",
              ),

              SideMenuExpansionItem(
                title: "Sectors",
                icon: const Icon(Icons.kitchen),
                children: [
                  SideMenuItem(
                    title: 'Transport',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.home),
                    // badgeContent: const Text(
                    //   '3',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    tooltipContent: "Transport Sector",
                  ),
                  SideMenuItem(
                    title: 'Hospitality',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.supervisor_account),
                  ),
                  SideMenuItem(
                    title: 'Trade & Commerce',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.home),
                    tooltipContent: "Trade & Commerce Sector",
                  ),
                  SideMenuItem(
                    title: 'Fisheries',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.supervisor_account),
                  )
                ],
              ),
              SideMenuItem(
                title: 'Finance',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.balance),
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),
              ),
              SideMenuItem(
                title: 'Enforcement',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                badgeContent: const Text(
                  '8',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.local_police_outlined),
              ),
              //Divider
              SideMenuItem(
                builder: (context, displayMode) {
                  return const Divider(
                    endIndent: 8,
                    indent: 8,
                  );
                },
              ),
              SideMenuItem(
                title: 'Settings',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.settings),
              ),
              // SideMenuItem(
              //   onTap:(index, _){
              //     sideMenu.changePage(index);
              //   },
              //   icon: const Icon(Icons.image_rounded),
              // ),
              // SideMenuItem(
              //   title: 'Only Title',
              //   onTap:(index, _){
              //     sideMenu.changePage(index);
              //   },
              // ),
              // SideMenuItem(
              //   title: 'Exit',
              //   onTap: (index, _) {
              //     clearPrefs();
              //     pushAndRemoveUntil(SignInPage());
              //   },
              //   icon: Icon(Icons.exit_to_app),
              // ),
            ],
          ),
          const VerticalDivider(
            width: 0.4,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              scrollBehavior: const ScrollBehavior(),
              allowImplicitScrolling: false,
              children: [
                //Page 1
                const DashboardPage(),
                //Page 2
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Revenue Streams",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 3
                RevenuesectorsPage(),
                //Page 4
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Transport",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 5
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Hospitality",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 6
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Trade and Commerce",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 7
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Fisheries",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 8
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Finance and Monetary Evaluation",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 9
                Container(
                  color: Colors.purple.shade50,
                  // padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Collections and Enforcement",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Page 10
                Container(
                  color: Colors.purple.shade50,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppBar(
                                title: "Configure System",
                                backgroundColor: Colors.white,
                                actions: [
                                  accountToggle(context),
                                ],
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
          ),
        ],
      ),
    );
  }

  Widget accountToggle(BuildContext context) {
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
