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
import 'accommodation/addindividualrensporthospitalityrevenuestream.dart';
import 'accommodation/addnonindividualhospitalityrevenuestream.dart';
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
    // debugPrint(url.toString());
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
    // debugPrint("++++++RESPONSE SECTORS" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
      List<RevenueSectorsModel> sectorsmodel = (items as List)
          .map((data) => RevenueSectorsModel.fromJson(data))
          .toList();

      // List<RevenueSectorsModel> sectorsmodel = usersobj;
      // List<UserItem> usersmodel = usersobj.items;

      returnValue = sectorsmodel;
      // debugPrint(sectorsmodel.toString());
      setState(() {
        sectorList = sectorsmodel;
        selectedInitSector = sectorsmodel.first.name;
        selectedInitSectorId = sectorsmodel.first.id;
        getCategoriesInit(selectedInitSectorId);
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
    // debugPrint(url.toString());

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        // 'Authorization': 'Bearer $_authToken',
      },
    );
    // debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
    //     response.body.toString() +
    //     "+++++++");
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
      // debugPrint(categoriesmodel.toString());
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
    // debugPrint(url.toString());

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        // 'Authorization': 'Bearer $_authToken',
      },
    );
    // debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
    //     response.body.toString() +
    //     "+++++++");
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
      // debugPrint(categoriesmodel.toString());
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
    // print("++++++" + response.body.toString() + "+++++++");
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

  @override
  void dispose() {
    super.dispose();
  }

  showStreamDetails(RevenueStreams stream) async {
    // await showDialog<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     Color sortOptionTwoColor = Colors.white54;
    //     return StatefulBuilder(
    //       ///**StatefulBuilder**
    //       builder: (context, setState) {
    //         return SimpleDialog(
    //           title: const Text('Select to Proceed'),
    //           children: [
    //             Container(
    //               width: MediaQuery.of(context).size.width * .25,
    //               padding: EdgeInsets.all(16.0),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   SizedBox(height: 10),
    //                   ListTile(
    //                     title: Text(
    //                       'Select Ownership',
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                     subtitle: DropdownButtonFormField(
    //                       decoration: InputDecoration(
    //                         border: OutlineInputBorder(
    //                           borderSide: BorderSide(color: Color(0xffB9B9B9)),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(4)),
    //                         ),
    //                         enabledBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: Color(0xffB9B9B9), width: 1.0),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(4)),
    //                         ),
    //                         hintText: '',
    //                       ),
    //                       isExpanded: true,
    //                       hint: Row(
    //                         children: [
    //                           new Text(
    //                             selectedOwnership,
    //                             style: const TextStyle(
    //                                 // color: Colors.grey,
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.w400),
    //                           ),
    //                         ],
    //                       ),
    //                       icon: const Icon(Icons.keyboard_arrow_down),
    //                       items: ownerType.map((item) {
    //                         return DropdownMenuItem(
    //                           child: Row(
    //                             children: [
    //                               new Text(
    //                                 item,
    //                                 style: const TextStyle(
    //                                     // color: Colors.grey,
    //                                     fontSize: 18,
    //                                     fontWeight: FontWeight.w400),
    //                               ),
    //                             ],
    //                           ),
    //                           value: item,
    //                         );
    //                       }).toList(),
    //                       onChanged: (newVal) {
    //                         List itemsList = ownerType.map((item) {
    //                           if (item == newVal) {
    //                             setState(() {
    //                               selectedOwnership = item;
    //                               // debugPrint(selectedOwnership);
    //                             });
    //                           }
    //                         }).toList();
    //                       },
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   ListTile(
    //                     title: Text(
    //                       'Select Sector',
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                     subtitle: DropdownButtonFormField(
    //                       decoration: InputDecoration(
    //                         border: OutlineInputBorder(
    //                           borderSide: BorderSide(color: Color(0xffB9B9B9)),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(4)),
    //                         ),
    //                         enabledBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: Color(0xffB9B9B9), width: 1.0),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(4)),
    //                         ),
    //                         hintText: '',
    //                       ),
    //                       isExpanded: true,
    //                       hint: Row(
    //                         children: [
    //                           new Text(
    //                             selectedSectorNew,
    //                             style: const TextStyle(
    //                                 // color: Colors.grey,
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.w400),
    //                           ),
    //                         ],
    //                       ),
    //                       icon: const Icon(Icons.keyboard_arrow_down),
    //                       items: sectorList.map((item) {
    //                         return DropdownMenuItem(
    //                           child: Row(
    //                             children: [
    //                               new Text(
    //                                 item.name,
    //                                 style: const TextStyle(
    //                                     // color: Colors.grey,
    //                                     fontSize: 18,
    //                                     fontWeight: FontWeight.w400),
    //                               ),
    //                             ],
    //                           ),
    //                           value: item,
    //                         );
    //                       }).toList(),
    //                       onChanged: (newVal) {
    //                         List itemsList = sectorList.map((item) async {
    //                           if (item == newVal) {
    //                             setState(() {
    //                               selectedSectorNew = item.name;
    //                               selectedSectorIdNew = item.id;
    //                               // debugPrint(selectedSector);
    //                               // selectedCategory = "";
    //                               // categoryList = [];
    //                               // getCategories(selectedSectorId);
    //                             });
    //                             var url = Uri.parse(
    //                                 "${AppConstants.baseUrl}sectorsubtypes/sector/$selectedSectorIdNew");
    //                             // debugPrint(url.toString());

    //                             var response = await http.get(
    //                               url,
    //                               headers: {
    //                                 "Content-Type": "Application/json",
    //                                 // 'Authorization': 'Bearer $_authToken',
    //                               },
    //                             );
    //                             // debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
    //                             //     response.body.toString() +
    //                             //     "+++++++");
    //                             if (response.statusCode == 200) {
    //                               final items = json.decode(response.body);
    //                               // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
    //                               List<RevenueSectorCategoriesFilteredModel>
    //                                   categoriesmodel = (items as List)
    //                                       .map((data) =>
    //                                           RevenueSectorCategoriesFilteredModel
    //                                               .fromJson(data))
    //                                       .toList();

    //                               // debugPrint(categoriesmodel.toString());
    //                               setState(() {
    //                                 categoryListNew = categoriesmodel;
    //                                 // debugPrint(_users.length.toString() + "+++++++++++++++++++===========");
    //                               });
    //                             }
    //                           }
    //                         }).toList();
    //                       },
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   ListTile(
    //                     title: Text(
    //                       'Select Category',
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                     subtitle: DropdownButtonFormField(
    //                       decoration: InputDecoration(
    //                         border: OutlineInputBorder(
    //                           borderSide: BorderSide(color: Color(0xffB9B9B9)),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(4)),
    //                         ),
    //                         enabledBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: Color(0xffB9B9B9), width: 1.0),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(4)),
    //                         ),
    //                         hintText: '',
    //                       ),
    //                       isExpanded: true,
    //                       hint: Row(
    //                         children: [
    //                           new Text(
    //                             selectedCategoryNew,
    //                             style: const TextStyle(
    //                                 // color: Colors.grey,
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.w400),
    //                           ),
    //                         ],
    //                       ),
    //                       icon: const Icon(Icons.keyboard_arrow_down),
    //                       items: categoryListNew.map((item) {
    //                         return DropdownMenuItem(
    //                           child: Row(
    //                             children: [
    //                               new Text(
    //                                 item.typename,
    //                                 style: const TextStyle(
    //                                     // color: Colors.grey,
    //                                     fontSize: 18,
    //                                     fontWeight: FontWeight.w400),
    //                               ),
    //                             ],
    //                           ),
    //                           value: item,
    //                         );
    //                       }).toList(),
    //                       onChanged: (newVal) {
    //                         List itemsList = categoryListNew.map((item) {
    //                           if (item == newVal) {
    //                             setState(() {
    //                               selectedCategoryNew = item.typename;
    //                               selectedCategoryIdNew = item.id;
    //                               // debugPrint(selectedCategoryNew);
    //                             });
    //                           }
    //                         }).toList();
    //                       },
    //                     ),
    //                   ),
    //                   SizedBox(height: 30),
    //                   ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pop();
    //                       navigateToPage(
    //                         selectedOwnership,
    //                         selectedSectorNew,
    //                         selectedSectorIdNew,
    //                         selectedCategoryNew,
    //                         selectedCategoryIdNew,
    //                       );
    //                     },
    //                     child: Center(
    //                       child: const Text(
    //                         'Proceed',
    //                         style: TextStyle(
    //                             color: AppConstants.secondaryColor,
    //                             fontWeight: FontWeight.w500,
    //                             fontSize: 16),
    //                       ),
    //                     ),
    //                     style: ElevatedButton.styleFrom(
    //                       shape: const StadiumBorder(),
    //                       backgroundColor: AppConstants.primaryColor,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   },
    // );
    await NDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Revenue Stream Details"),
        ],
      ),
      content: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width * .65,
        child: BootstrapContainer(
          children: [
            BootstrapRow(
              children: <BootstrapCol>[
                BootstrapCol(
                  sizes: "col-sm-12 col-md-12 col-lg-6",
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Name: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.businessname}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Revenue Assurance No: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.regreferenceno}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Category: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.type}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Address/Stage: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.divisionid}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Date Registered: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.datecreated}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
                BootstrapCol(
                  sizes: "col-sm-12 col-md-12 col-lg-6",
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Amount Due: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.tarrifamount}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Payment Frequency: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.tarriffrequency}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Last Payment Date: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.lastrenewaldate}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: "Next Due Date: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "${stream.nextrenewaldate}",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
            child: MaterialButton(
          child: const Text(
            "Close",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: AppConstants.primaryColor,
        )),
      ],
    ).show(context);
  }

  navigateToPage(
      String ownerTypef, sectorName, sectorIdf, categoryName, categoryIdf) {
    // debugPrint(ownerTypef);
    // debugPrint(sectorName);
    // debugPrint(sectorIdf);
    // debugPrint(categoryName);
    // debugPrint(categoryIdf);
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
              ? context
                  .goNamed("addindividualstreamhospitality", pathParameters: {
                  'ownerType': selectedOwnership,
                  'category': selectedCategoryNew,
                  'categoryId': selectedCategoryIdNew,
                  'sector': selectedSectorNew,
                  'sectorId': selectedSectorIdNew,
                })
              : sectorName == "Property" || sectorName == "Kitooro Taxi Park"
                  ? context
                      .goNamed("addindividualstreamproperty", pathParameters: {
                      'ownerType': selectedOwnership,
                      'category': selectedCategoryNew,
                      'categoryId': selectedCategoryIdNew,
                      'sector': selectedSectorNew,
                      'sectorId': selectedSectorIdNew,
                    })
                  : sectorName == "Fisheries"
                      ? context.goNamed("addindividualstreamfisheries",
                          pathParameters: {
                              'ownerType': selectedOwnership,
                              'category': selectedCategoryNew,
                              'categoryId': selectedCategoryIdNew,
                              'sector': selectedSectorNew,
                              'sectorId': selectedSectorIdNew,
                            })
                      : context.goNamed("revenuestreams");

      // Navigator.of(context).pop();
    } else if (ownerTypef == "Non-Individual") {
      sectorName == "Transport"
          ? context.goNamed("addnonindividualstreamtransport", pathParameters: {
              'ownerType': selectedOwnership,
              'category': selectedCategoryNew,
              'categoryId': selectedCategoryIdNew,
              'sector': selectedSectorNew,
              'sectorId': selectedSectorIdNew,
            })
          : sectorName == "Hospitality"
              ? context.goNamed("addnonindividualstreamhospitality",
                  pathParameters: {
                      'ownerType': selectedOwnership,
                      'category': selectedCategoryNew,
                      'categoryId': selectedCategoryIdNew,
                      'sector': selectedSectorNew,
                      'sectorId': selectedSectorIdNew,
                    })
              : sectorName == "Property" || sectorName == "Kitooro Taxi Park"
                  ? context.goNamed("addnonindividualstreamproperty",
                      pathParameters: {
                          'ownerType': selectedOwnership,
                          'category': selectedCategoryNew,
                          'categoryId': selectedCategoryIdNew,
                          'sector': selectedSectorNew,
                          'sectorId': selectedSectorIdNew,
                        })
                  : sectorName == "Fisheries"
                      ? context.goNamed("addnonindividualstreamfisheries",
                          pathParameters: {
                              'ownerType': selectedOwnership,
                              'category': selectedCategoryNew,
                              'categoryId': selectedCategoryIdNew,
                              'sector': selectedSectorNew,
                              'sectorId': selectedSectorIdNew,
                            })
                      : context.goNamed("revenuestreams");

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
                                // debugPrint(url.toString());

                                var response = await http.get(
                                  url,
                                  headers: {
                                    "Content-Type": "Application/json",
                                    // 'Authorization': 'Bearer $_authToken',
                                  },
                                );
                                // debugPrint("++++++RESPONSE SECTORS CATEGORIES" +
                                //     response.body.toString() +
                                //     "+++++++");
                                if (response.statusCode == 200) {
                                  final items = json.decode(response.body);
                                  // RevenueSectorsModel sectorrsobj = RevenueSectorsModel.fromJson(items);
                                  List<RevenueSectorCategoriesFilteredModel>
                                      categoriesmodel = (items as List)
                                          .map((data) =>
                                              RevenueSectorCategoriesFilteredModel
                                                  .fromJson(data))
                                          .toList();

                                  // debugPrint(categoriesmodel.toString());
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
                                  // debugPrint(selectedCategoryNew);
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
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Card(
                  // color: Colors.white,
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
                                        // debugPrint(selectedInitSector);
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
                                        // debugPrint(selectedCategory);
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
                            DataColumn(
                              label: const Text("More"),
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
                                              fontSize: 12),
                                        )),
                                        DataCell(Text(
                                          "${element.businessname}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // color: AppConstants.primaryColor,
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
                                              // color: AppConstants.primaryColor,
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
                                        DataCell(IconButton(
                                            onPressed: () {
                                              showStreamDetails(element);
                                            },
                                            icon: Icon(Icons.more_horiz))),
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
