// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import 'package:http/http.dart' as http;
import '../../../../config/functions.dart';
import '/models/revenuesector.dart';

class RevenuesectorsPage extends StatefulWidget {
  const RevenuesectorsPage({super.key});

  @override
  State<RevenuesectorsPage> createState() => _RevenuesectorsPageState();
}

class _RevenuesectorsPageState extends Base<RevenuesectorsPage> {
  List<RevenueSectorsModel> revenueSectors = [];
  GoRouter? _appRouter;
  int _rowsPerPage = 10;
  int _currentSortColumn = 0;
  bool _isAscending = true;
  int revenueSectorsPage = 1;
  PageController revenuePageController = PageController();
  List<int> rowCountList = [10, 20, 30, 40, 50, 100];
  bool _dataSourceLoading = false;
  int _initialRow = 0;
  bool responseLoading = false;

  registerSector(String name, code, description) async {
    var url = Uri.parse("${AppConstants.baseUrl}revenuesectors/create");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      responseLoading = true;
    });
    String _authToken = "";
    String _username = "";
    String _password = "";
    String _userId = "";

    if (prefs.getString("userid") != null &&
        prefs.getString("password") != null) {
      //Get username and password from shared prefs
      _username = prefs.getString("email")!;
      _password = prefs.getString("password")!;
      _userId = prefs.getString("userid")!;

      await AppFunctions.authenticate(_username, _password);
      _authToken = prefs.getString("authToken")!;
    }

    var bodyString = {
      "id": "",
      "code": "$code",
      "name": "$name",
      "description": "$description",
      "datecreated": "2025-02-03T18:06:58.773Z",
      "createdby": "$_userId",
      "dateupdated": "2025-02-03T18:06:58.773Z",
      "updatedby": "",
      "status": "1"
    };
    debugPrint(bodyString.toString());
    debugPrint(url.toString());
    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    debugPrint("++++++${response.body}+++++++");
    debugPrint("++++++${response.statusCode}+++++++");
    if (response.statusCode == 200) {
      // final items = json.decode(response.body);

      Navigator.of(context).pop();
      _appRouter!.go("/sectors");
      showSuccessToast("New sector created!");

      setState(() {
        responseLoading = false;
      });
      // showSnackBar("Alert: User account not activated.");
    } else if (response.statusCode == 409) {
      setState(() {
        responseLoading = false;
      });
      showWarningToast("Duplication Alert: This sector already exists!!!");
    } else {
      setState(() {
        responseLoading = false;
      });
      showErrorToast("Authentication Failure: Invalid credentials.");
    }
  }

  //get sectors list
  Future<List<RevenueSectorsModel>> getSectors() async {
    List<RevenueSectorsModel> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}revenuesectors");
    debugPrint(url.toString());
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get username and password from shared prefs
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
    debugPrint("++++++RESPONSE SECTORS" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
      List<RevenueSectorsModel> sectorsmodel = (items as List)
          .map((data) => RevenueSectorsModel.fromJson(data))
          .toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = sectorsmodel;
      debugPrint(sectorsmodel.toString());
      setState(() {
        revenueSectors = sectorsmodel;
        // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  @override
  void initState() {
    getSectors();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: revenuePageController,
        // physics: const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: false,
        children: [
          Container(
            // color: Colors.purple.shade50,
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.0),
            child: Card(
              // color: Colors.white,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      // width: 200,
                      // color: Colors.grey[200],
                      child: ElevatedButton(
                        onPressed: () {
                          //   revenuePageController.jumpToPage(1);
                          //   showInfoToast("Navigate");
                          // push(const AddRevenueSectorPage());
                          // addSectorDialog();
                          _appRouter!.go("/add-sector");
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppConstants.secondaryColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Text(
                              'New Sector',
                              style: TextStyle(
                                  color: AppConstants.secondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .55,
                  child: Container(
                    // width: 200,
                    height: 290,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DataTable2(
                      headingRowHeight: 35,
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
                          label: const Text("Code"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                revenueSectors.sort((userA, userB) =>
                                    userB.code.compareTo(userA.code));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                revenueSectors.sort((userA, userB) =>
                                    userA.code.compareTo(userB.code));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text("Name"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                revenueSectors.sort((userA, userB) =>
                                    userB.name.compareTo(userA.name));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                revenueSectors.sort((userA, userB) =>
                                    userA.name.compareTo(userB.name));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text("Description"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                revenueSectors.sort((userA, userB) => userB
                                    .description
                                    .compareTo(userA.description));
                              } else {
                                _isAscending = true;
                                revenueSectors.sort((userA, userB) => userA
                                    .description
                                    .compareTo(userB.description));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text("Categories"),
                          onSort: (columnIndex, _) {},
                        ),
                        DataColumn(
                          label: const Text("Status"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                revenueSectors.sort((userA, userB) =>
                                    userB.status.compareTo(userA.status));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                revenueSectors.sort((userA, userB) =>
                                    userA.status.compareTo(userB.status));
                              }
                            });
                          },
                        ),
                      ],
                      rows: revenueSectors.isNotEmpty
                          ? revenueSectors // Loops through dataColumnText, each iteration assigning the value to element
                              .map(
                                (element) => DataRow2(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                      "${element.code}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )),
                                    DataCell(Text(
                                      "${element.name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // color: AppConstants.primaryColor,
                                          fontSize: 12),
                                    )),
                                    DataCell(Text(
                                      element.description.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )),
                                    DataCell(Text(
                                      "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.primaryColor,
                                          fontSize: 12),
                                    )),
                                    DataCell(Badge(
                                      backgroundColor:
                                          element.status.toString() == "0"
                                              ? Colors.amber.shade700
                                              : element.status.toString() == "1"
                                                  ? Colors.green.shade600
                                                  : Colors.red.shade600,
                                      label: Text(
                                        element.status.toString() == "0"
                                            ? "Inactive"
                                            : element.status.toString() == "1"
                                                ? "Active"
                                                : "Disabled",
                                        style: const TextStyle(fontSize: 12),
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
                                  DataCell(Text("")),
                                  DataCell(Text("No Revenue Sectors")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              )
                            ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Rows per Page"),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: DropdownButton(
                          underline: SizedBox(),
                          // isExpanded: true,
                          hint: new Text(
                            _rowsPerPage.toString(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          // icon: const Icon(Icons.keyboard_arrow_down),
                          items: rowCountList.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _rowsPerPage = newVal ?? 10;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("1 - ${revenueSectors.length} of $_rowsPerPage"),
                      SizedBox(width: 8),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_back_ios, size: 14)),
                      SizedBox(width: 8),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios, size: 14)),
                    ],
                  ),
                )
              ]),
            ),
          ),
          Container(
            color: Colors.purple.shade50,
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
                SizedBox(width: 15 * 0.5),
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
          SizedBox(width: 15 * 0.5),
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

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oops! $errorMessage',
                      style: const TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: retry,
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text('Retry', style: TextStyle(color: Colors.white))
                      ]))
                ])),
      );
}

