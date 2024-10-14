import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import '../models/authtoken.dart';
import '../models/user.dart';
import 'constants.dart';

class AppFunctions {
  //auth function to get bearer token
  static authenticate(String username, String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "user/login");
    // bool responseStatus = false;
    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var bodyString = {"username": username, "password": password};

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    debugPrint("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      UserModel auth = UserModel.fromJson(item);
      _authToken = auth.token;
      prefs.setString("authToken", _authToken);
    } else {
      // showSnackBar("Network Failure: Failed to retrieve students");
    }
  }

//   //get user profile function
//   getProfile(String username, String password) async {
//     var url = Uri.parse(AppConstants.baseUrl + "users/me/");
//     String _authToken = "";
//     String _username = "";
//     String _password = "";

//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     //Get username and password from shared prefs
//     // _username = prefs.getString("username")!;
//     // _password = prefs.getString("password")!;

//     await AppFunctions.authenticate(username, password);
//     _authToken = prefs.getString("authToken")!;

//     var response = await http.get(
//       url,
//       headers: {
//         "Content-Type": "Application/json",
//         'Authorization': 'Bearer $_authToken',
//       },
//     );
//     debugPrint("++++++" + response.body.toString() + "+++++++");
//     if (response.statusCode == 200) {
//       final item = json.decode(response.body);
//       UserProfile user = UserProfile.fromJson(item);
//       prefs.setString("fullname", user.fullName);
//       prefs.setString("firstname", user.firstName);
//       prefs.setString("lastname", user.lastName);
//       prefs.setInt("userid", user.id);
//       prefs.setString("uuid", user.uuid);
//       prefs.setString("username", user.username);
//       prefs.setString("email", user.email);
//     } else {
//       // returnValue = [];
//       // showSnackBar("Network Failure: Failed to retrieve students");
//     }
//   }
}
