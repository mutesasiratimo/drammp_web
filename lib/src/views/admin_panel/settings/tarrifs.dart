import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:entebbe_dramp_web/models/tarriffs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import '../../../../config/constants.dart';

class TarrifsPage extends StatefulWidget {
  const TarrifsPage({super.key});

  @override
  State<TarrifsPage> createState() => _TarrifsPageState();
}

class _TarrifsPageState extends State<TarrifsPage> {
  List<int> rowCountListTarriff = [10, 20, 30, 40, 50, 100];
  List<TarriffsModel> _tarrifs = [];
  bool _isAscending = true;
  int _currentSortColumnTarriff = 0;
  bool _isAscendingTarriff = true;

  //get tarrifs list
  Future<List<TarriffsModel>> getTarrifs() async {
    List<TarriffsModel> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}charges");
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
      List<TarriffsModel> sectorsmodel =
          (items as List).map((data) => TarriffsModel.fromJson(data)).toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = sectorsmodel;
      debugPrint(sectorsmodel.toString());
      setState(() {
        _tarrifs = sectorsmodel;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  @override
  void initState() {
    getTarrifs();
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
              decoration: BoxDecoration(
                color: Colors.white,
              ),
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
                          sortColumnIndex: _currentSortColumnTarriff,
                          sortAscending: _isAscendingTarriff,
                          columns: [
                            DataColumn(
                              label: const Text("Purpose"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumnTarriff = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _tarrifs.sort((userA, userB) =>
                                        userB.purpose.compareTo(userA.purpose));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _tarrifs.sort((userA, userB) =>
                                        userA.purpose.compareTo(userB.purpose));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Amount"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumnTarriff = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _tarrifs.sort((userA, userB) =>
                                        userB.amount.compareTo(userA.amount));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _tarrifs.sort((userA, userB) =>
                                        userA.amount.compareTo(userB.amount));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Category"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumnTarriff = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _tarrifs.sort((userA, userB) => userB
                                        .sectorsubtypename
                                        .compareTo(userA.sectorsubtypename));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _tarrifs.sort((userA, userB) => userA
                                        .sectorsubtypename
                                        .compareTo(userB.sectorsubtypename));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Frequency"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumnTarriff = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _tarrifs.sort((userA, userB) => userB
                                        .frequency
                                        .compareTo(userA.frequency));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _tarrifs.sort((userA, userB) => userA
                                        .frequency
                                        .compareTo(userB.frequency));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Frequency (Days)"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumnTarriff = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _tarrifs.sort((userA, userB) => userB
                                        .frequencydays
                                        .compareTo(userA.frequencydays));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _tarrifs.sort((userA, userB) => userA
                                        .frequencydays
                                        .compareTo(userB.frequencydays));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: const Text("Status"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumnTarriff = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _tarrifs.sort((userA, userB) =>
                                        userB.status.compareTo(userA.status));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _tarrifs.sort((userA, userB) =>
                                        userA.status.compareTo(userB.status));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: const Text(""),
                            ),
                          ],
                          rows: _tarrifs.isNotEmpty
                              ? _tarrifs // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    (element) => DataRow2(
                                      cells: <DataCell>[
                                        DataCell(ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: 500),
                                          child: Text(
                                            "${element.purpose}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConstants.primaryColor,
                                                fontSize: 12),
                                          ),
                                        )),
                                        DataCell(Text(
                                          element.amount.round().toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          element.sectorsubtypename.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          element.frequency.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          element.frequencydays.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Badge(
                                          backgroundColor: element.status
                                                      .toString() ==
                                                  "0"
                                              ? Colors.amber.shade700
                                              : element.status.toString() == "1"
                                                  ? Colors.green.shade600
                                                  : Colors.red.shade600,
                                          label: Text(
                                            element.status.toString() == "0"
                                                ? "Pending"
                                                : element.status.toString() ==
                                                        "1"
                                                    ? "Active"
                                                    : "Suspended",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
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
                                      DataCell(Text("No")),
                                      DataCell(Text(" Tarrifs")),
                                      DataCell(Text("")),
                                      DataCell(Text("")),
                                      DataCell(Text("")),
                                    ],
                                  )
                                ],
                        ),
                      )
                      // BootstrapRow(
                      //   children: <BootstrapCol>[
                      //     BootstrapCol(
                      //       sizes: "col-lg-12 col-md-12 col-sm-12",
                      //       child: SizedBox(
                      //         height: size.height * 3,
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               vertical: 24.0, horizontal: 12.0),
                      //           margin: EdgeInsets.all(16.0),
                      //           child: Column(children: [

                      //           ]),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
