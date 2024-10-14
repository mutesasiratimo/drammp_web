import 'dart:async';
// import 'dart:convert';
import 'dart:io';
import 'package:entebbe_dramp_web/auth/signin.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

// import 'constants.dart';
// import 'functions.dart';

abstract class Base<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late SharedPreferences preferences;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PageController pageController = PageController();
  String resolvedCount = "0";
  String totalCount = "0";
  String approvedCount = "0";
  String rejectedCount = "0";
  String unapprovedCount = "0";
  String? baseauthToken;
  String? basefirstName = "User";
  String? baselastName = "";
  String? baseemail;
  String? basegender;
  String? basephoneNumber;
  // String? baserole;
  String basepassword = "";
  String? baseuserId;
  String baseusername = "";
  // Padding begin.
  double kDefaultPadding = 16.0;
  double kTextPadding = 4.0;
// Padding end.

// Screen width begin.
  double kScreenWidthSm = 576.0;
  double kScreenWidthMd = 768.0;
  double kScreenWidthLg = 992.0;
  double kScreenWidthXl = 1200.0;
  double kScreenWidthXxl = 1400.0;
// Screen width end.

// Dialog width begin.
  double kDialogWidth = 460.0;
// Dialog width end.

  //This function gets the loaclly stored session data
  Future<void> getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      baseemail = prefs.getString('email');
      basefirstName = prefs.getString("firstName");
      baselastName = prefs.getString("lastName");
      basephoneNumber = prefs.getString("phoneNumber");
      basegender = prefs.getString("gender");
      // baserole = prefs.getString("role");
      baseuserId = prefs.getString("userid");
      baseusername = prefs.getString("username")!;
      basepassword = prefs.getString("password")!;
      // baseprofilePhoto64 = prefs.getString("photo");

      // if (_profilePhoto64 != null && _profilePhoto64!.trim() != "") {
      //   _bytesImage = base64.decode(_profilePhoto64!.split(',').last);
      // }
    });
  }

  showSuccessToast(String msg) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text('Success!'),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: msg, style: TextStyle(color: Colors.green.shade900))),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(Icons.check_circle),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.green.shade900,
      backgroundColor: Colors.green.shade100,
      foregroundColor: Colors.green.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  showWarningToast(String msg) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text('Warning!'),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: msg, style: TextStyle(color: Colors.amber.shade900))),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(Icons.check_circle),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.amber.shade900,
      backgroundColor: Colors.amber.shade100,
      foregroundColor: Colors.amber.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  showInfoToast(String msg) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text('Information!'),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: msg, style: TextStyle(color: Colors.blue.shade900))),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(Icons.check_circle),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.blue.shade900,
      backgroundColor: Colors.blue.shade100,
      foregroundColor: Colors.blue.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  showErrorToast(String msg) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text('Success!'),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: msg, style: TextStyle(color: Colors.red.shade900))),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(Icons.check_circle),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.red.shade900,
      backgroundColor: Colors.red.shade100,
      foregroundColor: Colors.red.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  // This method is about push to new widget and replace current widget
  pushReplacement(StatefulWidget screenName) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screenName));
  }

  // This method is about push to new widget but don't replace current widget
  push(StatefulWidget screenName) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => screenName));
  }

  // This method is about push to new widget and remove all previous widget
  pushAndRemoveUntil(StatefulWidget screenName) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => screenName),
        (_) => false);
  }

  Future<Container> _buildTextField(hintText, controller, textInputType, width,
      height, fcolor, tcolor, icolor, action) async {
    // add other properties here}) { // new
    return Container(
      //Type TextField
      width: width,
      height: height,
      color: fcolor,
      child: TextField(
        textInputAction: action,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: hintText, // pass the hint text parameter here
          hintStyle: TextStyle(color: tcolor),
        ),
        style: TextStyle(color: icolor),
      ),
    );
  }

  // Show loading with optional message params
  showLoading({required String msg}) {}

  hideLoadingSuccess(String msg) {
    // EasyLoading.showSuccess(msg, duration: Duration(seconds: 2));
    // EasyLoading.dismiss();
  }

  hideLoadingError(String msg) {
    // EasyLoading.showError(msg, duration: Duration(seconds: 2));
    // EasyLoading.dismiss();
  }

  hideLoading() {
    // EasyLoading.dismiss();
  }

  /*
   * Show Snackbar with Global scaffold key
   * scaffoldKey is defined globally as snackbar do not find context of Scaffold widget
   * hideLoading is hide the loader when snackbar message is showing to UI
   */
  showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      dismissDirection: DismissDirection.up,
    ));
    hideLoading();
  }

  showMessage(String title, String message) {
    hideLoading();
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctxt) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (message.toLowerCase().contains("session expired")) {
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// called on register tapped in homeview
  Future<void> gesture1(String? tex) async {
    if (tex == 'Register a User') {
      debugPrint(tex);
    } else if (tex == 'Register a boda boda') {
      debugPrint(tex);
    } else if (tex == 'Register taxis') {
      debugPrint(tex);
    } else if (tex == 'Register commercial vehicles') {
      debugPrint(tex);
    } else {
      showSnackBar('No Input');
    }
  }

// called on see all tapped in homeview
  Future<void> gesture2(String? texx) async {
    if (texx == 'Register a User') {
      debugPrint(texx);
    } else if (texx == 'Register a boda boda') {
      debugPrint(texx);
    } else if (texx == 'Register taxis') {
      debugPrint(texx);
    } else if (texx == 'Register commercial vehicles') {
      debugPrint(texx);
    } else {
      showSnackBar('No Input');
    }
  }

  //Logout Function
  clearPrefs() async {
    preferences = await SharedPreferences.getInstance();
    preferences.clear();
    pushAndRemoveUntil(const SignInPage());

    // Check Internet Connection Async method with Snackbar message.
    Future<bool> isConnected() async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        showSnackBar("No Internet Connection");
        return false;
      }
      showSnackBar("No Internet Connection");
      return false;
    }
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 2),
          color: Color(0xff808080),
          blurRadius: 5,
        )
      ],
    );
  }
}
