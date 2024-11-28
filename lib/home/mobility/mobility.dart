import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/base.dart';
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../models/revenuestreamspaginated.dart';
import '../../models/trips.dart';
import '../appbar.dart';
import 'map_page.dart';

class MobilityPage extends StatefulWidget {
  const MobilityPage({super.key});

  @override
  State<MobilityPage> createState() => _MobilityPageState();
}

class _MobilityPageState extends Base<MobilityPage> {
  List<RevenueStreams> _streams = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  int _usersPage = 1;
  List<TripModel> _history = [];

  Future<List<TripModel>> getHistory() async {
    List<TripModel> returnValue = [];
    // String userId = "";
    String _authToken = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "trips/default?page=1&size=50");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    // _username = prefs.getString("email")!;
    // _password = prefs.getString("password")!;

    // await AppFunctions.authenticate(_username, _password);
    // _authToken = prefs.getString("authToken")!;

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

      TripsPaginatedModel tripModel = TripsPaginatedModel.fromJson(items);
      // List<TripModel> tripHistorysmodel =
      //     (items as List).map((data) => TripModel.fromJson(data)).toList();
      // var tripHistorys = tripHistorysmodel;
      returnValue = tripModel.items.reversed.toList();
      setState(() {
        _history = tripModel.items.reversed.toList();
      });

      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<RevenueStreams>> getStreams() async {
    List<RevenueStreams> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl +
        "revenuestreams/default?page=$_usersPage&size=50");
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
    // print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      RevenueStreamsPaginatedModel incidentsmodel =
          RevenueStreamsPaginatedModel.fromJson(items);

      returnValue = incidentsmodel.items;
      setState(() {
        _streams = incidentsmodel.items;
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
    getStreams();
    getHistory();
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
                    title: "Mobility Management",
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
                  // padding: EdgeInsets.all(16.0),
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
                                "Daily Statistics",
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
                                          Icons.monetization_on,
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
                                              "900,000",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "(UGX) Today.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
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
                                          Icons.sync_alt,
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
                                              "12",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Trips Today.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
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
                                        color: Colors.purple.shade50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.local_taxi,
                                          size: 32,
                                          color: Colors.purple.shade900,
                                        ),
                                        SizedBox(width: 18),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "6 of 9",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Active Vehicles.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
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
                                        color: Colors.green.shade50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(Icons.people_alt_outlined,
                                            size: 32),
                                        SizedBox(width: 18),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "108",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Passengers Today.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
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
                              sizes: "col-lg-7 col-md-12 col-sm-12",
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
                                            "Vehicle Live Location",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      MapPage()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              sizes: "col-lg-5 col-md-12 col-sm-12",
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
                                            "Vehicles Summary",
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
                                        height: 290,
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
                                              label: const Text("Reg-No"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userB.regno.compareTo(
                                                            userA.regno));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userA.regno.compareTo(
                                                            userB.regno));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Model"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userB.ownerid.compareTo(
                                                            userA.vin));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userA.ownerid.compareTo(
                                                            userB.vin));
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
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userB.status.compareTo(
                                                            userA.status));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userA.status.compareTo(
                                                            userB.status));
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                          rows: _streams.isNotEmpty
                                              ? _streams // Loops through dataColumnText, each iteration assigning the value to element
                                                  .map(
                                                    (element) => DataRow2(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                          "${element.regno}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppConstants
                                                                  .primaryColor,
                                                              fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.model
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                                ? "Inactive"
                                                                : element.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "Active"
                                                                    : "Disabled",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()
                                              : <DataRow2>[
                                                  const DataRow2(
                                                    cells: <DataCell>[
                                                      DataCell(Text("")),
                                                      DataCell(
                                                          Text("No Vehicles")),
                                                      DataCell(Text("")),
                                                    ],
                                                  )
                                                ],
                                          // rows: List.generate(
                                          //   demoRecentFiles.length,
                                          //   (index) => recentFileDataRow(demoRecentFiles[index]),
                                          // ),
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
                                            "Passenger Trips (${_history.length})",
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
                                              label: const Text("Trip No."),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _history.sort(
                                                        (userA, userB) =>
                                                            userB.id.compareTo(
                                                                userA.id));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _history.sort(
                                                        (userA, userB) => userA
                                                            .tripnumber
                                                            .compareTo(userB
                                                                .tripnumber));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Origin"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _history.sort(
                                                        (userA, userB) => userB
                                                            .startaddress
                                                            .compareTo(userA
                                                                .startaddress));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _history.sort(
                                                        (userA, userB) => userA
                                                            .startaddress
                                                            .compareTo(userB
                                                                .startaddress));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Destination"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _history.sort(
                                                        (userA, userB) => userB
                                                            .destinationaddress
                                                            .compareTo(userA
                                                                .destinationaddress));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _history.sort(
                                                        (userA, userB) => userA
                                                            .destinationaddress
                                                            .compareTo(userB
                                                                .destinationaddress));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Start"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _history.sort(
                                                        (userA, userB) => userB
                                                            .starttime
                                                            .compareTo(userA
                                                                .starttime));
                                                  } else {
                                                    _isAscending = true;
                                                    _history.sort(
                                                        (userA, userB) => userA
                                                            .starttime
                                                            .compareTo(userB
                                                                .starttime));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Stop"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _history.sort(
                                                        (userA, userB) => userB
                                                            .stoptime
                                                            .compareTo(userA
                                                                .stoptime));
                                                  } else {
                                                    _isAscending = true;
                                                    _history.sort(
                                                        (userA, userB) => userA
                                                            .stoptime
                                                            .compareTo(userB
                                                                .stoptime));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Fare(UGX)"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    _history.sort((userA,
                                                            userB) =>
                                                        userB.cost.compareTo(
                                                            userA.cost));
                                                  } else {
                                                    _isAscending = true;
                                                    _history.sort((userA,
                                                            userB) =>
                                                        userA.cost.compareTo(
                                                            userB.cost));
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
                                                    _history.sort((userA,
                                                            userB) =>
                                                        userB.status.compareTo(
                                                            userA.status));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _history.sort((userA,
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
                                          rows: _history.isNotEmpty
                                              ? _history // Loops through dataColumnText, each iteration assigning the value to element
                                                  .map(
                                                    (element) => DataRow2(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                          "${element.tripnumber}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppConstants
                                                                  .primaryColor,
                                                              fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.startaddress
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element
                                                              .destinationaddress
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.starttime
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          element.stoptime
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          "${element.cost.round()}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppConstants
                                                                  .primaryColor,
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
                                                                ? "Running"
                                                                : element.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "Complete"
                                                                    : "Complete/Unpaid",
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
                                                          Text("No Trips")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                    ],
                                                  )
                                                ],
                                          // rows: List.generate(
                                          //   demoRecentFiles.length,
                                          //   (index) => recentFileDataRow(demoRecentFiles[index]),
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // BootstrapCol(
                            //   sizes: "col-lg-5 col-md-12 col-sm-12",
                            //   child: SizedBox(
                            //     height: size.height * .7,
                            //     child: Container(
                            //       margin: EdgeInsets.all(16.0),
                            //       decoration: BoxDecoration(
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(16.0)),
                            //       ),
                            //       child: Text(
                            //         "Drivers",
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.w600,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
