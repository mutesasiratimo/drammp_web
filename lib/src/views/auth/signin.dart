import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/base.dart';
import '../../../config/constants.dart';
// import '../admin_panel/home_page.dart';
import '/models/user.dart';
// import 'signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends Base<SignInPage> {
  bool rememberMe = false;
  bool obscurePassword = true;
  bool responseLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // messageListener();
  }

  _login(String username, String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "user/login");
    String _authToken = "";
    debugPrint("++++++" + "LOGIN FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      responseLoading = true;
      // if (usePhone) {
      //   url = Uri.parse(AppConstants.baseUrl + "user/login/mobile");
      // }
    });
    var bodyString = {"username": username, "password": password};
    // debugPrint(bodyString.toString());
    // debugPrint(url.toString());
    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    // debugPrint("++++++" + response.body.toString() + "+++++++");
    // debugPrint("++++++" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      UserModel user = UserModel.fromJson(item);
      _authToken = user.token;

      if (user.issuperadmin || user.isadmin || user.isclerk) {
        prefs.setString("authToken", _authToken);

        prefs.setString("firstName", user.firstname);
        prefs.setString("lastName", user.lastname);
        prefs.setString("email", user.email);
        prefs.setString("gender", user.gender);
        prefs.setString("phone", user.phone);
        prefs.setString("password", password);
        prefs.setString("userid", user.userid.toString());
        // prefs.setString("dateJoined", user.datecreated.toIso8601String());
        prefs.setBool("isclerk", user.isclerk);
        prefs.setBool("isadmin", user.isadmin);
        prefs.setBool("issuperadmin", user.issuperadmin);

        // debugPrint('Loggend in user details $item ');
        setState(() {
          responseLoading = false;
        });
        context.goNamed("root", pathParameters: {});

        // pushAndRemoveUntil(HomePage());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) => MultiProvider(
        //       providers: [
        //         ChangeNotifierProvider(
        //           create: (context) => mc.MenuController(),
        //         ),
        //       ],
        //       child: MainScreen(),
        //     ),
        //   ),
        // );
      } else {
        showSuccessToast("You are not authorized to use this dashboard!");
        setState(() {
          responseLoading = false;
        });
      }
    } else if (response.statusCode == 409) {
      setState(() {
        responseLoading = false;
      });
      showWarningToast("User account not activated.");
    } else {
      setState(() {
        responseLoading = false;
      });
      showErrorToast("Authentication failure.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BootstrapContainer(
        fluid: true,
        children: [
          BootstrapRow(
            children: <BootstrapCol>[
              BootstrapCol(
                sizes: "col-sm-12 col-md-12 col-lg-6",
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.3,
                          margin: const EdgeInsets.only(
                            // top: 10.0,
                            bottom: 16.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign In",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () => context
                                    .goNamed("signup", pathParameters: {}),
                                // onTap: () => push(const SignUpPage()),
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Register Here",
                                        style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: this.emailController,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: AppConstants.secondaryColor,
                                    ),
                                    hintText: "Enter your email address",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppConstants.primaryColor),
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: AppConstants.primaryColor)),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock_open_outlined,
                                      color: AppConstants.secondaryColor,
                                    ),
                                    suffixIcon: obscurePassword
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                obscurePassword =
                                                    !obscurePassword;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.visibility_off_outlined,
                                              color: AppConstants.primaryColor,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                obscurePassword =
                                                    !obscurePassword;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.visibility_outlined,
                                              color: AppConstants.primaryColor,
                                            ),
                                          ),
                                    hintText: "Enter your password",
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppConstants.primaryColor),
                                    ),
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                        color: AppConstants.primaryColor)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.1,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          semanticLabel: "Remember Me",
                                          value: rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              rememberMe = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Remember Me',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  responseLoading
                                      ? SizedBox(
                                          height: 35,
                                          width: 35,
                                          child: CircularProgressIndicator(),
                                        )
                                      : Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              emailController.text.isNotEmpty &&
                                                      passwordController
                                                          .text.isNotEmpty
                                                  ? _login(emailController.text,
                                                      passwordController.text)
                                                  : showInfoToast(
                                                      'Fill in the email address and password');
                                              ;
                                              // openOtpAlertBox();
                                              // pushAndRemoveUntil(const HomePage());
                                            },
                                            child: const Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: AppConstants
                                                      .secondaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                              backgroundColor:
                                                  AppConstants.primaryColor,
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              BootstrapCol(
                sizes: "col-sm-12 col-md-12 col-lg-6",
                child: Container(
                  // height: height * 8,
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppConstants.primaryColor),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .55,
                        // width: width * .3,
                        child: Image.asset("assets/images/loginvectorblue.png"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            // height: 150,
                            width: 80,
                            child:
                                Image.asset("assets/images/entebbemlogo.png"),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "DRAMMP - Entebbe",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Digital Revenue Assurance & Mobility Managment Platorm",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  openOtpAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: Image.asset("assets/images/otpvector.png"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "OTP Verification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter the 5 digit code sent to ********0862",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OtpTextField(
                      numberOfFields: 5,
                      borderColor: Colors.amber,
                      enabledBorderColor: AppConstants.secondaryColor,
                      focusedBorderColor: AppConstants.primaryColor,
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: Text("Verification Code"),
                        //         content:
                        //             Text('Code entered is $verificationCode'),
                        //       );
                        //     });
                      }, // end onSubmit
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed("root", pathParameters: {});
                          // pushAndRemoveUntil(HomePage());
                        },
                        child: const Text(
                          'Verify',
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
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: "Didn't receive the OTP? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
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
        });
  }
}