class _Loading extends StatefulWidget {
  @override
  __LoadingState createState() => __LoadingState();
}

class __LoadingState extends State<_Loading> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white.withAlpha(128),
        // at first show shade, if loading takes longer than 0,5s show spinner
        child: FutureBuilder(
            future:
                Future.delayed(const Duration(milliseconds: 500), () => true),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SizedBox()
                  : Center(
                      child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(7),
                      width: 150,
                      height: 50,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                            Text('Loading..')
                          ]),
                    ));
            }));
  }
}

class _TitledRangeSelector extends StatefulWidget {
  const _TitledRangeSelector(
      {super.key,
      required this.onChanged,
      this.title = "",
      this.caption = "",
      this.range = const RangeValues(0, 100)});

  final String title;
  final String caption;
  final Duration titleToSelectorSwitch = const Duration(seconds: 2);
  final RangeValues range;
  final Function(RangeValues) onChanged;

  @override
  State<_TitledRangeSelector> createState() => _TitledRangeSelectorState();
}

class _TitledRangeSelectorState extends State<_TitledRangeSelector> {
  bool _titleVisible = true;
  RangeValues _values = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();

    _values = widget.range;

    Timer(widget.titleToSelectorSwitch, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _titleVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerLeft, children: [
      AnimatedOpacity(
          opacity: _titleVisible ? 1 : 0,
          duration: const Duration(milliseconds: 1000),
          child: Align(
              alignment: Alignment.centerLeft, child: Text(widget.title))),
      AnimatedOpacity(
          opacity: _titleVisible ? 0 : 1,
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
              width: 340,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DefaultTextStyle(
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _values.start.toStringAsFixed(0),
                                  ),
                                  Text(
                                    widget.caption,
                                  ),
                                  Text(
                                    _values.end.toStringAsFixed(0),
                                  )
                                ]))),
                    SizedBox(
                        height: 24,
                        child: RangeSlider(
                          values: _values,
                          divisions: 9,
                          min: widget.range.start,
                          max: widget.range.end,
                          onChanged: (v) {
                            setState(() {
                              _values = v;
                            });
                            widget.onChanged(v);
                          },
                        ))
                  ])))
    ]);
  }
}
