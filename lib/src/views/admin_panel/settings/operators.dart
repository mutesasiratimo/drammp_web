import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '../../../../models/operators.dart';

class OperatorsPage extends StatefulWidget {
  const OperatorsPage({super.key});

  @override
  State<OperatorsPage> createState() => _OperatorsPageState();
}

class _OperatorsPageState extends State<OperatorsPage> {
  List<Item> _operators = [];
  int _pageNumber = 1;
  int rowCount = 10;
  int _currentSortColumn = 0;
  bool _isAscending = true;
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  Future<List<Item>> getOperators() async {
    List<Item> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl +
        "operators/default?page=$_pageNumber&size=$rowCount");
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
      OperatorsModel operatorsmodel = OperatorsModel.fromJson(items);

      returnValue = operatorsmodel.items;
      setState(() {
        _operators = operatorsmodel.items;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve users");
    }
    return returnValue;
  }

  @override
  void initState() {
    super.initState();
    getOperators();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BootstrapRow(
        children: <BootstrapCol>[
          BootstrapCol(
            sizes: "col-lg-12 col-md-12 col-sm-12",
            child: SizedBox(
              height: size.height * .8,
              child: Container(
                padding: EdgeInsets.all(24.0),
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(children: [
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
                          label: const Text("Name"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _operators.sort((userA, userB) =>
                                    userB.firstname.compareTo(userA.firstname));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _operators.sort((userA, userB) =>
                                    userA.firstname.compareTo(userB.firstname));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("Email Address"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _operators.sort((userA, userB) =>
                                    userB.email.compareTo(userA.email));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _operators.sort((userA, userB) =>
                                    userA.email.compareTo(userB.email));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("Phone"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _operators.sort((userA, userB) =>
                                    userB.phone.compareTo(userA.phone));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _operators.sort((userA, userB) =>
                                    userA.phone.compareTo(userB.phone));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("FCM ID?"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _operators.sort((userA, userB) =>
                                    userB.fcmid.compareTo(userA.fcmid));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _operators.sort((userA, userB) =>
                                    userA.fcmid.compareTo(userB.fcmid));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("Date Registered"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _operators.sort((userA, userB) => userB
                                    .dateofbirth
                                    .compareTo(userA.dateofbirth));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _operators.sort((userA, userB) => userA
                                    .dateofbirth
                                    .compareTo(userB.dateofbirth));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text("Details"),
                        ),
                      ],
                      rows: _operators.isNotEmpty
                          ? _operators // Loops through dataColumnText, each iteration assigning the value to element
                              .map(
                                (element) => DataRow2(
                                  cells: <DataCell>[
                                    DataCell(ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 500),
                                      child: Text(
                                        "${element.firstname}",
                                        // "${element.firstname} ${element.lastname}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.primaryColor,
                                            fontSize: 12),
                                      ),
                                    )),
                                    DataCell(Text(
                                      element.email.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )),
                                    DataCell(Text(
                                      "${element.phone} ${element.mobile}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )),
                                    DataCell(Badge(
                                      backgroundColor: element.fcmid
                                                  .toString() ==
                                              ""
                                          ? Colors.amber.shade700
                                          : (element.fcmid.toString() != "" &&
                                                  // ignore: unnecessary_null_comparison
                                                  element.fcmid.toString() !=
                                                      null)
                                              ? Colors.green.shade600
                                              : Colors.red.shade600,
                                      label: Text(
                                        element.fcmid.toString() == ""
                                            ? "No"
                                            : (element.fcmid.toString() != "" &&
                                                    // ignore: unnecessary_null_comparison
                                                    element.fcmid.toString() !=
                                                        null)
                                                ? "Yes"
                                                : "Null",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    )),
                                    DataCell(Text(
                                      "${element.dateofbirth}",
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
                                  DataCell(Text("No Operators")),
                                  DataCell(Text("")),
                                  // DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              )
                            ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
