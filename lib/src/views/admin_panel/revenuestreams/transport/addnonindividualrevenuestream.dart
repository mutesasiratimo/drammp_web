// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/base.dart';
import '../../../../../config/constants.dart';
import '../../../../../config/functions.dart';

class AddNonIndividualRevenueStreamPage extends StatefulWidget {
  final String category;
  final String ownerType;
  final String categoryId;
  final String sector;
  final String sectorId;
  const AddNonIndividualRevenueStreamPage({
    super.key,
    required this.category,
    required this.ownerType,
    required this.categoryId,
    required this.sector,
    required this.sectorId,
  });

  @override
  State<AddNonIndividualRevenueStreamPage> createState() =>
      _AddNonIndividualRevenueStreamPageState();
}

class _AddNonIndividualRevenueStreamPageState
    extends Base<AddNonIndividualRevenueStreamPage> {
  PageController addRevenueStreamPageController = PageController();
  int page = 0;
  int counter = 3;
  List list = [0, 1, 2, 3];
  String selectedOwnership = "";
  String selectedDoesOwnerOperate = "";
  List<String> ownerType = ["Individual", "Non-Individual"];
  List<String> doesOwnerOperate = ["No", "Yes"];
  List<String> districts = [];
  List<String> counties = [];
  List<String> subcounties = [];
  List<String> parishes = [];
  List<String> villages = [];
  bool responseLoading = true;
  PhoneNumber ownerNumber = PhoneNumber(isoCode: 'UG');
  PhoneNumber driverNumber = PhoneNumber(isoCode: 'UG');
  PhoneNumber associateNumber = PhoneNumber(isoCode: 'UG');
  String selectedOwnerDistrict = "",
      selectedOwnerCounty = "",
      selectedOwnerSubcounty = "",
      selectedOwnerParish = "",
      selectedOwnerVillage = "";
  String selectedDriverDistrict = "",
      selectedDriverCounty = "",
      selectedDriverSubcounty = "",
      selectedDriverParish = "",
      selectedDriverVillage = "";
  String selectedAssociateDistrict = "",
      selectedAssociateCounty = "",
      selectedAssociateSubcounty = "",
      selectedAssociateParish = "",
      selectedAssociateVillage = "";
  String selectedStageDistrict = "",
      selectedStageCounty = "",
      selectedStageSubcounty = "",
      selectedStageParish = "",
      selectedStageVillage = "";
  TextEditingController ownerTinController = TextEditingController(),
      ownerBrnController = TextEditingController(),
      entityNameController = TextEditingController(),
      ownerEmailController = TextEditingController();
  TextEditingController associateNinController = TextEditingController(),
      associatePassportNumberController = TextEditingController(),
      associateDesignationController = TextEditingController(),
      associateNameController = TextEditingController(),
      associateEmailController = TextEditingController();
  TextEditingController driverNinController = TextEditingController(),
      driverPassportNumberController = TextEditingController(),
      driverNameController = TextEditingController(),
      driverEmailController = TextEditingController(),
      stageNameController = TextEditingController(),
      regNoController = TextEditingController(),
      makeModelController = TextEditingController(),
      colorController = TextEditingController(),
      chassisNoController = TextEditingController();
  double tarrifAmount = 0.0;
  String tarrifFrequency = "";
  int tarrifFrequencyDays = 0;
  String lastRenewalDateStr = "2024-09-01T00:00:00.027Z";
  String nexttRenewalDateStr = "2024-11-01T00:00:00.027Z";
  var dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

  void getCategoryTarrif(String sectorCategoryId) async {
    var url = Uri.parse(
        "${AppConstants.baseUrl}charges/categoryid/$sectorCategoryId");
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
    debugPrint("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      DateTime lastrenewaldate = DateTime.parse(lastRenewalDateStr);
      DateTime nextrenewaldate = lastrenewaldate.add(Duration(days: 30));
      setState(() {
        tarrifAmount = items[0]["amount"];
        tarrifFrequency = items[0]["frequency"];
        tarrifFrequencyDays = items[0]["frequencydays"];
        nexttRenewalDateStr = dateFormat.format(nextrenewaldate);
        // pastSixtyDaysCount = items[0]["pastsixtydays"];
      });
    } else {
      debugPrint(response.body.toString());
    }
  }

  Future<List<String>> getKlaDivisions() async {
    print("++++++++++++++++GETTING KLA DIVISIONS ++++++++++");
    List<String> returnValue = [];
    var url = Uri.parse(
        "${AppConstants.baseUrl}locations/subcountiesbydistrict/KAMPALA");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
    debugPrint("++++++${response.body}+++++++");
    if (response.statusCode == 200) {
      List<String> stringList =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();
      // final items = json.decode(response.body);
      // Owners usersobj = Owners.fromJson(items);

      // List<String> usersmodel = items;
      // List<OwnerItem> usersmodel = usersobj.items;

      returnValue = stringList;
      // debugPrint(usersobj.items.length);
      setState(() {
        subcounties = stringList;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<String>> getDistricts() async {
    print("++++++++ GETTING DISTRICTS ++++++++++");
    List<String> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}locations/districts");
    String _authToken = "";
    String _username = "";
    String _password = "";

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
    debugPrint("++++++${response.body}+++++++");
    if (response.statusCode == 200) {
      List<String> stringList =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();
      // final items = json.decode(response.body);
      // Owners usersobj = Owners.fromJson(items);

      // List<String> usersmodel = items;
      // List<OwnerItem> usersmodel = usersobj.items;

      returnValue = stringList;
      // debugPrint(usersobj.items.length);
      setState(() {
        districts = stringList;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<String>> getCounties(String district) async {
    List<String> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}locations/counties/$district");
    String _authToken = "";
    String _username = "";
    String _password = "";

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
    debugPrint("++++++${response.body}+++++++");
    if (response.statusCode == 200) {
      List<String> stringList =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();

      returnValue = stringList;
      // debugPrint(usersobj.items.length);
      setState(() {
        counties = stringList;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<String>> getSubcounties(String county) async {
    List<String> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}locations/subcounties/$county");
    String _authToken = "";
    String _username = "";
    String _password = "";

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
    debugPrint("++++++${response.body}+++++++");
    if (response.statusCode == 200) {
      List<String> stringList =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();

      returnValue = stringList;
      // debugPrint(usersobj.items.length);
      setState(() {
        subcounties = stringList;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<String>> getParishes(String subcounty) async {
    List<String> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}locations/parishes/$subcounty");
    String _authToken = "";
    String _username = "";
    String _password = "";

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
    debugPrint("++++++${response.body}+++++++");
    if (response.statusCode == 200) {
      List<String> stringList =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();

      returnValue = stringList;
      // debugPrint(usersobj.items.length);
      setState(() {
        parishes = stringList;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<List<String>> getVillages(String parish) async {
    List<String> returnValue = [];
    var url = Uri.parse("${AppConstants.baseUrl}locations/villages/$parish");
    String _authToken = "";
    String _username = "";
    String _password = "";

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
    debugPrint("++++++${response.body}+++++++");
    if (response.statusCode == 200) {
      List<String> stringList =
          (jsonDecode(response.body) as List<dynamic>).cast<String>();

      returnValue = stringList;
      // debugPrint(usersobj.items.length);
      setState(() {
        villages = stringList;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widgetOption(
              title: "Showing ${page + 1} of ${list.length}",
              callRemove: () {
                if (page > 0) {
                  setState(() {
                    page--;

                    addRevenueStreamPageController.jumpToPage(page);
                  });
                }
              },
              callAdd: () {
                if (page < list.length) {
                  setState(() {
                    page++;

                    addRevenueStreamPageController.jumpToPage(page);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _reegisterStream() async {
    var url =
        Uri.parse("${AppConstants.baseUrl}revenuestreamsregisternewentity");
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
      "id": "0",
      "ownername": entityNameController.text,
      "email": ownerEmailController.text,
      "phone": ownerNumber.phoneNumber.toString().replaceAll("+", ""),
      "assocfirstname": associateNameController.text.split(" ")[0],
      "assoclastname": associateNameController.text.split(" ")[1],
      "assocemail": associateEmailController.text,
      "assocphone": associateNumber.phoneNumber,
      "assocnin": associateNinController.text,
      "assocdesignation": associateDesignationController.text,
      "districtid": selectedOwnerDistrict == "Select District /City"
          ? ""
          : selectedOwnerDistrict,
      "countyid": selectedOwnerCounty == "Select County / Municipality"
          ? ""
          : selectedOwnerCounty,
      "subcountyid": selectedOwnerSubcounty == "Select Subcounty / Town Council"
          ? ""
          : selectedOwnerSubcounty,
      "parishid": selectedOwnerParish == "Select Parish / Ward"
          ? ""
          : selectedOwnerParish,
      "villageid":
          selectedOwnerVillage == "Select Village" ? "" : selectedOwnerVillage,
      "operatorfname":
          driverNameController.text.isNotEmpty ? driverNameController.text : "",
      "operatorlname":
          driverNameController.text.isNotEmpty ? driverNameController.text : "",
      "operatornin":
          driverNinController.text.isNotEmpty ? driverNinController.text : "",
      "operatormobile": driverNumber.phoneNumber.toString().replaceAll("+", ""),
      "operatoremail": driverEmailController.text.isNotEmpty
          ? driverEmailController.text
          : "",
      "operatordistrict": selectedDriverDistrict,
      "operatorcounty": selectedDriverCounty,
      "operatorsubcounty": selectedDriverSubcounty,
      "operatorparish": selectedDriverParish,
      "operatorvillage": selectedDriverDistrict,
      "regreferenceno": "",
      "sectorid": widget.sectorId,
      "sectorsubtypeid": widget.categoryId,
      "tarriffrequency": tarrifFrequency,
      "tarrifamount": tarrifAmount,
      "lastrenewaldate": lastRenewalDateStr,
      "nextrenewaldate": nexttRenewalDateStr,
      "revenueactivity": "",
      "vesseltype": "",
      "vesselstorage": "",
      "vesselmaterial": "",
      "vesselsafetyequip": "",
      "vessellength": 0,
      "vesselpropulsion": "",
      "dailyactivehours": 0,
      "companytype": "",
      "businesstype": "",
      "businessname": regNoController.text.isEmpty
          ? ""
          : regNoController.text.replaceAll(" ", "") +
              " " +
              makeModelController.text,
      "tradingname": entityNameController.text,
      "staffcountmale": 0,
      "staffcountfemale": 0,
      "bedcount": 0,
      "roomcount": 0,
      "hasgym": false,
      "hashealthclub": false,
      "haspool": false,
      "hasbar": false,
      "hasrestaurant": false,
      "hasconference": false,
      "establishmenttype": "",
      "regno": regNoController.text.replaceAll(" ", ""),
      "vin": chassisNoController.text,
      "color": colorController.text.isEmpty ? "" : colorController.text,
      "tin": ownerTinController.text,
      "brn": ownerBrnController.text,
      "ownerid": "",
      "operatorid": "",
      "logbookno": "",
      "permitno": "",
      "engineno": "",
      "enginehp": 0,
      "model": makeModelController.text,
      "divisionid": selectedDriverCounty.isEmpty ? "" : selectedDriverCounty,
      "stageid":
          stageNameController.text.isEmpty ? "" : stageNameController.text,
      "address": "",
      "addresslat": 0.0,
      "addresslong": 0.0,
      "type": "${widget.category}",
      "createdby": await prefs.getString("userid") ?? "Self Registration"
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
      final items = json.decode(response.body);
      debugPrint("++++++${items["regreferenceno"]}+++++++");
      // Automobile res = Automobile.fromJson(items);
      // _sendSmsMessage(
      //     'Your commercial car has been registered successfully with Reference No: ${items["regreferenceno"]}',
      //     _phoneNumber!
      //         .replaceAll("PhoneNumber(phoneNumber: ", "")
      //         .replaceAll(", dialCode: 256, isoCode: UG)", ""));
      // ignore: use_build_context_synchronously

      Dialogs.materialDialog(
          dialogWidth: MediaQuery.of(context).size.width * .4,
          color: Colors.white,
          msgStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          msg:
              "You have registered this ${widget.category} with City Revenue Assurance ID No: ${items["regreferenceno"]}. \n Please note it down before proceeding!",
          title: 'Success',
          titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          lottieBuilder: Lottie.asset('assets/cong_example.json',
              fit: BoxFit.contain, repeat: true, height: 80, width: 80),
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                context.goNamed("revenuestreams", pathParameters: {});
                Navigator.of(context).pop();
              },
              text: 'DONE',
              iconData: Icons.done,
              color: Colors.green.shade900,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
      // await showSuccessToast(
      //     "You have registered this Commercial Car with reference No: ${items["regreferenceno"]}. \n Please note it down before proceeding!");
      addRevenueStreamPageController.jumpToPage(0);
      setState(() {
        responseLoading = false;
      });
      // showSnackBar("Alert: User account not activated.");
    } else if (response.statusCode == 409) {
      setState(() {
        responseLoading = false;
      });
      showWarningToast(
          "Duplication Alert: A Vehicle already exits with this reg no./number plate!!!");
    } else {
      setState(() {
        responseLoading = false;
      });
      showErrorToast("Authentication Failure: Invalid credentials.");
    }
  }

  Widget widgetOption(
      {required String title,
      required VoidCallback callAdd,
      required VoidCallback callRemove}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 30,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                page > 0
                    ? ElevatedButton(
                        onPressed: callRemove,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(color: Colors.grey.shade700),
                          ),
                          elevation: 0,
                          side: BorderSide(
                            width: 0.5,
                          ),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Prev",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 8,
                ),
                page < 3
                    ? ElevatedButton(
                        onPressed: callAdd,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(color: Colors.grey.shade700),
                          ),
                          side: BorderSide(
                            width: 0.5,
                          ),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      )
                    : page == 3
                        ? ElevatedButton(
                            onPressed: () {
                              _reegisterStream();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Colors.green.shade700),
                              ),
                              side: BorderSide(
                                color: Colors.green.shade700,
                                width: 0.5,
                              ),
                              backgroundColor: Colors.green.shade100,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: Colors.green.shade700,
                                ),
                              ],
                            ),
                          )
                        : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getCategoryTarrif(widget.categoryId);
    getDistricts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Register ${widget.ownerType} Owned ${widget.category}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .65,
                  height: MediaQuery.of(context).size.height * .67,
                  child: PageView(
                    controller: addRevenueStreamPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: false,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _step1(),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _step2(),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _step3(),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _step4(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _stepper(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _step1() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Entity Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                visualDensity: VisualDensity(vertical: 3),
                title: Text(
                  'Business Registration No. (BRN)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: ownerBrnController,
                    enabled: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      disabledBorder: OutlineInputBorder(
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
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Tax Identification No. (TIN)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: ownerTinController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Registered Entity Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: entityNameController,
                    enabled: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      disabledBorder: OutlineInputBorder(
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
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Email address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: ownerEmailController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Phone number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 40,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      debugPrint('On Change: ${number.phoneNumber}');
                      ownerNumber = number;
                    },
                    onInputValidated: (bool value) {
                      // debugPrint('On Validate: $value');
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    // focusNode: _phoneNumberFocus,
                    ignoreBlank: false,
                    // autoValidateMode: AutovalidateMode.disabled,
                    hintText: 'e.g 771000111',
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: ownerNumber,
                    cursorColor: AppConstants.primaryColor,
                    maxLength: 10,
                    // maxLength: _phoneNumber!.contains("+256") ? 9 : 12,
                    onFieldSubmitted: (val) {
                      // _fieldFocusChange(context, _phoneNumberFocus, _emailFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the owner\'s Phone Number.';
                      }
                      if (value.length < 9 || value.length > 12) {
                        return 'Please enter a valid Phone Number';
                      }
                      return null;
                    },
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffB9B9B9)),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),

                    onSaved: (PhoneNumber number) {
                      debugPrint('On Saved: $number');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          width: 30,
          // child: VerticalDivider(
          //   width: 2,
          //   color: Colors.grey,
          // ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Entity Location',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                title: Text(
                  'Select District',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedOwnerDistrict,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: districts.map((item) {
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
                      List itemsList = districts.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedOwnerDistrict = item;
                            debugPrint(selectedOwnerDistrict);
                          });
                        }
                      }).toList();
                      getCounties(selectedOwnerDistrict);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select County/Muncipality',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedOwnerCounty,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: counties.map((item) {
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
                      List itemsList = counties.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedOwnerCounty = item;
                            debugPrint(selectedOwnerCounty);
                          });
                        }
                      }).toList();
                      getSubcounties(selectedOwnerCounty);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Subcounty/Town Council',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedOwnerSubcounty,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: subcounties.map((item) {
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
                      List itemsList = subcounties.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedOwnerSubcounty = item;
                            debugPrint(selectedOwnerSubcounty);
                          });
                        }
                      }).toList();
                      getParishes(selectedOwnerSubcounty);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Parish/Ward',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedOwnerParish,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: parishes.map((item) {
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
                      List itemsList = parishes.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedOwnerParish = item;
                            debugPrint(selectedOwnerParish);
                          });
                        }
                      }).toList();
                      getVillages(selectedOwnerParish);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Village',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedOwnerVillage,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: villages.map((item) {
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
                      List itemsList = villages.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedOwnerVillage = item;
                            debugPrint(selectedOwnerVillage);
                          });
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step2() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Vehicle Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                title: Text(
                  'Reg No/Number Plate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: regNoController,
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
                      hintText: 'e.g UAA 001A',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Make-Model',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: makeModelController,
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
                      hintText: 'e.g Toyota Hiace',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: colorController,
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
                      hintText: 'e.g White',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Chassis Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: chassisNoController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              // ListTile(
              //   title: Text(
              //     'Does owner operate vehicle?',
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              //   subtitle: Container(
              //     height: 37,
              //     child: DropdownButtonFormField(
              //       decoration: InputDecoration(
              //         contentPadding:
              //             EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide(color: Color(0xffB9B9B9)),
              //           borderRadius: BorderRadius.all(Radius.circular(4)),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Color(0xffB9B9B9), width: 1.0),
              //           borderRadius: BorderRadius.all(Radius.circular(4)),
              //         ),
              //         hintText: '',
              //       ),
              //       isExpanded: true,
              //       hint: Row(
              //         children: [
              //           new Text(
              //             selectedDoesOwnerOperate,
              //             style: const TextStyle(
              //                 // color: Colors.grey,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w400),
              //           ),
              //         ],
              //       ),
              //       icon: const Icon(Icons.keyboard_arrow_down),
              //       items: doesOwnerOperate.map((item) {
              //         return DropdownMenuItem(
              //           child: Row(
              //             children: [
              //               new Text(
              //                 item,
              //                 style: const TextStyle(
              //                     // color: Colors.grey,
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.w400),
              //               ),
              //             ],
              //           ),
              //           value: item,
              //         );
              //       }).toList(),
              //       onChanged: (newVal) {
              //         List itemsList = doesOwnerOperate.map((item) {
              //           if (item == newVal) {
              //             setState(() {
              //               selectedDoesOwnerOperate = item;
              //               debugPrint(selectedDoesOwnerOperate);
              //             });
              //           }
              //         }).toList();
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          width: 30,
          // child: VerticalDivider(
          //   width: 2,
          //   color: Colors.grey,
          // ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Personal Information (Driver)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                title: Text(
                  'NIN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: driverNinController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Passport/Refugee Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: driverPassportNumberController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Full name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: driverNameController,
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
                      hintText: 'Firstname Lastname Others',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Email address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: driverEmailController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Phone number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      debugPrint('On Change: ${number.phoneNumber}');
                      driverNumber = number;
                    },
                    onInputValidated: (bool value) {
                      // debugPrint('On Validate: $value');
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    // focusNode: _phoneNumberFocus,
                    ignoreBlank: false,
                    // autoValidateMode: AutovalidateMode.disabled,
                    hintText: 'e.g 771000111',
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: driverNumber,
                    cursorColor: AppConstants.primaryColor,
                    maxLength: 10,
                    // maxLength: _phoneNumber!.contains("+256") ? 9 : 12,
                    onFieldSubmitted: (val) {
                      // _fieldFocusChange(context, _phoneNumberFocus, _emailFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the driver\'s Phone Number.';
                      }
                      // if (_phoneNumber!.contains("+256") ||
                      //     value.length < 9 ||
                      //     value.length > 9) {
                      //   debugPrint("UGANDA NUMBER");
                      //   return 'Please enter a valid Phone Number';
                      // } else
                      if (value.length < 9 || value.length > 12) {
                        return 'Please enter a valid Phone Number';
                      }
                      return null;
                    },
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffB9B9B9)),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),

                    onSaved: (PhoneNumber number) {
                      debugPrint('On Saved: $number');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step3() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Residence (Driver)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                title: Text(
                  'Select District',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedDriverDistrict,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: districts.map((item) {
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
                      List itemsList = districts.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedDriverDistrict = item;
                            debugPrint(selectedDriverDistrict);
                          });
                        }
                      }).toList();
                      getCounties(selectedDriverDistrict);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select County/Muncipality',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedDriverCounty,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: counties.map((item) {
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
                      List itemsList = counties.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedDriverCounty = item;
                            debugPrint(selectedDriverCounty);
                          });
                        }
                      }).toList();
                      getSubcounties(selectedDriverCounty);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Subcounty/Town Council',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedDriverSubcounty,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: subcounties.map((item) {
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
                      List itemsList = subcounties.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedDriverSubcounty = item;
                            debugPrint(selectedDriverSubcounty);
                          });
                        }
                      }).toList();
                      getParishes(selectedDriverSubcounty);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Parish/Ward',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedDriverParish,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: parishes.map((item) {
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
                      List itemsList = parishes.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedDriverParish = item;
                            debugPrint(selectedDriverParish);
                          });
                        }
                      }).toList();
                      getVillages(selectedDriverParish);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Village',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedDriverVillage,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: villages.map((item) {
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
                      List itemsList = villages.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedDriverVillage = item;
                            debugPrint(selectedDriverVillage);
                          });
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          width: 30,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Operational Area',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                title: Text(
                  'Select County/Muncipality',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedStageCounty,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: counties.map((item) {
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
                      List itemsList = counties.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedStageCounty = item;
                            debugPrint(selectedStageCounty);
                          });
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Subcounty/Town Council',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedStageSubcounty,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: subcounties.map((item) {
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
                      List itemsList = subcounties.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedStageSubcounty = item;
                            debugPrint(selectedStageSubcounty);
                          });
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Parish/Ward',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedStageParish,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: parishes.map((item) {
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
                      List itemsList = parishes.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedStageParish = item;
                            debugPrint(selectedStageParish);
                          });
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Select Village',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
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
                          selectedStageVillage,
                          style: const TextStyle(
                              // color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: villages.map((item) {
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
                      List itemsList = villages.map((item) {
                        if (item == newVal) {
                          setState(() {
                            selectedStageVillage = item;
                            debugPrint(selectedStageVillage);
                          });
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Stage Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Container(
                  height: 37,
                  child: TextFormField(
                    controller: stageNameController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step4() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Personal Information (Associiate)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                visualDensity: VisualDensity(vertical: 3),
                title: Text(
                  'NIN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: associateNinController,
                    enabled: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      disabledBorder: OutlineInputBorder(
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
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Passport/Refugee Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: associatePassportNumberController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                dense: true,
                visualDensity: VisualDensity(vertical: 3),
                title: Text(
                  'Designation e.g Director',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: associateDesignationController,
                    enabled: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      disabledBorder: OutlineInputBorder(
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
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Full name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: associateNameController,
                    enabled: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB9B9B9)),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      hintText: 'Firstname Lastname Others',
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Email address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 38,
                  child: TextFormField(
                    controller: associateEmailController,
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
                      hintText: '',
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  'Phone number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Container(
                  height: 40,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      debugPrint('On Change: ${number.phoneNumber}');
                      associateNumber = number;
                    },
                    onInputValidated: (bool value) {
                      // debugPrint('On Validate: $value');
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    // focusNode: _phoneNumberFocus,
                    ignoreBlank: false,
                    // autoValidateMode: AutovalidateMode.disabled,
                    hintText: 'e.g 771000111',
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: ownerNumber,
                    cursorColor: AppConstants.primaryColor,
                    maxLength: 10,
                    // maxLength: _phoneNumber!.contains("+256") ? 9 : 12,
                    onFieldSubmitted: (val) {
                      // _fieldFocusChange(context, _phoneNumberFocus, _emailFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the associate\'s Phone Number.';
                      }
                      if (value.length < 9 || value.length > 12) {
                        return 'Please enter a valid Phone Number';
                      }
                      return null;
                    },
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffB9B9B9)),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),

                    onSaved: (PhoneNumber number) {
                      debugPrint('On Saved: $number');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Expanded(
        //   child: Column(
        //     children: [
        //       Text(
        //         'Register New ${widget.ownerType} ${widget.category}?',
        //         style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
