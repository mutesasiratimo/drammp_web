import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '../../../../provider/messageprovider.dart';
import '/models/revenuestreamspaginated.dart';
import '/models/trips.dart';
import 'map_page.dart';

class MobilityPage extends StatefulWidget {
  const MobilityPage({super.key});

  @override
  State<MobilityPage> createState() => _MobilityPageState();
}

class _MobilityPageState extends Base<MobilityPage> {
  int carPage = 1;
  int tripsPage = 1;
  int carPageRows = 5;
  int tripPageRows = 50;
  List<int> rowCountListCars = [5, 10, 20, 30, 50, 100];
  List<int> rowCountListTrips = [20, 50, 100];
  List<RevenueStreams> _streams = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  List<TripModel> _history = [];
  int faresToday = 0,
      tripsToday = 0,
      activeVehicles = 0,
      inactiveVehicles = 0,
      totalVehicles = 0,
      passengersToday = 0;
  late StreamSubscription streamSub;
  late Stream stream;

  void getMobilityStats() async {
    var url = Uri.parse("${AppConstants.baseUrl}dash/stats/mobility");
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
        faresToday = items["fares"];
        tripsToday = items["trips"];
        activeVehicles = items["activevehicles"];
        inactiveVehicles = items["inactivevehicles"];
        totalVehicles = activeVehicles + inactiveVehicles;
        passengersToday = items["passengers"];
      });
    } else {
      debugPrint(response.body.toString());
    }
  }

  Future<List<TripModel>> getHistory() async {
    List<TripModel> returnValue = [];
    // String userId = "";
    String _authToken = "";
    // setState(() {
    //   _history = [];
    // });
    print("get trips");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl +
        "trips/default?page=$tripsPage&size=$tripPageRows");

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
    // print("++++++" + response.body.toString() + "+++++++");
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
        "revenuestreams/municipalityowned/bus/default?page=$carPage&size=$carPageRows");
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
      RevenueStreamsPaginatedModel streamsmodel =
          RevenueStreamsPaginatedModel.fromJson(items);

      returnValue = streamsmodel.items;
      setState(() {
        _streams = streamsmodel.items;
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
    initSocket();
    getMobilityStats();
    getStreams();
    getHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initSocket() async {
    context.read<MessageNotifierProvider>().notifyStream.listen((value) {
      getHistory();
      getMobilityStats();
      getStreams();
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
                  // padding: EdgeInsets.all(16.0),
                  child: Card(
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
                              child: SizedBox(
                                height: size.height * .15,
                                child: Container(
                                  margin: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                      color: Colors.green.shade50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            "${faresToday}",
                                            style: TextStyle(
                                              color: Colors.green.shade900,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "(UGX) Today.",
                                            style: TextStyle(
                                              color: Colors.green.shade900,
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
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: SizedBox(
                                height: size.height * .15,
                                child: Container(
                                  margin: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                      color: Colors.blue.shade50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            "${tripsToday}",
                                            style: TextStyle(
                                              color: Colors.blue.shade900,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Trips Today.",
                                            style: TextStyle(
                                              color: Colors.blue.shade900,
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
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: SizedBox(
                                height: size.height * .15,
                                child: Container(
                                  margin: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                      color: Colors.purple.shade50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            "${activeVehicles} of ${totalVehicles}",
                                            style: TextStyle(
                                              color: Colors.purple.shade900,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Active Vehicles.",
                                            style: TextStyle(
                                              color: Colors.purple.shade900,
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
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: SizedBox(
                                height: size.height * .15,
                                child: Container(
                                  margin: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                      color: Colors.green.shade50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.people_alt_outlined,
                                        size: 32,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 18),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$passengersToday",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Passengers Today.",
                                            style: TextStyle(
                                              color: Colors.black,
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
                                        height: 260,
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
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text("Rows per Page"),
                                            SizedBox(width: 8),
                                            SizedBox(
                                              width: 50,
                                              child: DropdownButton(
                                                underline: SizedBox(),
                                                // isExpanded: true,
                                                hint: new Text(
                                                  carPageRows.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                // icon: const Icon(Icons.keyboard_arrow_down),
                                                items: rowCountListCars
                                                    .map((item) {
                                                  return DropdownMenuItem(
                                                    child: Text(
                                                      item.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    value: item,
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    carPageRows = newVal ?? 10;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                                "1 - ${_streams.length} of $carPageRows"),
                                            SizedBox(width: 8),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.arrow_back_ios,
                                                    size: 14)),
                                            SizedBox(width: 8),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14)),
                                          ],
                                        ),
                                      )
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
                                height: size.height * .75,
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
                                                                    : "Unpaid",
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
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text("Rows per Page"),
                                            SizedBox(width: 8),
                                            SizedBox(
                                              width: 50,
                                              child: DropdownButton(
                                                underline: SizedBox(),
                                                // isExpanded: true,
                                                hint: new Text(
                                                  carPageRows.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                // icon: const Icon(Icons.keyboard_arrow_down),
                                                items: rowCountListTrips
                                                    .map((item) {
                                                  return DropdownMenuItem(
                                                    child: Text(
                                                      item.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    value: item,
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    tripPageRows = newVal ?? 10;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                                "1 - ${_history.length} of $tripPageRows"),
                                            SizedBox(width: 8),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.arrow_back_ios,
                                                    size: 14)),
                                            SizedBox(width: 8),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14)),
                                          ],
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
}
