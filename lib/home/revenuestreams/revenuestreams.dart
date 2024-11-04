// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:entebbe_dramp_web/config/base.dart';
import 'package:entebbe_dramp_web/home/revenuestreams/transport/addindividualrevenuestream.dart';
// import 'package:entebbe_dramp_web/home/appbar.dart';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../config/custom_pager.dart';
import '../../models/revenuesectorcategories.dart';
import 'data_sources.dart';
import '../../config/nav_helper.dart';
import '../../models/revenuesector.dart';
import '../appbar.dart';
import 'package:http/http.dart' as http;

class RevenueStreamsPage extends StatefulWidget {
  const RevenueStreamsPage({super.key});

  @override
  State<RevenueStreamsPage> createState() => _RevenueStreamsPageState();
}

class _RevenueStreamsPageState extends Base<RevenueStreamsPage> {
  List<RevenueSectorsModel> revenueSector = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  DessertDataSourceAsync? _dessertsDataSource;
  final PaginatorController _controller = PaginatorController();
  PageController revenueStreamPageController = PageController();
  String selectedOwnership = "";
  String selectedSector = "";
  String selectedCategory = "";
  bool _dataSourceLoading = false;
  int _initialRow = 0;
  List<String> ownerType = ["Individual", "Non-Individual"];
  List<RevenueSectorsModel> sectorList = <RevenueSectorsModel>[];
  List<RevenueSectorCategoriesModel> categoryList =
      <RevenueSectorCategoriesModel>[];

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
        // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get sector categories list
  Future<List<RevenueSectorCategoriesModel>> getCategories() async {
    List<RevenueSectorCategoriesModel> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}sectorsubtypes");
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
      List<RevenueSectorCategoriesModel> categoriesmodel = (items as List)
          .map((data) => RevenueSectorCategoriesModel.fromJson(data))
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

  @override
  void initState() {
    getSectors();
    getCategories();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // initState is to early to access route options, context is invalid at that stage
    _dessertsDataSource ??= getCurrentRouteOption(context) == noData
        ? DessertDataSourceAsync.empty()
        : getCurrentRouteOption(context) == asyncErrors
            ? DessertDataSourceAsync.error()
            : DessertDataSourceAsync();

    if (getCurrentRouteOption(context) == goToLast) {
      _dataSourceLoading = true;
      _dessertsDataSource!.getTotalRecords().then((count) => setState(() {
            _initialRow = count - _rowsPerPage;
            _dataSourceLoading = false;
          }));
    }
    super.didChangeDependencies();
  }

  void sort(
    int columnIndex,
    bool ascending,
  ) {
    var columnName = "Code";
    switch (columnIndex) {
      case 1:
        columnName = "Name";
        break;
      case 2:
        columnName = "Description";
        break;
      case 3:
        columnName = "Sub-types";
        break;
      case 4:
        columnName = "Status";
        break;
      case 5:
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
        label: const Text('Code'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Name'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Description'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Sub-types'),
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

  openSelectBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select to proceed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      'Select Ownership',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffB9B9B9)),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffB9B9B9), width: 1.0),
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
                                debugPrint(selectedOwnership);
                              });
                            }
                          }).toList();
                        },
                      ),
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
                    subtitle: Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffB9B9B9)),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffB9B9B9), width: 1.0),
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
                          List itemsList = sectorList.map((item) {
                            if (item == newVal) {
                              setState(() {
                                selectedSector = item.name;
                                debugPrint(selectedSector);
                              });
                            }
                          }).toList();
                        },
                      ),
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
                    subtitle: Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffB9B9B9)),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffB9B9B9), width: 1.0),
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
                                debugPrint(selectedCategory);
                              });
                            }
                          }).toList();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    // width: 200,
                    // color: Colors.grey[200],
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        revenueStreamPageController.jumpToPage(1);
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
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Last ppage example uses extra API call to get the number of items in datasource
    if (_dataSourceLoading) return const SizedBox();
    //TO DO: FOR PRODUCTS COLUMN, SHOW "3 Proudcts" AS CLICKABLE LINK, WITH POPUP TO SHOW SUBTYPES.
    return Scaffold(
      appBar: CustomAppBar(
        title: "Revenue Streams",
        backgroundColor: Colors.white,
        actions: [
          accountToggle(context),
        ],
      ),
      body: PageView(
        controller: revenueStreamPageController,
        physics: const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: false,
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              child: Stack(alignment: Alignment.bottomCenter, children: [
                AsyncPaginatedDataTable2(
                    horizontalMargin: 20,
                    checkboxHorizontalMargin: 12,
                    columnSpacing: 0,
                    wrapInCard: false,
                    header: Row(
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
                              openSelectBox();
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
                                  'New',
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
                    rowsPerPage: _rowsPerPage,
                    autoRowsToHeight:
                        getCurrentRouteOption(context) == autoRows,
                    // Default - do nothing, autoRows - goToLast, other - goToFirst
                    pageSyncApproach: getCurrentRouteOption(context) == dflt
                        ? PageSyncApproach.doNothing
                        : getCurrentRouteOption(context) == autoRows
                            ? PageSyncApproach.goToLast
                            : PageSyncApproach.goToFirst,
                    minWidth: 800,
                    fit: FlexFit.tight,
                    border: TableBorder(
                        top:
                            BorderSide(color: Colors.grey.shade50, width: 0.05),
                        bottom:
                            BorderSide(color: Colors.grey.shade50, width: 0.05),
                        // left: BorderSide(color: Colors.grey[300]!, width: 0.2),
                        // right: BorderSide(color: Colors.grey[300]!, width: 0.5),
                        // verticalInside: BorderSide(color: Colors.grey[300]!),
                        horizontalInside: BorderSide(
                            color: Colors.grey.shade50, width: 0.05)),
                    onRowsPerPageChanged: (value) {
                      // No need to wrap into setState, it will be called inside the widget
                      // and trigger rebuild
                      //setState(() {
                      print('Row per page changed to $value');
                      _rowsPerPage = value!;
                      //});
                    },
                    initialFirstRowIndex: _initialRow,
                    onPageChanged: (rowIndex) {
                      //print(rowIndex / _rowsPerPage);
                    },
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    sortArrowIcon: Icons.keyboard_arrow_up,
                    sortArrowAnimationDuration: const Duration(milliseconds: 0),
                    onSelectAll: (select) => select != null && select
                        ? (getCurrentRouteOption(context) != selectAllPage
                            ? _dessertsDataSource!.selectAll()
                            : _dessertsDataSource!.selectAllOnThePage())
                        : (getCurrentRouteOption(context) != selectAllPage
                            ? _dessertsDataSource!.deselectAll()
                            : _dessertsDataSource!.deselectAllOnThePage()),
                    controller: _controller,
                    hidePaginator: getCurrentRouteOption(context) == custPager,
                    columns: _columns,
                    empty: Center(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.grey[200],
                            child: const Text('No data'))),
                    loading: _Loading(),
                    errorBuilder: (e) => _ErrorAndRetry(e.toString(),
                        () => _dessertsDataSource!.refreshDatasource()),
                    source: _dessertsDataSource!),
                if (getCurrentRouteOption(context) == custPager)
                  Positioned(bottom: 16, child: CustomPager(_controller))
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: AddIndividualRevenueStreamPage(
                    ownerType: selectedOwnership,
                    category: selectedCategory,
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