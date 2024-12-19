import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import '../../../../config/constants.dart';
import '../../../../models/fares.dart';

class FaresPage extends StatefulWidget {
  const FaresPage({super.key});

  @override
  State<FaresPage> createState() => _FaresPageState();
}

class _FaresPageState extends State<FaresPage> {
  List<int> rowCountList = [10, 20, 30, 40, 50, 100];
  List<FaresModel> _fares = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;

//get tarrifs list
  Future<List<FaresModel>> getFares() async {
    List<FaresModel> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}fares");
    debugPrint(url.toString());
    // String _ausword = "";

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
        // 'Authorization': 'Bearer $_authToken',
      },
    );
    debugPrint("++++++RESPONSE SECTORS" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
      List<FaresModel> sectorsmodel =
          (items as List).map((data) => FaresModel.fromJson(data)).toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = sectorsmodel;
      debugPrint(sectorsmodel.toString());
      setState(() {
        _fares = sectorsmodel;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  @override
  void initState() {
    getFares();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * .65,
                        child: DataTable2(
                          headingRowHeight: 45,
                          headingRowColor: WidgetStateColor.resolveWith(
                              (states) => AppConstants.primaryColor),
                          headingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          columnSpacing: 16,
                          // minWidth: 600,
                          sortColumnIndex: _currentSortColumn,
                          sortAscending: _isAscending,
                          columns: [
                            DataColumn(
                              label: const Text("Category"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _fares.sort((userA, userB) => userB
                                        .sectorsubtypename
                                        .compareTo(userA.sectorsubtypename));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _fares.sort((userA, userB) => userA
                                        .sectorsubtypename
                                        .compareTo(userB.sectorsubtypename));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Base Fare"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _fares.sort((userA, userB) => userB.basefare
                                        .compareTo(userA.basefare));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _fares.sort((userA, userB) => userA.basefare
                                        .compareTo(userB.basefare));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Per Min"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _fares.sort((userA, userB) => userB
                                        .durationrate
                                        .compareTo(userA.durationrate));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _fares.sort((userA, userB) => userA
                                        .durationrate
                                        .compareTo(userB.durationrate));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Initial Charge"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _fares.sort((userA, userB) => userB
                                        .firstkmrate
                                        .compareTo(userA.firstkmrate));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _fares.sort((userA, userB) => userA
                                        .firstkmrate
                                        .compareTo(userB.firstkmrate));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Subsequent Charge"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _fares.sort((userA, userB) => userB
                                        .nextkmrate
                                        .compareTo(userA.nextkmrate));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _fares.sort((userA, userB) => userA
                                        .nextkmrate
                                        .compareTo(userB.nextkmrate));
                                  }
                                });
                              },
                            ),
                            // DataColumn(
                            //   label: const Text("Status"),
                            //   onSort: (columnIndex, _) {
                            //     setState(() {
                            //       _currentSortColumn = columnIndex;
                            //       if (_isAscending == true) {
                            //         _isAscending = false;
                            //         _fares.sort((userA, userB) =>
                            //             userB.status.compareTo(userA.status));
                            //       } else {
                            //         _isAscending = true;
                            //         _fares.sort((userA, userB) =>
                            //             userA.status.compareTo(userB.status));
                            //       }
                            //     });
                            //   },
                            // ),
                            DataColumn(
                              label: const Text(""),
                            ),
                          ],
                          rows: _fares.isNotEmpty
                              ? _fares // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    (element) => DataRow2(
                                      cells: <DataCell>[
                                        DataCell(ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: 500),
                                          child: Text(
                                            "${element.sectorsubtypename}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConstants.primaryColor,
                                                fontSize: 12),
                                          ),
                                        )),
                                        DataCell(Text(
                                          element.basefare.round().toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          (element.durationrate * .67)
                                              .round()
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          "${element.firstkmrate.round()}/- for first ${element.firstkm} km",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          "${element.nextkmrate.round()}/- for next ${element.nextkm} km",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.more_horiz_sharp,
                                              color: AppConstants.primaryColor,
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
                                      DataCell(Text("No Fares")),
                                      DataCell(Text("")),
                                      // DataCell(Text("")),
                                      DataCell(Text("")),
                                    ],
                                  )
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
      ),
    );
  }
}
