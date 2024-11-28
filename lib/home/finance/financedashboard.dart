import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../models/walletlogs.dart';
import '../appbar.dart';

class FinanceDashboardPage extends StatefulWidget {
  const FinanceDashboardPage({super.key});

  @override
  State<FinanceDashboardPage> createState() => _FinanceDashboardPageState();
}

class _FinanceDashboardPageState extends Base<FinanceDashboardPage> {
  String selectedInterval = "Today";
  List<WalletLogsModel> _transactions = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;

  Future<List<WalletLogsModel>> getTransactions() async {
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

  @override
  void initState() {
    super.initState();
    getTransactions();
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
                    child: Column(
                      children: [
                        BootstrapRow(
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
                                        FilterChip(
                                          backgroundColor:
                                              Colors.deepPurpleAccent.shade200,
                                          label: Text(
                                            "Weekly",
                                            style: TextStyle(
                                                color:
                                                    selectedInterval == "Weekly"
                                                        ? Colors.black
                                                        : Colors.white),
                                          ),
                                          selected:
                                              selectedInterval == "Weekly",
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
                                                color:
                                                    selectedInterval == "Today"
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        gradient: LinearGradient(
                                            colors: [
                                              const Color.fromRGBO(
                                                  212, 252, 121, 100),
                                              const Color.fromRGBO(
                                                  212, 252, 121, 72),
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                1.0, 0.0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        gradient: LinearGradient(
                                            colors: [
                                              const Color.fromRGBO(
                                                  0, 242, 252, 100),
                                              const Color.fromRGBO(
                                                  0, 242, 252, 72),
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                1.0, 0.0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(254, 225, 64, 100),
                                              const Color.fromRGBO(
                                                  254, 225, 64, 72),
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                1.0, 0.0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                        gradient: LinearGradient(
                                            colors: [
                                              const Color.fromRGBO(
                                                  243, 126, 0, 100),
                                              const Color.fromRGBO(
                                                  243, 126, 0, 72),
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                1.0, 0.0),
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
                                            "Transactions (Income)",
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
                                        height: 350,
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
                                                      DataCell(Text(
                                                          "No Transactions")),
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
