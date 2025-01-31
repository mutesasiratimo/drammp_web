// ignore_for_file: unused_local_variable

import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:entebbe_dramp_web/config/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../config/constants.dart';
import '../../../config/functions.dart';
import '../../../models/revenuestreamspaginated.dart';
import '../../../provider/app_preferences_provider.dart';
import '../../../provider/user_data_provider.dart';

class MyPortalPage extends StatefulWidget {
  const MyPortalPage({super.key});

  @override
  State<MyPortalPage> createState() => _MyPortalPageState();
}

class _MyPortalPageState extends Base<MyPortalPage> {
  late TabController _controller;
  int selectedIndex = 0;
  String userId = "";
  late ScrollController scrollController;
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  int rows = 10;
  Duration? executionTime;
  int _streamsPage = 1;
  int _streamsRowCount = 20;
  Future<List<RevenueStreams>>? _streams;
  bool responseLoading = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController revenueStreamController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  Future<List<RevenueStreams>> getStreams() async {
    List<RevenueStreams> returnValue = [];
    String userId = "";

    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;
    userId = prefs.getString("userid") ?? "";

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var url = Uri.parse(AppConstants.baseUrl +
        "revenuestreams/owner/default/$userId?page=$_streamsPage&size=$_streamsRowCount");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      RevenueStreamsPaginatedModel incidentsmodel =
          RevenueStreamsPaginatedModel.fromJson(items);

      returnValue = incidentsmodel.items;

      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  makePayment(
    String streamid,
    String userid,
    String paymentmethod,
    double amount,
    String streamname,
    DateTime nextrenewaldate,
  ) async {
    var url = Uri.parse(AppConstants.baseUrl + "revenuestreams/payment/tarrif");
    // bool responseStatus = false;
    // String _authToken = "";
    // debugPrint("++++++" + "LOGIN FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      FocusScope.of(context).unfocus();
      responseLoading = true;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var bodyString = {
          "id": "$streamid",
          "userid": "$userid",
          "paymentmethod": "$paymentmethod",
          "amount": amount,
          "reference": "string",
          "datecreated": "2024-12-20T22:05:04.824Z",
          "createdby": "string",
          "status": "string"
        };
        print(bodyString.toString());
        print(url.toString());
        var body = jsonEncode(bodyString);

        var response = await http.post(url,
            headers: {
              "Content-Type": "Application/json",
            },
            body: body);
        print("++++++" + response.body.toString() + "+++++++");
        if (response.statusCode == 200) {
          final item = json.decode(response.body);
          // LoginModel user = LoginModel.fromJson(item);
        } else {
          setState(() {
            responseLoading = false;
          });
          showErrorToast("Payment failure.");
        }
      }
    } on WebSocketException catch (_) {
      showInfoToast("No Internet Connection.");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("No Internet Connection"),
      //       dismissDirection: DismissDirection.up,
      //     ),
      //   );
    }
  }

  @override
  void initState() {
    super.initState();
    _streams = getStreams();
    _controller = TabController(length: 4, vsync: this);
    _controller.addListener(() {
      setState(() {
        selectedIndex = _controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          // leading: SearchBar(),
          title: const Text(''),
          actions: [
            _toggleThemeButton(context),
            SizedBox(width: kDefaultPadding),
            _accountToggle(context)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BootstrapContainer(
            fluid: true,
            padding: const EdgeInsets.only(top: 0),
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "My Portal",
                        style: themeData.textTheme.labelLarge!
                            .copyWith(fontSize: 22),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Monitor your revenue streams and payments")
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * .65,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                // labelStyle: TextStyle(fontWeight: FontWeight.w600),
                                // unselectedLabelColor: Colors.grey[700],
                                // labelColor: Colors.grey.shade500,
                                indicatorColor: AppConstants.primaryColor,
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Revenue Streams",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Track PRNs",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Payments",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Performance",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                controller: _controller,
                                indicatorSize: TabBarIndicatorSize.tab,
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _controller,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              .85,
                                    ),
                                    child: FutureBuilder<List<RevenueStreams>>(
                                      future: _streams,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasError) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data!.isNotEmpty) {
                                              return BootstrapRow(
                                                children: <BootstrapCol>[
                                                  BootstrapCol(
                                                    sizes:
                                                        'col-lg-9 col-md-7 col-sm-12',
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .90,
                                                      child: ListView.builder(
                                                        reverse: false,
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        itemBuilder:
                                                            (BuildContext ctxt,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        16.0),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      debugPrint(
                                                                          "Tap");
                                                                    },
                                                                    child: Card(
                                                                      elevation:
                                                                          4,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                8.0,
                                                                            left:
                                                                                12.0,
                                                                            right:
                                                                                12.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 80,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Name: ${snapshot.data![index].businessname}',
                                                                                        maxLines: 3,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                      Text(
                                                                                        'Amount Due: UGX ${snapshot.data![index].tarrifamount.round()}',
                                                                                        style: TextStyle(
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        'Due Date: ${DateFormat('yyyy-MM-dd').format(snapshot.data![index].nextrenewaldate)}',
                                                                                        style: TextStyle(
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                SizedBox(
                                                                                  height: 55,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      SizedBox(height: 5),
                                                                                      SizedBox(
                                                                                        height: 30,
                                                                                        width: 80,
                                                                                        child: snapshot.data![index].nextrenewaldate.isBefore(DateTime.now())
                                                                                            ? ElevatedButton(
                                                                                                child: Text("Pay Now", style: TextStyle(fontSize: 14)),
                                                                                                style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.all(0.0)), foregroundColor: WidgetStateProperty.all<Color>(Colors.white), backgroundColor: WidgetStateProperty.all<Color>(AppConstants.primaryColor), shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: AppConstants.primaryColor)))),
                                                                                                onPressed: () {
                                                                                                  // payNowDialog();
                                                                                                })
                                                                                            : Container(),
                                                                                      ),
                                                                                    ],
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
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  BootstrapCol(
                                                    sizes:
                                                        'col-lg-3 col-md-5 col-sm-12',
                                                    child: Card(
                                                      elevation: 4,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        width: 300,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .90,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'Revenue Stream Details',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            } else {
                                              return Center(
                                                child: Text(
                                                    "You have no revenue streams."),
                                              );
                                            }
                                          } else {
                                            return Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              AppConstants
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          return Center(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Error: ${snapshot.error.toString()}."),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: Text("My Payments/Txns"),
                                  ),
                                  Container(
                                    child: Text("My Payment Performance"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
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
                  color: Colors.amber,
                ),
                Visibility(
                  visible: false,
                  // visible: isFullWidthButton,
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

  payNowDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pay Fee",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              title: Text(
                                "Revenue Stream",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: SizedBox(
                                height: 45,
                                child: TextField(
                                  controller: revenueStreamController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade500,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: AppConstants.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                    hintText: "",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              title: Text(
                                "Due Date",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: SizedBox(
                                height: 45,
                                child: TextField(
                                  controller: dueDateController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade500,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: AppConstants.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                    hintText: "",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              title: Text(
                                "Payment Frequency",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: SizedBox(
                                height: 45,
                                child: TextField(
                                  // controller: cardNoController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade500,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: AppConstants.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                    hintText: "",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              title: Text(
                                "Amount to Pay",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: SizedBox(
                                height: 45,
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade500,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: AppConstants.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                    hintText: "",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text("Pay Now",
                                  style: TextStyle(fontSize: 16)),
                              style: ButtonStyle(
                                  // padding: WidgetStateProperty.all(
                                  //     EdgeInsets.all(8.0)),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          AppConstants.primaryColor),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          side: BorderSide(
                                              color:
                                                  AppConstants.primaryColor)))),
                              onPressed: () {
                                //                               makePayment(
                                //   String streamid,
                                //   String userid,
                                //   String paymentmethod,
                                //   double amount,
                                //   String streamname,
                                //   DateTime nextrenewaldate,
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
