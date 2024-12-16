import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:entebbe_dramp_web/config/base.dart';
import 'package:http/http.dart' as http;
import 'package:entebbe_dramp_web/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends Base<UsersPage> {
  List<UserItems> _users = [];
  int _pageNumber = 1;
  int rowCount = 10;
  int _currentSortColumn = 0;
  bool _isAscending = true;
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  Future<List<UserItems>> getUsers() async {
    List<UserItems> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl +
        "users/default?page=$_pageNumber&size=$rowCount");
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
      UsersPaginatedModel usersmodel = UsersPaginatedModel.fromJson(items);

      returnValue = usersmodel.items;
      setState(() {
        _users = usersmodel.items;
      });
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve users");
    }
    return returnValue;
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BootstrapRow(
        children: <BootstrapCol>[
          BootstrapCol(
            sizes: "col-lg-12 col-md-12 col-sm-12",
            child: SizedBox(
              height: size.height * .8,
              child: Container(
                padding: EdgeInsets.all(24.0),
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(children: [
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
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isAscending,
                      columns: [
                        DataColumn(
                          label: const Text("Name"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _users.sort((userA, userB) =>
                                    userB.firstname.compareTo(userA.firstname));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _users.sort((userA, userB) =>
                                    userA.firstname.compareTo(userB.firstname));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("Email Address"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _users.sort((userA, userB) =>
                                    userB.email.compareTo(userA.email));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _users.sort((userA, userB) =>
                                    userA.email.compareTo(userB.email));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("Phone"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _users.sort((userA, userB) =>
                                    userB.phone.compareTo(userA.phone));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _users.sort((userA, userB) =>
                                    userA.phone.compareTo(userB.phone));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("FCM ID?"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _users.sort((userA, userB) =>
                                    userB.fcmid!.compareTo(userA.fcmid!));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _users.sort((userA, userB) =>
                                    userA.fcmid!.compareTo(userB.fcmid!));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          numeric: false,
                          label: const Text("Date Registered"),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _users.sort((userA, userB) => userB.datecreated
                                    .compareTo(userA.datecreated));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _users.sort((userA, userB) => userA.datecreated
                                    .compareTo(userB.datecreated));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text("Details"),
                        ),
                      ],
                      rows: _users.isNotEmpty
                          ? _users // Loops through dataColumnText, each iteration assigning the value to element
                              .map(
                                (element) => DataRow2(
                                  cells: <DataCell>[
                                    DataCell(ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 500),
                                      child: Text(
                                        "${element.firstname} ${element.lastname}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.primaryColor,
                                            fontSize: 12),
                                      ),
                                    )),
                                    DataCell(Text(
                                      element.email.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )),
                                    DataCell(Text(
                                      "${element.phone} ${element.mobile}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )),
                                    DataCell(Badge(
                                      backgroundColor: element.fcmid
                                                  .toString() ==
                                              ""
                                          ? Colors.amber.shade700
                                          : (element.fcmid.toString() != "" &&
                                                  // ignore: unnecessary_null_comparison
                                                  element.fcmid.toString() !=
                                                      null)
                                              ? Colors.green.shade600
                                              : Colors.red.shade600,
                                      label: Text(
                                        element.fcmid.toString() == ""
                                            ? "No"
                                            : (element.fcmid.toString() != "" &&
                                                    // ignore: unnecessary_null_comparison
                                                    element.fcmid.toString() !=
                                                        null)
                                                ? "Yes"
                                                : "Null",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    )),
                                    DataCell(Text(
                                      "${element.datecreated}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )),
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          _showUserDetails(element);
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
                                  DataCell(Text("")),
                                  DataCell(Text("No Users")),
                                  DataCell(Text("")),
                                  // DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              )
                            ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

// setState(() {
//       iscitizen = widget.user.iscitizen!;

//       numbers = {
//         'Citizen': widget.user.iscitizen!,
//         'Clerk': widget.user.isclerk!,
//         'Engineer':
//             widget.user.isengineer == null ? false : widget.user.isengineer!,
//         'Admin': widget.user.isadmin!,
//       };
//     });

  //SHOW DIALOG FOR USER DETAILS
  _showUserDetails(UserItems user) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "User Details",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: () {
                    // getUsers();
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
            return SingleChildScrollView(
              child: UsersDetailsPage(user: user),
            );
          }),
          actions: <Widget>[],
        );
      },
    );
  }
}

class UsersDetailsPage extends StatefulWidget {
  final UserItems user;
  const UsersDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<UsersDetailsPage> createState() => _UsersDetailsPageState();
}

class _UsersDetailsPageState extends Base<UsersDetailsPage> {
  bool isclerk = true,
      isenforcer = false,
      isadmin = false,
      issuperadmin = false;
  Map<String, bool> accessRights = {
    'Clerk': false,
    'Enforcer': false,
    'Admin': false,
  };

  var holder_1 = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      isclerk = widget.user.isclerk!;

      accessRights = {
        'Clerk': widget.user.isclerk!,
        'Enforcer': widget.user.isenforcer!,
        'Admin': widget.user.isadmin!,
      };
    });
  }

  Future<void> _changeUserRights(
    String id,
    bool isclerk,
    bool isenforcer,
    bool isadmin,
  ) async {
    String _authToken = "";
    String userId = "";
    // setState(() {
    //   context.loaderOverlay.show();
    // });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "users/updateuserrights");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    var bodyString = {
      "id": id,
      "isclerk": isclerk,
      "isenforcer": isenforcer,
      "isadmin": isadmin,
      "issuperadmin": issuperadmin,
      "updatedby": userId
    };
    //  {
    //   "id": id,
    //   "iscitizen": iscitizen,
    //   "isclerk": isclerk,
    //   "isengineer": isengineer,
    //   "isadmin": isadmin
    // };

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    // context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      await NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green.shade600,
              size: 28,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Success"),
          ],
        ),
        content: Text(
          "User access rights updated!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Center(
              child: MaterialButton(
            child: const Text("Okay"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.green.shade600,
          )),
        ],
      ).show(context);
      // showSnackBar('Rights changed');

      // setState(() {
      //   context.loaderOverlay.hide();
      // });
    } else if (response.statusCode == 409) {
      // setState(() {
      //   context.loaderOverlay.hide();
      // });
      await NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Error"),
          ],
        ),
        content: Text(
          "Access rights not changed!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Center(
              child: MaterialButton(
            child: const Text("Okay"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.green.shade600,
          )),
        ],
      ).show(context);
      // showSnackBar("User rights not changed.");
    } else {
      // setState(() {
      //   context.loaderOverlay.hide();
      // });
      showErrorToast("Authentication Failure: Invalid credentials.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.user.firstname +
                                    " " +
                                    widget.user.lastname,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Email Address: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.user.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Phone Number: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.user.phone} ${widget.user.mobile}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Status: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.user.status == "0"
                                    ? "Inactive"
                                    : "Active",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.user.status == "0"
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      // flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Category: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 180,
                                width: 160,
                                child: ListView(
                                  children: accessRights.keys.map((String key) {
                                    return CheckboxListTile(
                                      title: Text(
                                        key,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: accessRights[key],
                                      activeColor: AppConstants.primaryColor,
                                      checkColor: Colors.white,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          accessRights[key] = value!;
                                        });
                                        _changeUserRights(
                                            widget.user.id,
                                            accessRights.values.toList()[0],
                                            accessRights.values.toList()[1],
                                            accessRights.values.toList()[2]);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      height: 300,
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }
}
