// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:entebbe_dramp_web/models/revenuesector.dart';
import 'package:flutter/material.dart';
import '../../config/constants.dart';

class AddSectorSubtypePage extends StatefulWidget {
  const AddSectorSubtypePage({super.key});

  @override
  State<AddSectorSubtypePage> createState() => _AddSectorSubtypePageState();
}

class _AddSectorSubtypePageState extends State<AddSectorSubtypePage> {
  List<RevenueSectorsModel> sectorList = <RevenueSectorsModel>[];
  String selectedSector = "Select Sector";

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

  @override
  void initState() {
    getSectors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Add New Sector Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
                    enabled: true,
                    decoration: const InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB9B9B9)),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      hintText: 'TRAN002',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    'Code',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB9B9B9)),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      hintText: 'e.g Transport',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    'Parent Sector',
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
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    'Sub-types: Type to search',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
                    minLines: 3,
                    maxLines: 3,
                    style: TextStyle(color: Colors.red.shade100),
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
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: 250,
                // color: Colors.grey[200],
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Add Now',
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
