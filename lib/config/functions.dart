import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
// import '../models/authtoken.dart';
import '../models/authtoken copy.dart';
import '../models/transactionstatus.dart';
import '../models/user.dart';
import 'constants.dart';

class AppFunctions {
  //auth function to get bearer token
  static authenticate(String username, String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "user/login");
    //
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
    // debugPrint("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      UserModel auth = UserModel.fromJson(item);
      _authToken = auth.token;
      prefs.setString("authToken", _authToken);
    } else {
      // showSnackBar("Network Failure: Failed to retrieve students");
    }
  }

  static authenticateMtnMomo() async {
    var url = Uri.parse(AppConstants.MOMO_TOKEN_URL);

    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var bodyString = {};
    String basicAuth = 'Basic ' +
        base64.encode(
          utf8.encode(
            '${AppConstants.MOMO_USER_ID}:${AppConstants.MOMO_API_KEY}',
          ),
        );

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          "Authorization": basicAuth,
          "Ocp-Apim-Subscription-Key": AppConstants.MTN_COLLECTION_PRIMARY_URL
        },
        body: body);
    print("++++++ MOMO TOKEN" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      AuthToken auth = AuthToken.fromJson(item);
      _authToken = auth.accessToken;
      prefs.setString("authToken", _authToken);
    } else {
      // showSnackBar("Network Failure: Failed to authenticate collection request.");
    }
  }

  //function to initiate payout for MTN
  static requestToPayMtnMomo(
      String amount, String saleOrderNo, String phoneNumber) async {
    var url = Uri.parse(AppConstants.MOMO_REQUEST_TO_PAY);

    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var bodyString = {
      "amount": amount,
      "currency": "EUR",
      "externalId": new Uuid().v4(),
      "payer": {
        "partyIdType": "MSISDN",
        "partyId": phoneNumber,
      },
      "payerMessage": "Payment for Sale Order $saleOrderNo",
      "payeeNote": ""
    };
    await AppFunctions.authenticateMtnMomo();
    _authToken = prefs.getString("authToken") ?? "";

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
          "X-Reference-Id": new Uuid().v4(),
          "X-Target-Environment": "sandbox",
          "Ocp-Apim-Subscription-Key": AppConstants.MTN_COLLECTION_PRIMARY_URL
        },
        body: body);
    print("++++++ MOMO Pay BODY " + response.body.toString() + "+++++++");
    print("++++++ MOMO Pay CODE " + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 202) {
      // final item = json.decode(response.body);
      // AuthToken auth = AuthToken.fromJson(item);
      // _authToken = auth.accessToken;
      // prefs.setString("authToken", _authToken);
    } else {
      // showSnackBar("Network Failure: Failed to authenticate collection request.");
    }
  }

  //function to check transaction status MTN
  static transactionStatusMtnMomo(String refID) async {
    var url = Uri.parse(AppConstants.MOMO_REQUEST_TO_PAY + "/$refID");

    String _authToken = "";
    String _status = "FAILED";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await AppFunctions.authenticateMtnMomo();
    _authToken = prefs.getString("authToken")!;
    // var bodyString = {};
    // var body = jsonEncode(bodyString);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
        "X-Reference-Id": new Uuid().v4(),
        "X-Target-Environment": "sandbox",
        "Ocp-Apim-Subscription-Key": AppConstants.MTN_COLLECTION_PRIMARY_URL
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    print("++++++" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200 && response.statusCode == 202) {
      final item = json.decode(response.body);
      TransactionStatus transactionStatus = TransactionStatus.fromJson(item);
      _status = transactionStatus.status;
    } else {
      // showSnackBar("Network Failure: Failed to authenticate collection request.");
    }

    return _status;
  }

  //auth function to get bearer token
  static authenticateAirtelPay() async {
    var url = Uri.parse(
        AppConstants.AIRTEL_PAY_BASE_URL + AppConstants.AIRTEL_TOKEN_EXTENSION);

    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // SANDBOX KEYS
    // var bodyString = {
    //   "client_id": "a7faa6bd-615b-4e99-a8e4-c83d4c61faa6",
    //   "client_secret": "16ede2cb-d092-4c52-8ea6-4335e61a4f44",
    //   "grant_type": "client_credentials"
    // };

    var bodyString = {
      "client_id": "b55069a7-2a54-46c4-a696-e4fa45f1a07a",
      "client_secret": "59b2050b-6e33-4f30-af3e-eeafb54cf055",
      "grant_type": "client_credentials"
    };
    String basicAuth = 'Basic ' +
        base64.encode(
          utf8.encode(
            '${AppConstants.MOMO_USER_ID}:${AppConstants.MOMO_API_KEY}',
          ),
        );

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          "Authorization": basicAuth,
          "Ocp-Apim-Subscription-Key": AppConstants.MTN_COLLECTION_PRIMARY_URL
        },
        body: body);
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      AuthToken auth = AuthToken.fromJson(item);
      _authToken = auth.accessToken;
      prefs.setString("authToken", _authToken);
    } else {
      // showSnackBar("Network Failure: Failed to authenticate collection request.");
    }
  }

  //function to initiate payout for Airtel
  static requestToPayAirtel(
      String amount, String saleOrderNo, int phoneNumber) async {
    var url = Uri.parse(
        AppConstants.AIRTEL_PAY_BASE_URL + AppConstants.AIRTEL_REQUEST_TO_PAY);

    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var bodyString = {
      "reference": "$saleOrderNo",
      "subscriber": {
        "country": "UG",
        "currency": "UGX",
        "msisdn": phoneNumber,
      },
      "transaction": {
        "amount": int.tryParse(amount),
        "country": "UG",
        "currency": "UGX",
        "id": new Uuid().v4()
      }
    };
    await AppFunctions.authenticateAirtelPay();
    _authToken = prefs.getString("authToken")!;

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
          "X-Currency": "UGX",
          "X-Country": "UG",
        },
        body: body);
    print("++++++" + response.body.toString() + "+++++++");
    print("++++++" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200 && response.statusCode == 202) {
      final item = json.decode(response.body);
      AuthToken auth = AuthToken.fromJson(item);
      _authToken = auth.accessToken;
      prefs.setString("authToken", _authToken);
    } else {
      // showSnackBar("Network Failure: Failed to authenticate collection request.");
    }
  }

  //function to initiate payout for MTn
  static transactionStatusAirtel(String transactionId) async {
    print("++++++" + "TRANSACTION STATUS FUNCTION" + "+++++++");
    var url = Uri.parse(
        "https://openapi.airtel.africa/standard/v1/payments/$transactionId");

    String _authToken = "";
    // ignore: unused_local_variable
    String status = "TF";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await AppFunctions.authenticateAirtelPay();
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
        "X-Currency": "UGX",
        "X-Country": "UG",
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    print("++++++" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200 && response.statusCode == 202) {
      final item = json.decode(response.body);
      AirtelTransactionStatus transactionStatus =
          AirtelTransactionStatus.fromJson(item);
      status = transactionStatus.data.transaction.status;
    } else {
      // showSnackBar("Network Failure: Failed to authenticate collection request.");
    }
  }
}
