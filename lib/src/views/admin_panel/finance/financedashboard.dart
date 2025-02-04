import 'dart:convert';

import 'package:entebbe_dramp_web/src/views/admin_panel/finance/barchartmonthly.dart';
import 'package:entebbe_dramp_web/src/views/admin_panel/finance/barchartquartely.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '/models/walletlogs.dart';
import 'barchart.dart';

class FinanceDashboardPage extends StatefulWidget {
  const FinanceDashboardPage({super.key});

  @override
  State<FinanceDashboardPage> createState() => _FinanceDashboardPageState();
}

class _FinanceDashboardPageState extends Base<FinanceDashboardPage> {
  String selectedInterval = "Annual";
  List<WalletLogsModel> _transactions = [];
  List<WalletLogsModel> _payments = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  double compliantCount = 0.0,
      pastSixtyDaysCount = 0.0,
      pastThirtyDaysCount = 0.0,
      underThirtyDaysCount = 0.0;

  void getDaysOverdue() async {
    var url =
        Uri.parse("${AppConstants.baseUrl}dash/stats/finance/days_overdue");
    String _authToken = "";
    String _username = "";
    String _password = "";
    // debugPrint("++++++++++++++++++++ DAYS OVERDUE ++++++++++++++++++++==");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    debugPrint("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        compliantCount = items["compliant"];
        underThirtyDaysCount = items["underthirtydays"];
        pastThirtyDaysCount = items["pastthirtydays"];
        pastSixtyDaysCount = items["pastsixtydays"];
      });
    } else {
      debugPrint(response.body.toString());
    }
  }

  Future<List<WalletLogsModel>> getWalletTopups() async {
    List<WalletLogsModel> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl + "walletlogs/type/IN");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

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
      List<WalletLogsModel> transModel = (items as List)
          .map((data) => WalletLogsModel.fromJson(data))
          .toList();

      returnValue = transModel;
      setState(() {
        _transactions = transModel;
      });
      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<WalletLogsModel>> getCustomerPayments() async {
    List<WalletLogsModel> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl + "walletlogs/type/OUT");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

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
      List<WalletLogsModel> transModel = (items as List)
          .map((data) => WalletLogsModel.fromJson(data))
          .toList();

      returnValue = transModel;
      setState(() {
        _payments = transModel;
      });
      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  @override
  void initState() {
    super.initState();
    getDaysOverdue();
    getWalletTopups();
    getCustomerPayments();
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
                    child: Column(
                      children: [
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: "col-lg-9 col-md-12 col-sm-12",
                              child: SizedBox(
                                height: size.height * .8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 24.0, horizontal: 12.0),
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color.fromRGBO(54, 41, 183, 1),
                                          const Color.fromRGBO(
                                              54, 41, 183, 100),
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
                                                color:
                                                    selectedInterval == "Annual"
                                                        ? Colors.black
                                                        : Colors.white),
                                          ),
                                          selected:
                                              selectedInterval == "Annual",
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
                                                color: selectedInterval ==
                                                        "Quarterly"
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                          selected:
                                              selectedInterval == "Quarterly",
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
                                                color: selectedInterval ==
                                                        "Monthly"
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                          selected:
                                              selectedInterval == "Monthly",
                                          onSelected: (bool value) {
                                            setState(() {
                                              selectedInterval = "Monthly";
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
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: BarChartPage(),
                                          )
                                          // Expanded(
                                          //   child: selectedInterval == "Annual"
                                          //       ? BarChartPage()
                                          //       : selectedInterval ==
                                          //               "Quarterly"
                                          //           ? BarChartPageQuarterly()
                                          //           : BarChartPageMonthly(),
                                          // )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 80,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(width: 12),
                                        Text("Projected",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(width: 50),
                                        Container(
                                          height: 10,
                                          width: 80,
                                          color: Colors.green.shade300,
                                        ),
                                        SizedBox(width: 12),
                                        Text("Actual",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-12 col-sm-12",
                              child: Column(
                                children: [
                                  SizedBox(height: 8),
                                  Card(
                                    child: SizedBox(
                                      height: 100,
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
                                                  "${compliantCount.round()}",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.green.shade900,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Payments (UGX).",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.green.shade900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Card(
                                    child: SizedBox(
                                      height: 100,
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
                                                  "${pastSixtyDaysCount.round()}",
                                                  style: TextStyle(
                                                    color: Colors.red.shade900,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Past 60 Days \nOverdue",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red.shade900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Card(
                                    child: SizedBox(
                                      height: 100,
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
                                                  "${pastThirtyDaysCount.round()}",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.amber.shade900,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Past 30 Days \nOverdue.",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.amber.shade900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Card(
                                    child: SizedBox(
                                      height: 100,
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
                                                  "${underThirtyDaysCount.round()}",
                                                  style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Under 30 Days \nOverdue.",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: "col-lg-12 col-md-12 col-sm-12",
                              child: SizedBox(
                                height: size.height * .7,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Payments",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(
                                        // width: 200,
                                        height: 300,
                                        child: DataTable2(
                                          headingRowHeight: 45,
                                          headingRowColor:
                                              WidgetStateColor.resolveWith(
                                                  (states) => AppConstants
                                                      .primaryColor),
                                          headingTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          columnSpacing: 16,
                                          // minWidth: 600,
                                          sortColumnIndex: _currentSortColumn,
                                          sortAscending: _isAscending,
                                          columns: [
                                            DataColumn(
                                              label: const Text("Description"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userB.id.compareTo(
                                                            userA.id));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _payments.sort(
                                                        (userA, userB) => userA
                                                            .description
                                                            .compareTo(userB
                                                                .description));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: const Text("Amount"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userB.amount.compareTo(
                                                            userA.amount));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userA.amount.compareTo(
                                                            userB.amount));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: const Text("Income"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userB.type.compareTo(
                                                            userA.type));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userA.type.compareTo(
                                                            userB.type));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: const Text("Service Fee"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userB.type.compareTo(
                                                            userA.type));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userA.type.compareTo(
                                                            userB.type));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: const Text("VAT (18%)"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userB.type.compareTo(
                                                            userA.type));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userA.type.compareTo(
                                                            userB.type));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("User"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _payments.sort(
                                                        (userA, userB) => userB
                                                            .userid.firstname
                                                            .compareTo(userA
                                                                .userid
                                                                .firstname));
                                                  } else {
                                                    _isAscending = true;
                                                    _payments.sort(
                                                        (userA, userB) => userA
                                                            .userid.firstname
                                                            .compareTo(userB
                                                                .userid
                                                                .firstname));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Mobile"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _payments.sort(
                                                        (userA, userB) => userB
                                                            .userid.phone
                                                            .compareTo(userA
                                                                .userid.phone));
                                                  } else {
                                                    _isAscending = true;
                                                    _payments.sort(
                                                        (userA, userB) => userA
                                                            .userid.phone
                                                            .compareTo(userB
                                                                .userid.phone));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Status"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userB.status.compareTo(
                                                            userA.status));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _payments.sort((userA,
                                                            userB) =>
                                                        userA.status.compareTo(
                                                            userB.status));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text(""),
                                            ),
                                          ],
                                          rows: _payments.isNotEmpty
                                              ? _payments // Loops through dataColumnText, each iteration assigning the value to element
                                                  .map(
                                                    (element) => DataRow2(
                                                      cells: <DataCell>[
                                                        DataCell(ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth:
                                                                      500),
                                                          child: Text(
                                                            "${element.description}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppConstants
                                                                    .primaryColor,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                        DataCell(Text(
                                                          element.amount
                                                              .round()
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          (element.amount * .67)
                                                              .round()
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          (element.amount * .15)
                                                              .round()
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          (element.amount * .18)
                                                              .round()
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          "${element.userid.firstname} ${element.userid.lastname}",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.userid.phone
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Badge(
                                                          backgroundColor: element
                                                                      .status
                                                                      .toString() ==
                                                                  "0"
                                                              ? Colors.amber
                                                                  .shade700
                                                              : element.status
                                                                          .toString() ==
                                                                      "1"
                                                                  ? Colors.green
                                                                      .shade600
                                                                  : Colors.red
                                                                      .shade600,
                                                          label: Text(
                                                            element.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? "Pending"
                                                                : element.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "Successful"
                                                                    : "Failed/Unpaid",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                        DataCell(
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons
                                                                  .more_horiz_sharp,
                                                              color: AppConstants
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()
                                              : <DataRow2>[
                                                  const DataRow2(
                                                    cells: <DataCell>[
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(
                                                          Text("No Payments")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                    ],
                                                  )
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
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: "col-lg-12 col-md-12 col-sm-12",
                              child: SizedBox(
                                height: size.height * .7,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Wallet Topups",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(
                                        // width: 200,
                                        height: 300,
                                        child: DataTable2(
                                          headingRowHeight: 45,
                                          headingRowColor:
                                              WidgetStateColor.resolveWith(
                                                  (states) => AppConstants
                                                      .primaryColor),
                                          headingTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          columnSpacing: 16,
                                          // minWidth: 600,
                                          sortColumnIndex: _currentSortColumn,
                                          sortAscending: _isAscending,
                                          columns: [
                                            DataColumn(
                                              label: const Text("Description"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _transactions.sort(
                                                        (userA, userB) =>
                                                            userB.id.compareTo(
                                                                userA.id));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _transactions.sort(
                                                        (userA, userB) => userA
                                                            .description
                                                            .compareTo(userB
                                                                .description));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: const Text("Amount"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userB.amount.compareTo(
                                                            userA.amount));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userA.amount.compareTo(
                                                            userB.amount));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Type"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userB.type.compareTo(
                                                            userA.type));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userA.type.compareTo(
                                                            userB.type));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("User"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _transactions.sort(
                                                        (userA, userB) => userB
                                                            .userid.firstname
                                                            .compareTo(userA
                                                                .userid
                                                                .firstname));
                                                  } else {
                                                    _isAscending = true;
                                                    _transactions.sort(
                                                        (userA, userB) => userA
                                                            .userid.firstname
                                                            .compareTo(userB
                                                                .userid
                                                                .firstname));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Mobile"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _transactions.sort(
                                                        (userA, userB) => userB
                                                            .userid.phone
                                                            .compareTo(userA
                                                                .userid.phone));
                                                  } else {
                                                    _isAscending = true;
                                                    _transactions.sort(
                                                        (userA, userB) => userA
                                                            .userid.phone
                                                            .compareTo(userB
                                                                .userid.phone));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Status"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userB.status.compareTo(
                                                            userA.status));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _transactions.sort((userA,
                                                            userB) =>
                                                        userA.status.compareTo(
                                                            userB.status));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Details"),
                                            ),
                                          ],
                                          rows: _transactions.isNotEmpty
                                              ? _transactions // Loops through dataColumnText, each iteration assigning the value to element
                                                  .map(
                                                    (element) => DataRow2(
                                                      cells: <DataCell>[
                                                        DataCell(ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth:
                                                                      500),
                                                          child: Text(
                                                            "${element.description}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppConstants
                                                                    .primaryColor,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                        DataCell(Text(
                                                          element.amount
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.type
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          "${element.userid.firstname} ${element.userid.lastname}",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.userid.phone
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Badge(
                                                          backgroundColor: element
                                                                      .status
                                                                      .toString() ==
                                                                  "0"
                                                              ? Colors.amber
                                                                  .shade700
                                                              : element.status
                                                                          .toString() ==
                                                                      "1"
                                                                  ? Colors.green
                                                                      .shade600
                                                                  : Colors.red
                                                                      .shade600,
                                                          label: Text(
                                                            element.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? "Pending"
                                                                : element.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "Successful"
                                                                    : "Failed/Unpaid",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                        DataCell(
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons
                                                                  .more_horiz_sharp,
                                                              color: AppConstants
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()
                                              : <DataRow2>[
                                                  const DataRow2(
                                                    cells: <DataCell>[
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(
                                                          Text("No Topups")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                    ],
                                                  )
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
