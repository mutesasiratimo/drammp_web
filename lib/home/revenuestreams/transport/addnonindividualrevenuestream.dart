// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../config/constants.dart';

class AddNonIndividualRevenueStreamPgae extends StatefulWidget {
  final String category;
  final String ownerType;
  const AddNonIndividualRevenueStreamPgae({
    super.key,
    required this.category,
    required this.ownerType,
  });

  @override
  State<AddNonIndividualRevenueStreamPgae> createState() =>
      _AddNonIndividualRevenueStreamPgaeState();
}

class _AddNonIndividualRevenueStreamPgaeState
    extends State<AddNonIndividualRevenueStreamPgae> {
  PageController addRevenueStreamPageController = PageController();
  int page = 0;
  int counter = 3;
  List list = [0, 1, 2];
  String selectedOwnership = "";
  String selectedDoesOwnerOperate = "";
  List<String> ownerType = ["Individual", "Non-Individual"];
  List<String> doesOwnerOperate = ["No", "Yes"];
  List<String> districts = [];
  List<String> counties = [];
  List<String> subcounties = [];
  List<String> parishes = [];
  List<String> villages = [];

  PhoneNumber ownerNumber = PhoneNumber(isoCode: 'UG');
  PhoneNumber driverNumber = PhoneNumber(isoCode: 'UG');
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
  String selectedStageDistrict = "",
      selectedStageCounty = "",
      selectedStageSubcounty = "",
      selectedStageParish = "",
      selectedStageVillage = "";
  TextEditingController ownerNinController = TextEditingController(),
      ownerPassportNumberController = TextEditingController(),
      ownerNameController = TextEditingController(),
      ownerEmailController = TextEditingController();
  TextEditingController driverNinController = TextEditingController(),
      driverPassportNumberController = TextEditingController(),
      driverNameController = TextEditingController(),
      driverEmailController = TextEditingController(),
      stageNameController = TextEditingController(),
      regNoController = TextEditingController(),
      makeModelController = TextEditingController(),
      colorController = TextEditingController(),
      chassisNoController = TextEditingController();

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
            // SizedBox(
            //   width: double.maxFinite,
            //   height: 30,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 7),
            //     child: FlutterStepIndicator(
            //       height: 28,
            //       paddingLine: const EdgeInsets.symmetric(horizontal: 0),
            //       positiveColor: const Color(0xFF00B551),
            //       progressColor: const Color(0xFFEA9C00),
            //       negativeColor: const Color(0xFFD5D5D5),
            //       padding: const EdgeInsets.all(4),
            //       list: [
            //         Container(child: Text("One")),
            //         Container(child: Text("Two")),
            //         Container(child: Text("Three")),
            //       ],
            //       division: counter,
            //       onChange: (i) {},
            //       page: page,
            //       onClickItem: (p0) {
            //         setState(() {
            //           page = p0;
            //         });
            //       },
            //     ),
            //   ),
            // ),
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
                page < 2
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
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Register ${widget.ownerType} ${widget.category}",
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
              height: MediaQuery.of(context).size.height * .63,
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
                ],
              ),
            ),
            _stepper(),
          ],
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
                'Personal Information (Owner)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'NIN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
                    controller: ownerNinController,
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Passport/Refugee Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
                    controller: ownerPassportNumberController,
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Full name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
                    controller: ownerNameController,
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Phone number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: InternationalPhoneNumberInput(
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
                'Residential Information (Owner)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select District',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select County/Muncipality',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Subcounty/Town Council',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Parish/Ward',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Village',
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Reg No/Number Plate',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Make-Model',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Chassis Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Does owner operate vehicle?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
                            selectedDoesOwnerOperate,
                            style: const TextStyle(
                                // color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: doesOwnerOperate.map((item) {
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
                        List itemsList = doesOwnerOperate.map((item) {
                          if (item == newVal) {
                            setState(() {
                              selectedDoesOwnerOperate = item;
                              debugPrint(selectedDoesOwnerOperate);
                            });
                          }
                        }).toList();
                      },
                    ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Personal Information (Driver)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'NIN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Passport/Refugee Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Full name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: TextFormField(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Phone number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: InternationalPhoneNumberInput(
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select District',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select County/Muncipality',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Subcounty/Town Council',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Parish/Ward',
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
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Village',
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
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select County/Muncipality',
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
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Subcounty/Town Council',
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
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Parish/Ward',
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
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Select Village',
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
                              debugPrint(selectedOwnership);
                            });
                          }
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 32.0),
                child: ListTile(
                  title: Text(
                    'Stage Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: TextFormField(
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
                            debugPrint(selectedOwnership);
                          });
                        }
                      }).toList();
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
                            debugPrint(selectedOwnership);
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
                            debugPrint(selectedOwnership);
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
                            debugPrint(selectedOwnership);
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
                            debugPrint(selectedOwnership);
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
          width: 5,
          child: VerticalDivider(
            width: 1,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Register New ${widget.ownerType} ${widget.category}?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
