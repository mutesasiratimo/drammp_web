// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:entebbe_dramp_web/models/tarriffs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:go_router/go_router.dart';
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
  String selectedFrequency = "";
  List<String> frequencyType = [
    "Weekly",
    "Monthly",
    "Quarterly",
    "Annual",
    "N/A"
  ];
  TextEditingController tarrifNameController = TextEditingController(),
      categoryNameController = TextEditingController(),
      frequencyDaysController = TextEditingController(),
      amountController = TextEditingController(),
      ownerPhoneController = TextEditingController();

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

  //SHOW DIALOG FOR TARRIF DETAILS
  _showTarrifDetails(TarriffsModel tarrif) async {
    setState(() {
      tarrifNameController.text = tarrif.purpose;
      categoryNameController.text = tarrif.sectorsubtypename;
      selectedFrequency = tarrif.frequency;
      frequencyDaysController.text = tarrif.frequencydays.toString();
      amountController.text = tarrif.amount.toString();
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tarrif Details",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: () {
                    context.goNamed("settings", pathParameters: {});
                    // Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ))
            ],
          ),
          content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: 400,
              child: BootstrapContainer(
                fluid: true,
                decoration: BoxDecoration(),
                children: [
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Tarrif',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: tarrifNameController,
                                enabled: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Sector Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: categoryNameController,
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: ListTile(
                          title: Text(
                            'Select Frequency',
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
                                    vertical: 0, horizontal: 4),
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
                                    selectedFrequency,
                                    style: const TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: frequencyType.map((item) {
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
                                List itemsList = frequencyType.map((item) {
                                  if (item == newVal) {
                                    setState(() {
                                      selectedFrequency = item;
                                    });
                                  }
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Frequency Days',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: frequencyDaysController,
                                enabled: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: amountController,
                                enabled: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8.0),
                    child: ListTile(
                      leading: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: CupertinoSwitch(
                        value: tarrif.status == "1",
                        onChanged: (value) {
                          // setState(() {
                          // });
                        },
                        trackColor: Colors.red,
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[],
        );
      },
    );
  }

  //SHOW DIALOG TO CREATE TARRIF
  _createTarrif() async {
    setState(() {
      tarrifNameController.clear();
      categoryNameController.clear();
      selectedFrequency = "";
      frequencyDaysController.clear();
      amountController.clear();
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "New Tarrif",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: () {
                    context.goNamed("settings", pathParameters: {});
                    // Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ))
            ],
          ),
          content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: 400,
              child: BootstrapContainer(
                fluid: true,
                decoration: BoxDecoration(),
                children: [
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Tarrif',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: tarrifNameController,
                                enabled: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Sector Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: categoryNameController,
                                enabled: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: ListTile(
                          title: Text(
                            'Select Frequency',
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
                                    vertical: 0, horizontal: 4),
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
                                    selectedFrequency,
                                    style: const TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: frequencyType.map((item) {
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
                                List itemsList = frequencyType.map((item) {
                                  if (item == newVal) {
                                    setState(() {
                                      selectedFrequency = item;
                                    });
                                  }
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Frequency Days',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: categoryNameController,
                                enabled: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  BootstrapRow(
                    children: [
                      BootstrapCol(
                        sizes: "col-12",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            dense: true,
                            visualDensity: VisualDensity(vertical: 3),
                            title: Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Container(
                              height: 38,
                              child: TextFormField(
                                controller: categoryNameController,
                                enabled: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  disabledBorder: OutlineInputBorder(
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
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[],
        );
      },
    );
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TextButton.icon(
                              onPressed: () {
                                _createTarrif();
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppConstants.secondaryColor,
                                size: 20,
                              ),
                              label: const Text(
                                'New Tarrif',
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
                        ],
                      ),
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
                                            onPressed: () {
                                              _showTarrifDetails(element);
                                            },
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
