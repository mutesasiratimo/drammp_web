import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '../../../../models/revenuesector.dart';
import '/models/revenuestreamspaginated.dart';

class EnforcementDashboardPage extends StatefulWidget {
  const EnforcementDashboardPage({super.key});

  @override
  State<EnforcementDashboardPage> createState() =>
      _EnforcementDashboardPageState();
}

class _EnforcementDashboardPageState extends Base<EnforcementDashboardPage> {
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  int rows = 10;
  Duration? executionTime;
  List<RevenueStreams> _streams = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  List<int> rowCountList = [10, 50, 100];
  int _streamsPage = 1;
  int _streamsRowCount = 10;
  String selectedInitSector = "Select Sector";
  String selectedInitSectorId = "";
  List<RevenueSectorsModel> sectorList = <RevenueSectorsModel>[];
  int compliantCount = 0,
      pastSixtyDaysCount = 0,
      pastThirtyDaysCount = 0,
      underThirtyDaysCount = 0;

  void exportToExcel() {
    final stopwatch = Stopwatch()..start();

    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];
    int index = 0;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index))
        .value = TextCellValue("Reference Number");

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index))
        .value = TextCellValue("Revenue Stream");

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index))
        .value = TextCellValue("Amount Due");

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index))
        .value = TextCellValue("Due Date");

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index))
        .value = TextCellValue("Status");

    for (var stream in _streams) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index))
          .value = TextCellValue(stream.regreferenceno);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index))
          .value = TextCellValue(stream.businessname);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index))
          .value = TextCellValue(stream.tarrifamount.toString());

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index))
          .value = TextCellValue(stream.nextrenewaldate.toString());

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index))
          .value = TextCellValue(stream.status);

      index++;
    }

    excel.save(
        fileName: "$selectedInitSector Enforcement ${DateTime.now()}.xlsx");
    setState(() {
      executionTime = stopwatch.elapsed;
    });
  }

  Future<List<RevenueStreams>> getStreams(String sectorId) async {
    List<RevenueStreams> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl +
        "revenuestreams/sector/default/$sectorId?page=$_streamsPage&size=$_streamsRowCount");
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
    setState(() {
      _streams = [];
    });
    print("++++++" + response.body.toString() + "+++++++");
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

  void getDaysOverdue() async {
    var url = Uri.parse("${AppConstants.baseUrl}dash/stats/days_overdue");
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
    // debugPrint("++++++" + response.body.toString() + "+++++++");
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

  //get sectors list
  Future<List<RevenueSectorsModel>> getSectors() async {
    List<RevenueSectorsModel> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}revenuesectors");

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
    // debugPrint("++++++RESPONSE SECTORS" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
      List<RevenueSectorsModel> sectorsmodel = (items as List)
          .map((data) => RevenueSectorsModel.fromJson(data))
          .toList();

      returnValue = sectorsmodel;

      setState(() {
        sectorList = sectorsmodel;
        selectedInitSector = sectorsmodel.first.name;
        selectedInitSectorId = sectorsmodel.first.id;
        getStreams(selectedInitSectorId);
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
    super.initState();
    getDaysOverdue();
    getSectors();
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
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Payment/Subscription Statistics",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: "col-lg-3 col-md-6 col-sm-12",
                              child: Card(
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
                                              "$compliantCount",
                                              style: TextStyle(
                                                color: Colors.green.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Compliant.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
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
                                              "$pastSixtyDaysCount",
                                              style: TextStyle(
                                                color: Colors.red.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Past 60 Days \nOverdue",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
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
                                              "$pastThirtyDaysCount",
                                              style: TextStyle(
                                                color: Colors.amber.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Past 30 Days \nOverdue.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
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
                                              "$underThirtyDaysCount",
                                              style: TextStyle(
                                                color: Colors.blue.shade900,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Under 30 Days \nOverdue.",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text(
                                          //   "Revenue Streams",
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontWeight: FontWeight.w600,
                                          //   ),
                                          // ),
                                          Container(
                                            width: 250,
                                            height: 35,
                                            margin:
                                                EdgeInsets.only(bottom: 16.0),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0.0),
                                              // title: Text(
                                              //   'Select Sector',
                                              //   style: TextStyle(
                                              //     fontSize: 14,
                                              //     fontWeight: FontWeight.w600,
                                              //   ),
                                              // ),
                                              title: DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0,
                                                          horizontal: 8),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xffB9B9B9)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xffB9B9B9),
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                  hintText: 'Select Sector',
                                                ),
                                                isExpanded: true,
                                                hint: new Text(
                                                  selectedInitSector,
                                                  style: const TextStyle(
                                                      // color: Colors.grey,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: sectorList.map((item) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                      item.name,
                                                      style: const TextStyle(
                                                          // color: Colors.grey,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    value: item,
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  // ignore: unused_local_variable
                                                  List itemsList =
                                                      sectorList.map((item) {
                                                    if (item == newVal) {
                                                      setState(() async {
                                                        selectedInitSector =
                                                            item.name;
                                                        selectedInitSectorId =
                                                            item.id;
                                                        getStreams(
                                                            selectedInitSectorId);
                                                      });
                                                    }
                                                  }).toList();
                                                },
                                              ),
                                            ),
                                          ),
                                          TextButton.icon(
                                            icon: Icon(
                                              Icons.file_copy_rounded,
                                              color:
                                                  AppConstants.secondaryColor,
                                            ),
                                            label: Text(
                                              'Export',
                                              style: TextStyle(
                                                color:
                                                    AppConstants.secondaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onPressed: exportToExcel,
                                            style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                              backgroundColor:
                                                  AppConstants.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      SizedBox(
                                        // width: 200,
                                        height: 250,
                                        child: DataTable2(
                                          headingRowHeight: 40,
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
                                              label: const Text("CRAIN"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userB
                                                            .regreferenceno
                                                            .compareTo(userA
                                                                .regreferenceno));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userA
                                                            .regreferenceno
                                                            .compareTo(userB
                                                                .regreferenceno));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Name"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userB
                                                            .businessname
                                                            .compareTo(userA
                                                                .businessname));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userA
                                                            .businessname
                                                            .compareTo(userB
                                                                .businessname));
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
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userB.ownerid.compareTo(
                                                            userA.vin));
                                                  } else {
                                                    _isAscending = true;
                                                    _streams.sort((userA,
                                                            userB) =>
                                                        userA.ownerid.compareTo(
                                                            userB.vin));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Amount"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userB
                                                            .tarrifamount
                                                            .compareTo(userA
                                                                .tarrifamount));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userA
                                                            .tarrifamount
                                                            .compareTo(userB
                                                                .tarrifamount));
                                                  }
                                                });
                                              },
                                            ),
                                            DataColumn(
                                              label: const Text("Due Date"),
                                              onSort: (columnIndex, _) {
                                                setState(() {
                                                  _currentSortColumn =
                                                      columnIndex;
                                                  if (_isAscending == true) {
                                                    _isAscending = false;
                                                    // sort the product list in Ascending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userB
                                                            .nextrenewaldate
                                                            .compareTo(userA
                                                                .nextrenewaldate));
                                                  } else {
                                                    _isAscending = true;
                                                    // sort the product list in Descending, order by Price
                                                    _streams.sort(
                                                        (userA, userB) => userA
                                                            .nextrenewaldate
                                                            .compareTo(userB
                                                                .nextrenewaldate));
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
                                                          "${element.regreferenceno}",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          "${element.businessname}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppConstants
                                                                  .primaryColor,
                                                              fontSize: 14),
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
                                                          "${element.tarrifamount}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppConstants
                                                                  .primaryColor,
                                                              fontSize: 12),
                                                        )),
                                                        DataCell(Text(
                                                          "${dateFormat.format(element.nextrenewaldate)}",
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
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                      DataCell(Text(
                                                          "No Revenue Streams")),
                                                      DataCell(Text("")),
                                                      DataCell(Text("")),
                                                    ],
                                                  )
                                                ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
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
                                                  _streamsRowCount.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                // icon: const Icon(Icons.keyboard_arrow_down),
                                                items: rowCountList.map((item) {
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
                                                    _streamsRowCount =
                                                        newVal ?? 10;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                                "1 - ${_streams.length} of $_streamsRowCount"),
                                            SizedBox(width: 8),
                                            IconButton(
                                                onPressed: () =>
                                                    (_streamsPage > 1)
                                                        ? setState(() {
                                                            _streamsPage--;
                                                            getStreams(
                                                                selectedInitSectorId);
                                                          })
                                                        : null,
                                                icon: Icon(Icons.arrow_back_ios,
                                                    size: 14)),
                                            SizedBox(width: 8),
                                            IconButton(
                                                onPressed: () =>
                                                    (_streams.length <=
                                                            _streamsRowCount)
                                                        ? setState(() {
                                                            _streamsPage++;
                                                            getStreams(
                                                                selectedInitSectorId);
                                                          })
                                                        : null,
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
