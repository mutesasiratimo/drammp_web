// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:go_router/go_router.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '/models/revenuesectorcategoriesfiltered.dart';
import '/models/revenuestreamspaginated.dart';
import 'accommodation/addindividualrensportrevenuestream.dart';
import 'accommodation/addnonindividualtransportrevenuestream.dart';
import 'data_sources.dart';
import '/models/revenuesector.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'fisheries/addindividualfishrevenuestream.dart';
import 'fisheries/addnonindividualfishrevenuestream.dart';
import 'transport/addindividualrevenuestream.dart';
import 'transport/addnonindividualrevenuestream.dart';

class RevenueStreamsPage extends StatefulWidget {
  const RevenueStreamsPage({super.key});

  @override
  State<RevenueStreamsPage> createState() => _RevenueStreamsPageState();
}

class _RevenueStreamsPageState extends Base<RevenueStreamsPage> {
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  int rows = 10;
  Duration? executionTime;
  List<int> rowCountList = [10, 20, 30, 40, 50, 100];
  List<RevenueStreams> _streams = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  int _streamsPage = 1;
  List<RevenueSectorsModel> revenueSector = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  DessertDataSourceAsync? _dessertsDataSource;
  final PaginatorController _controller = PaginatorController();
  PageController revenueStreamPageController = PageController();
  String selectedSectorNew = "";
  String selectedSectorIdNew = "";
  String selectedCategoryNew = "";
  String selectedCategoryIdNew = "";
  String selectedOwnership = "";
  String selectedInitSector = "";
  String selectedSector = "";
  String selectedInitSectorId = "";
  String selectedSectorId = "";
  String selectedInitCategory = "";
  String selectedCategory = "";
  String selectedInitCategoryId = "";
  String selectedCategoryId = "";
  bool _dataSourceLoading = false;
  int _initialRow = 0;
  List<String> ownerType = ["Individual", "Non-Individual"];
  List<RevenueSectorsModel> sectorList = <RevenueSectorsModel>[];
  List<RevenueSectorCategoriesFilteredModel> categoryList =
      <RevenueSectorCategoriesFilteredModel>[];
  List<RevenueSectorsModel> sectorListNew = <RevenueSectorsModel>[];
  List<RevenueSectorCategoriesFilteredModel> categoryListNew =
      <RevenueSectorCategoriesFilteredModel>[];

