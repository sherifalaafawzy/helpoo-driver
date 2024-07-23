import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/utils.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../widgets/round_button.dart';
import '../../widgets/willPopScopeWidget.dart';
import 'otpPage.dart';

class RegisterNumber extends StatefulWidget {
  const RegisterNumber({Key? key}) : super(key: key);

  @override
  State<RegisterNumber> createState() => _RegisterNumberState();
}

class _RegisterNumberState extends State<RegisterNumber> {
  var fk = GlobalKey<FormState>();
  bool workingButton = false;
  TextEditingController mobileCtrl = TextEditingController();
  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    return willPopScopeWidget(
      onWillPop: () async {
        CurrentUser.clearUser();
        setState(() {
          mobileCtrl.text = "";
        });
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          leading: Container(
            height: 48,
            width: 48,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Utils.closeKeyboard(context);
                  CurrentUser.clearUser();
                  setState(() {
                    mobileCtrl.text = "";
                  });
                  Get.back();
                },
                icon: Icon(
                  CurrentUser.isArabic
                      ? MdiIcons.arrowRightThin
                      : MdiIcons.arrowLeftThin,
                  color: appWhite,
                ),
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "register new account".tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appWhite,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: fk,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 69,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 39.0),
                    child: SizedBox(
                      height: 84,
                      child: Image.asset('assets/imgs/newLogo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 59,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38.0),
                    child: Text("enter registered phone".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                        ),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 38.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              CurrentUser.userName = number.phoneNumber;
                              CurrentUser.phoneNumber = number.phoneNumber;
                              CurrentUser.countryCode = number.dialCode;
                            });
                          },
                          // maxLength: 11,
                          hintText: 'phone number'.tr,
                          textAlign: TextAlign.left,
                          textFieldController: mobileCtrl,
                          countries: ["EG", ""],
                          errorMessage: "Invalid number".tr,
                          initialValue: PhoneNumber(isoCode: 'EG'),
                          validator: (value) {
                            debugPrint('Phone ::  ${value}');
                            debugPrint(
                                'Length :: ${value?.replaceAll(' ', '').length ?? 0}');
                            if (value!.isEmpty) {
                              debugPrint('111111111111111110');
                              return "Invalid number".tr;
                            } else if (value.startsWith('0') &&
                                value.replaceAll(' ', '').length != 11) {
                              debugPrint('2222222222222222');
                              return "Invalid number".tr;
                            } else if (!value.startsWith('0') &&
                                value.replaceAll(' ', '').length != 10) {
                              debugPrint('333333333333333');
                              return "Invalid number".tr;
                            }
                            return null;
                          },
                          inputDecoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'phone number'.tr,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: RoundButton(
                      onPressed: clickable
                          ? () async {
                              if (fk.currentState!.validate()) {
                                setState(() {
                                  clickable = false;
                                });
                                if (workingButton == false) {
                                  String exist = await CurrentUser.checkExist();

                                  debugPrint('exist :: $exist');

                                  // 1. not exist
                                  //2. exist and active
                                  //3 exist and inactive

                                  if (exist == "1") {
                                    bool success = await CurrentUser.sendOTP();
                                    if (success) {
                                      Get.to(() => OtpPage(
                                          forgetPass: false,
                                          integration: false));
                                      setState(() {
                                        clickable = true;
                                      });
                                    } else {
                                      HelpooInAppNotification.showErrorMessage(
                                          message: 'Something Went Wrong'.tr);
                                      // Get.snackbar("error".tr,
                                      // 'Something Went Wrong'.tr);
                                      setState(() {
                                        clickable = true;
                                      });
                                    }
                                    setState(() {
                                      workingButton = false;
                                    });
                                  } else if (exist == "2") {
                                    bool success = await CurrentUser.sendOTP();
                                    if (success) {
                                      Get.to(() => OtpPage(
                                          forgetPass: true,
                                          integration: false));
                                      setState(() {
                                        clickable = true;
                                      });
                                    } else {
                                      HelpooInAppNotification.showErrorMessage(
                                          message: 'Something Went Wrong'.tr);
                                      // Get.snackbar("error".tr,
                                      //     'Something Went Wrong'.tr);
                                      setState(() {
                                        clickable = true;
                                      });
                                    }
                                    setState(() {
                                      workingButton = false;
                                    });
                                    // Get.snackbar(
                                    //     "error".tr, 'User already exist'.tr);

                                    // setState(() {
                                    //   clickable = true;
                                    // });
                                  } else if (exist == "3") {
                                    bool success = await CurrentUser.sendOTP();
                                    if (success) {
                                      Get.to(() => OtpPage(
                                          forgetPass: true,
                                          integration: false));
                                      setState(() {
                                        clickable = true;
                                      });
                                    } else {
                                      HelpooInAppNotification.showErrorMessage(
                                          message: 'Something Went Wrong'.tr);
                                      // Get.snackbar("error".tr,
                                      //     'Something Went Wrong'.tr);
                                      setState(() {
                                        clickable = true;
                                      });
                                    }
                                    setState(() {
                                      workingButton = false;
                                    });
                                    // Get.snackbar(
                                    //     "error".tr, 'User already exist'.tr);

                                    // setState(() {
                                    //   clickable = true;
                                    // });

                                    // bool success = await CurrentUser.sendOTP();
                                    // if (success) {
                                    //   Get.to(() => OtpPage(
                                    //       forgetPass: true, integration: true));
                                    //   setState(() {
                                    //     clickable = true;
                                    //   });
                                    // } else {
                                    //   Get.snackbar(
                                    //       "error".tr, 'Something Went Wrong'.tr);
                                    //   setState(() {
                                    //     clickable = true;
                                    //   });
                                    // }
                                  } else {
                                    HelpooInAppNotification.showErrorMessage(
                                        message: 'Something Went Wrong'.tr);
                                    // Get.snackbar(
                                    //     "error".tr, 'Something went wrong'.tr);
                                    setState(() {
                                      clickable = true;
                                    });
                                  }
                                }
                              }
                            }
                          : () {},
                      padding: true,
                      text: clickable ? 'confirm'.tr : "Loading......".tr,
                      color: mainColor,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
