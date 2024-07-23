import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../widgets/round_button.dart';
import 'setPassword.dart';

class OtpPage extends StatefulWidget {
  final bool forgetPass;
  final bool integration;

  const OtpPage({Key? key, required this.forgetPass, required this.integration})
      : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var formKey = GlobalKey<FormState>();
  int start = 60;
  Timer? timer;
  bool clickable = true;
  bool resendClickable = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (start == 0) {
          timer.cancel();
        } else {
          start--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: appWhite,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: appWhite),
            backgroundColor: mainColor,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                  CurrentUser.isArabic
                      ? MdiIcons.arrowRightThin
                      : MdiIcons.arrowLeftThin,
                  // Icons.arrow_back,
                  color: appWhite),
              onPressed: () => Get.back(),
            ),
            title: Text(
              "confirm phone number".tr,
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
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        height: 210,
                        width: 210,
                        child: Image.asset('assets/imgs/otp.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text(
                        "enter otp".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 39,
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                      ),
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container() //PinCodeTextField(
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          //     ],
                          //     validator: (v) {
                          //       if (v!.isEmpty) {
                          //         return "otp is required".tr;
                          //       } else if (v.length < 4) {
                          //         return "otp must be 4 digits".tr;
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     // errorTextDirection: TextDirection.ltr,
                          //     onCompleted: (v) {
                          //       setState(() {
                          //         CurrentUser.otp = v;
                          //       });
                          //     },
                          //     animationType: AnimationType.fade,
                          //     pinTheme: PinTheme(
                          //       shape: PinCodeFieldShape.box,
                          //       borderRadius: BorderRadius.circular(12),
                          //       fieldHeight: 53,
                          //       fieldWidth: 67,
                          //       activeFillColor: Colors.white,
                          //       activeColor: Colors.grey,
                          //       selectedColor: mainColor,
                          //       inactiveColor: Colors.grey,
                          //       fieldOuterPadding:
                          //           EdgeInsets.symmetric(horizontal: 5),
                          //     ),
                          //     animationDuration:
                          //         const Duration(milliseconds: 300),
                          //     appContext: context,
                          //     errorTextDirection: CurrentUser.isArabic
                          //         ? TextDirection.rtl
                          //         : TextDirection.ltr,
                          //     length: 4,
                          //     onChanged: (v) {
                          //       setState(() {
                          //         CurrentUser.otp = v;
                          //       });
                          //     }),
                          ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: RoundButton(
                        onPressed: clickable
                            ? () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    clickable = false;
                                  });
                                  bool success = await CurrentUser.verifyOTP();
                                  if (success) {
                                    Get.to(() => setPassword(
                                        forgetPass: widget.forgetPass,
                                        integration: widget.integration));
                                    setState(() {
                                      clickable = true;
                                    });
                                  } else {
                                    setState(() {
                                      clickable = true;
                                    });
                                  }
                                }
                              }
                            : () {},
                        padding: true,
                        text: clickable ? 'confirm'.tr : "Loading......".tr,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: RoundButton(
                        onPressed: resendClickable
                            ? () async {
                                if (start == 0) {
                                  setState(() {
                                    resendClickable = false;
                                  });
                                  bool success = await CurrentUser.sendOTP();
                                  if (success) {
                                    HelpooInAppNotification.showSuccessMessage(
                                        message: "OTP Send Succesfully".tr);
                                    // Get.snackbar(
                                    //     "Done".tr, "OTP Send Succesfully".tr);
                                    setState(() {
                                      start = 60;
                                    });
                                    startTimer();
                                    setState(() {
                                      resendClickable = true;
                                    });
                                  }
                                } else {
                                  HelpooInAppNotification.showMessage(
                                      message:
                                          "'${'please Wait'.tr} ${start} '${'Sec'.tr}");
                                }
                              }
                            : () {},
                        padding: true,
                        text:
                            resendClickable ? 'resend'.tr : "Loading......".tr,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: start != 0,
                      child: Center(
                        child: Text(
                          "${'Please Wait'.tr} ${start} ${'to Send New OTP'.tr}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]),
            ),
          )),
    );
  }
}