  //get sectors list
  Future<List<RevenueSectorsModel>> getSectors() async {
    List<RevenueSectorsModel> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}revenuesectors");
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
      List<RevenueSectorsModel> sectorsmodel = (items as List)
          .map((data) => RevenueSectorsModel.fromJson(data))
          .toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = sectorsmodel;
      debugPrint(sectorsmodel.toString());
      setState(() {
        sectorList = sectorsmodel;
        selectedInitSector = sectorsmodel.first.name;
        selectedInitCategoryId = sectorsmodel.first.id;
        getCategoriesInit(selectedInitCategoryId);
        // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get sector categories list
  Future<List<RevenueSectorCategoriesFilteredModel>> getCategoriesInit(
      String sectorId) async {
    List<RevenueSectorCategoriesFilteredModel> returnValue = [];
    setState(() {
      categoryList = [];
    });
    var url =
        Uri.parse("${AppConstants.baseUrl}sectorsubtypes/sector/$sectorId");
    debugPrint(url.toString());

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        // 'Authorization': 'Bearer $_authToken',
      },
    );
    debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
        response.body.toString() +
        "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
      List<RevenueSectorCategoriesFilteredModel> categoriesmodel = (items
              as List)
          .map((data) => RevenueSectorCategoriesFilteredModel.fromJson(data))
          .toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = categoriesmodel;
      debugPrint(categoriesmodel.toString());
      setState(() {
        categoryList = categoriesmodel;
        selectedInitCategory = categoriesmodel.first.typename;
        selectedInitCategoryId = categoriesmodel.first.id;
        getStreams(selectedInitCategoryId);
        // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get sector categories list
  Future<List<RevenueSectorCategoriesFilteredModel>> getCategories(
      String sectorId) async {
    setState(() {
      categoryList = [];
    });
    List<RevenueSectorCategoriesFilteredModel> returnValue = [];
    var url =
        Uri.parse("${AppConstants.baseUrl}sectorsubtypes/sector/$sectorId");
    debugPrint(url.toString());

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        // 'Authorization': 'Bearer $_authToken',
      },
    );
    debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
        response.body.toString() +
        "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
      List<RevenueSectorCategoriesFilteredModel> categoriesmodel = (items
              as List)
          .map((data) => RevenueSectorCategoriesFilteredModel.fromJson(data))
          .toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = categoriesmodel;
      debugPrint(categoriesmodel.toString());
      setState(() {
        categoryList = categoriesmodel;
        // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get revenue streams by sectorid
  Future<List<RevenueStreams>> getStreams(String typeId) async {
    setState(() {
      _streams.clear();
    });
    List<RevenueStreams> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl + "revenuestreams/typeid/$typeId");
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
      // RevenueStreamsPaginatedModel incidentsmodel =
      //     RevenueStreamsPaginatedModel.fromJson(items);
      List<RevenueStreams> streams =
          (items as List).map((data) => RevenueStreams.fromJson(data)).toList();

      returnValue = streams;
      setState(() {
        _streams = streams;
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
    getSectors();
    // getCategories("c55ffa94-9f38-11ef-bf99-42010a800002");
    super.initState();
  }

  void sort(
    int columnIndex,
    bool ascending,
  ) {
    var columnName = "Reg No";
    switch (columnIndex) {
      case 1:
        columnName = "Model";
        break;
      case 2:
        columnName = "Color";
        break;
      case 3:
        columnName = "Reg Reference";
        break;
      case 4:
        columnName = "Type";
        break;
      case 5:
        columnName = "Status";
        break;
      case 6:
        columnName = "";
        break;
    }
    _dessertsDataSource!.sort(columnName, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _dessertsDataSource!.dispose();
    super.dispose();
  }

  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Text('Reg No'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Model'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Color'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Reg Reference'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Type'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Status'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text(''),
        // numeric: true,
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
    ];
  }

  // Use global key to avoid rebuilding state of _TitledRangeSelector
  // upon AsyncPaginatedDataTable2 refreshes, e.g. upon page switches
  final GlobalKey _rangeSelectorKey = GlobalKey();

  openSelectBoxOld() {
    return NDialog(
      dialogStyle: DialogStyle(titleDivider: false),
      title: Text(
        "Select to Proceed",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Select Ownership',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffB9B9B9)),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  hintText: '',
                ),
                isExpanded: true,
                hint: Row(
                  children: [
                    new Text(
                      selectedOwnership,
                      style: const TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ownerType.map((item) {
                  return DropdownMenuItem(
                    child: Row(
                      children: [
                        new Text(
                          item,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    value: item,
                  );
                }).toList(),
                onChanged: (newVal) {
                  List itemsList = ownerType.map((item) {
                    if (item == newVal) {
                      setState(() {
                        selectedOwnership = item;
                        // debugPrint(selectedOwnership);
                      });
                    }
                  }).toList();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Select Sector',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffB9B9B9)),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  hintText: '',
                ),
                isExpanded: true,
                hint: Row(
                  children: [
                    new Text(
                      selectedSector,
                      style: const TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: sectorList.map((item) {
                  return DropdownMenuItem(
                    child: Row(
                      children: [
                        new Text(
                          item.name,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    value: item,
                  );
                }).toList(),
                onChanged: (newVal) {
                  List itemsList = sectorList.map((item) async {
                    if (item == newVal) {
                      setState(() {
                        selectedSector = item.name;
                        selectedSectorId = item.id;
                        // debugPrint(selectedSector);
                        // selectedCategory = "";
                        // categoryList = [];
                        getCategories(selectedSectorId);
                      });
                    }
                  }).toList();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffB9B9B9)),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  hintText: '',
                ),
                isExpanded: true,
                hint: Row(
                  children: [
                    new Text(
                      selectedCategory,
                      style: const TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: categoryList.map((item) {
                  return DropdownMenuItem(
                    child: Row(
                      children: [
                        new Text(
                          item.typename,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    value: item,
                  );
                }).toList(),
                onChanged: (newVal) {
                  List itemsList = categoryList.map((item) {
                    if (item == newVal) {
                      setState(() {
                        selectedCategory = item.typename;
                        selectedCategoryId = item.id;
                        // debugPrint(selectedCategory);
                      });
                    }
                  }).toList();
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (selectedOwnership == "Individual") {
                  debugPrint(selectedCategory);
                  debugPrint(selectedSector);
                  Navigator.of(context).pop();
                  revenueStreamPageController.jumpToPage(1);
                  // selectedSector == "Transport"
                  //     ? revenueStreamPageController.jumpToPage(1)
                  //     : selectedSector == "Hospitality"
                  //         ? revenueStreamPageController
                  //             .jumpToPage(3)
                  //         : selectedSector == "Fisheries"
                  //             ? revenueStreamPageController
                  //                 .jumpToPage(5)
                  //             : revenueStreamPageController
                  //                 .jumpToPage(1);
                } else if (selectedOwnership == "Non-Individual") {
                  Navigator.of(context).pop();
                  revenueStreamPageController.jumpToPage(2);

                  // selectedSector == "Transport"
                  //     ? revenueStreamPageController.jumpToPage(2)
                  //     : selectedSector == "Hospitality"
                  //         ? revenueStreamPageController
                  //             .jumpToPage(4)
                  //         : selectedSector == "Fisheries"
                  //             ? revenueStreamPageController
                  //                 .jumpToPage(6)
                  //             : revenueStreamPageController
                  //                 .jumpToPage(2);
                } else {
                  showInfoToast("Please select ownership type.");
                }
              },
              child: Center(
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                      color: AppConstants.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[],
    ).show(context);
  }

  navigateToPage(
      String ownerTypef, sectorName, sectorIdf, categoryName, categoryIdf) {
    debugPrint(ownerTypef);
    debugPrint(sectorName);
    debugPrint(sectorIdf);
    debugPrint(categoryName);
    debugPrint(categoryIdf);
    if (ownerTypef == "Individual") {
      //
      sectorName == "Transport"
          ? context.goNamed("addindividualstreamtransport", pathParameters: {
              'ownerType': selectedOwnership,
              'category': selectedCategoryNew,
              'categoryId': selectedCategoryIdNew,
              'sector': selectedSectorNew,
              'sectorId': selectedSectorIdNew,
            })
          : sectorName == "Hospitality"
              ? revenueStreamPageController.jumpToPage(3)
              : sectorName == "Fisheries"
                  ? revenueStreamPageController.jumpToPage(5)
                  : revenueStreamPageController.jumpToPage(1);

      // Navigator.of(context).pop();
    } else if (ownerTypef == "Non-Individual") {
      //
      sectorName == "Transport"
          ? context.goNamed("addnonindividualstreamtransport", pathParameters: {
              'ownerType': selectedOwnership,
              'category': selectedCategoryNew,
              'categoryId': selectedCategoryIdNew,
              'sector': selectedSectorNew,
              'sectorId': selectedSectorIdNew,
            })
          : sectorName == "Hospitality"
              ? revenueStreamPageController.jumpToPage(4)
              : sectorName == "Fisheries"
                  ? revenueStreamPageController.jumpToPage(6)
                  : revenueStreamPageController.jumpToPage(2);

      // Navigator.of(context).pop();
    } else {
      showInfoToast("Please select ownership type.");
    }
  }

  openSelectBox() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Color sortOptionTwoColor = Colors.white54;
        return StatefulBuilder(
          ///**StatefulBuilder**
          builder: (context, setState) {
            return SimpleDialog(
              title: const Text('Select to Proceed'),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .25,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          'Select Ownership',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffB9B9B9)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffB9B9B9), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            hintText: '',
                          ),
                          isExpanded: true,
                          hint: Row(
                            children: [
                              new Text(
                                selectedOwnership,
                                style: const TextStyle(
                                    // color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: ownerType.map((item) {
                            return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Text(
                                    item,
                                    style: const TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            List itemsList = ownerType.map((item) {
                              if (item == newVal) {
                                setState(() {
                                  selectedOwnership = item;
                                  // debugPrint(selectedOwnership);
                                });
                              }
                            }).toList();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(
                          'Select Sector',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffB9B9B9)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffB9B9B9), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            hintText: '',
                          ),
                          isExpanded: true,
                          hint: Row(
                            children: [
                              new Text(
                                selectedSectorNew,
                                style: const TextStyle(
                                    // color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: sectorList.map((item) {
                            return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Text(
                                    item.name,
                                    style: const TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            List itemsList = sectorList.map((item) async {
                              if (item == newVal) {
                                setState(() {
                                  selectedSectorNew = item.name;
                                  selectedSectorIdNew = item.id;
                                  // debugPrint(selectedSector);
                                  // selectedCategory = "";
                                  // categoryList = [];
                                  // getCategories(selectedSectorId);
                                });
                                var url = Uri.parse(
                                    "${AppConstants.baseUrl}sectorsubtypes/sector/$selectedSectorIdNew");
                                debugPrint(url.toString());

                                var response = await http.get(
                                  url,
                                  headers: {
                                    "Content-Type": "Application/json",
                                    // 'Authorization': 'Bearer $_authToken',
                                  },
                                );
                                debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
                                    response.body.toString() +
                                    "+++++++");
                                if (response.statusCode == 200) {
                                  final items = json.decode(response.body);
                                  // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
                                  List<RevenueSectorCategoriesFilteredModel>
                                      categoriesmodel = (items as List)
                                          .map((data) =>
                                              RevenueSectorCategoriesFilteredModel
                                                  .fromJson(data))
                                          .toList();

                                  debugPrint(categoriesmodel.toString());
                                  setState(() {
                                    categoryListNew = categoriesmodel;
                                    // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
                                  });
                                }
                              }
                            }).toList();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(
                          'Select Category',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffB9B9B9)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffB9B9B9), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            hintText: '',
                          ),
                          isExpanded: true,
                          hint: Row(
                            children: [
                              new Text(
                                selectedCategoryNew,
                                style: const TextStyle(
                                    // color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: categoryListNew.map((item) {
                            return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Text(
                                    item.typename,
                                    style: const TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            List itemsList = categoryListNew.map((item) {
                              if (item == newVal) {
                                setState(() {
                                  selectedCategoryNew = item.typename;
                                  selectedCategoryIdNew = item.id;
                                  debugPrint(selectedCategoryNew);
                                });
                              }
                            }).toList();
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          navigateToPage(
                            selectedOwnership,
                            selectedSectorNew,
                            selectedSectorIdNew,
                            selectedCategoryNew,
                            selectedCategoryIdNew,
                          );
                        },
                        child: Center(
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                                color: AppConstants.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: revenueStreamPageController,
        physics: const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: false,
        children: [
          // page 0
          BootstrapContainer(
            fluid: true,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
            ),
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Column(children: [
                    SizedBox(height: 8),
                    BootstrapRow(
                      children: <BootstrapCol>[
                        BootstrapCol(
                          sizes: "col-lg-3 col-md-12 col-sm-12",
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                            title: Text(
                              'Select Sector',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: SizedBox(
                              height: 38,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffB9B9B9)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xffB9B9B9), width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  hintText: '',
                                ),
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    new Text(
                                      selectedInitSector,
                                      style: const TextStyle(
                                          // color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: sectorList.map((item) {
                                  return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Text(
                                          item.name,
                                          style: const TextStyle(
                                              // color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  List itemsList = sectorList.map((item) {
                                    if (item == newVal) {
                                      setState(() async {
                                        selectedInitSector = item.name;
                                        selectedInitSectorId = item.id;
                                        debugPrint(selectedInitSector);
                                        selectedInitCategory = "";
                                        categoryList = [];
                                        getCategoriesInit(selectedInitSectorId);
                                      });
                                    }
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          sizes: "col-lg-3 col-md-12 col-sm-12",
                          child: ListTile(
                            title: Text(
                              'Select Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: SizedBox(
                              height: 38,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffB9B9B9)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xffB9B9B9), width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  hintText: '',
                                ),
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    new Text(
                                      selectedInitCategory,
                                      style: const TextStyle(
                                          // color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: categoryList.map((item) {
                                  return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Text(
                                          item.typename,
                                          style: const TextStyle(
                                              // color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  List itemsList = categoryList.map((item) {
                                    if (item == newVal) {
                                      setState(() {
                                        selectedInitCategory = item.typename;
                                        selectedInitCategoryId = item.id;
                                        getStreams(selectedInitCategoryId);
                                        debugPrint(selectedCategory);
                                      });
                                    }
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          sizes: "col-lg-3 col-md-0 col-sm-0",
                          child: Container(),
                        ),
                        BootstrapCol(
                          sizes: "col-lg-3 col-md-12 col-sm-12",
                          child: Container(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: TextButton.icon(
                              onPressed: () {
                                openSelectBox();
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppConstants.secondaryColor,
                                size: 20,
                              ),
                              label: const Text(
                                'New Stream',
                                style: TextStyle(
                                    color: AppConstants.secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: AppConstants.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
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
                              label: const Text("CRAIN"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _streams.sort((userA, userB) => userB
                                        .regreferenceno
                                        .compareTo(userA.regreferenceno));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _streams.sort((userA, userB) => userA
                                        .regreferenceno
                                        .compareTo(userB.regreferenceno));
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
                                    _streams.sort((userA, userB) => userB
                                        .businessname
                                        .compareTo(userA.businessname));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _streams.sort((userA, userB) => userA
                                        .businessname
                                        .compareTo(userB.businessname));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: const Text("Category"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    _streams.sort((userA, userB) =>
                                        userB.ownerid.compareTo(userA.vin));
                                  } else {
                                    _isAscending = true;
                                    _streams.sort((userA, userB) =>
                                        userA.ownerid.compareTo(userB.vin));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text("Levy"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _streams.sort((userA, userB) => userB
                                        .tarrifamount
                                        .compareTo(userA.tarrifamount));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _streams.sort((userA, userB) => userA
                                        .tarrifamount
                                        .compareTo(userB.tarrifamount));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: const Text("Due Date"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _streams.sort((userA, userB) => userB
                                        .nextrenewaldate
                                        .compareTo(userA.nextrenewaldate));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _streams.sort((userA, userB) => userA
                                        .nextrenewaldate
                                        .compareTo(userB.nextrenewaldate));
                                  }
                                });
                              },
                            ),
                            DataColumn(
                              label: const Text("Status"),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    // sort the product list in Ascending, order by Price
                                    _streams.sort((userA, userB) =>
                                        userB.status.compareTo(userA.status));
                                  } else {
                                    _isAscending = true;
                                    // sort the product list in Descending, order by Price
                                    _streams.sort((userA, userB) =>
                                        userA.status.compareTo(userB.status));
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
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          "${element.businessname}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppConstants.primaryColor,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          element.type.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          "${element.tarrifamount}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppConstants.primaryColor,
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          "${dateFormat.format(element.nextrenewaldate)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppConstants.primaryColor,
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
                                                ? "Inactive"
                                                : element.status.toString() ==
                                                        "1"
                                                    ? "Active"
                                                    : "Disabled",
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                      DataCell(Text("No Revenue Streams")),
                                      DataCell(Text("")),
                                      DataCell(Text("")),
                                    ],
                                  )
                                ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
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
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
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
                          Text("1 - ${_streams.length} of $_rowsPerPage"),
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
            ],
          ),
          // page 1
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AddIndividualRevenueStreamPage(
                    ownerType: selectedOwnership,
                    sector: selectedSectorNew,
                    sectorId: selectedSectorIdNew,
                    category: selectedCategoryNew,
                    categoryId: selectedCategoryIdNew,
                  )),
            ),
          ),
          // page 2
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AddNonIndividualRevenueStreamPage(
                    ownerType: selectedOwnership,
                    sector: selectedSector,
                    sectorId: selectedSectorId,
                    category: selectedCategory,
                    categoryId: selectedCategoryId,
                  )),
            ),
          ),
          // page 3 individual hospitality
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AddIndividualHospitalityRevenueStreamPage(
                    ownerType: selectedOwnership,
                    sector: selectedSector,
                    sectorId: selectedSectorId,
                    category: selectedCategory,
                    categoryId: selectedCategoryId,
                  )),
            ),
          ),
          // page 4 non individual hospitality
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AddNonIndividualHospitalityRevenueStreamPage(
                    ownerType: selectedOwnership,
                    sector: selectedSector,
                    sectorId: selectedSectorId,
                    category: selectedCategory,
                    categoryId: selectedCategoryId,
                  )),
            ),
          ),
          // page 5 individual fish
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AddIndividualFishRevenueStreamPage(
                    ownerType: selectedOwnership,
                    sector: selectedSector,
                    sectorId: selectedSectorId,
                    category: selectedCategory,
                    categoryId: selectedCategoryId,
                  )),
            ),
          ),
          // page 6 non individual fish
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AddNonIndividualFishRevenueStreamPage(
                    ownerType: selectedOwnership,
                    sector: selectedSector,
                    sectorId: selectedSectorId,
                    category: selectedCategory,
                    categoryId: selectedCategoryId,
                  )),
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

// Row(
//                   children: [
//                     const Text(
//                       'Home',
//                       style: TextStyle(
//                           color: AppConstants.primaryColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16),
//                     ),
//                     const SizedBox(
//                       width: 8.0,
//                     ),
//                     const Icon(
//                       Icons.arrow_forward_ios,
//                       color: AppConstants.primaryColor,
//                       size: 20,
//                     ),
//                     const SizedBox(
//                       width: 8.0,
//                     ),
//                     const Text(
//                       'Revenuey',
//                       style: TextStyle(
//                           color: AppConstants.primaryColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16),
//                     ),
//                     const SizedBox(
//                       width: 8.0,
//                     ),
//                   ],
//                 ),
