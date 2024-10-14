import 'package:entebbe_dramp_web/config/base.dart';
import 'package:entebbe_dramp_web/config/constants.dart';
import 'package:entebbe_dramp_web/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends Base<SignUpPage> {
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  bool rememberMe = false;
  bool obscurePassword = true;
  String phoneNumber = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BootstrapRow(
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
                      margin: EdgeInsets.only(
                        // top: 10.0,
                        bottom: 16.0,
                        // left: width * .1,
                        // right: width * .1,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sign Up",
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
                          RichText(
                            text: const TextSpan(
                              text: "Alerady have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: "Log in Here",
                                  style: TextStyle(
                                    color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: this.nameController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: AppConstants.secondaryColor,
                                ),
                                hintText: "Enter your full name ",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppConstants.primaryColor),
                                ),
                                labelText: "Name",
                                labelStyle: TextStyle(
                                    color: AppConstants.primaryColor)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              debugPrint('On Change: ${number.phoneNumber}');
                              phoneNumber = number.phoneNumber.toString();
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
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            initialValue: number,
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
                            textFieldController: phoneController,
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),

                            onSaved: (PhoneNumber number) {
                              debugPrint('On Saved: $number');
                            },
                          ),
                          const SizedBox(
                            height: 10,
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
                                  borderSide: BorderSide(color: Colors.grey),
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
                            height: 10,
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.lock_open_outlined),
                                  color: AppConstants.secondaryColor,
                                ),
                                suffixIcon: obscurePassword
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscurePassword = !obscurePassword;
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
                                            obscurePassword = !obscurePassword;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          color: AppConstants.primaryColor,
                                        ),
                                      ),
                                hintText: "Enter your password",
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
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
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.lock_open_outlined),
                                  color: AppConstants.secondaryColor,
                                ),
                                suffixIcon: obscurePassword
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscurePassword = !obscurePassword;
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
                                            obscurePassword = !obscurePassword;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          color: AppConstants.primaryColor,
                                        ),
                                      ),
                                hintText: "Confirm password",
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppConstants.primaryColor),
                                ),
                                labelText: "Confirm Password",
                                labelStyle: const TextStyle(
                                    color: AppConstants.primaryColor)),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    openOtpAlertBox();
                                    // push(const HomePage());
                                  },
                                  child: const Text(
                                    'Register',
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
                    child: Image.asset("assets/images/loginvector.png"),
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
                        width: 160,
                        child: Image.asset("assets/images/entebbelogo.png"),
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
                          push(HomePage());
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
