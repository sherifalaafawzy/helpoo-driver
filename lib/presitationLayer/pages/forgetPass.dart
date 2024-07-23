import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../dataLayer/models/currentUser.dart';
import 'register/otpPage.dart';

import '../../dataLayer/constants/variables.dart';
import '../widgets/round_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var fk = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();

  @override
  void initState() {
    CurrentUser.clearUser();
    super.initState();
  }

  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "reset password page".tr,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                color: appWhite,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        body: Form(
          key: fk,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.0),
                  child: Text("please enter phone number".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                      textAlign: TextAlign.center),
                ),
                SizedBox(
                  height: 79,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 39.0,
                  ),
                  child: Text(
                    "phone number".tr,
                    style: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 38.0,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                            CurrentUser.countryCode = number.dialCode;
                            CurrentUser.phoneNumber = number.phoneNumber;
                          });
                        },
                        // maxLength: 11,
                        textAlign: TextAlign.left,
                        textFieldController: mobileCtrl,
                        countries: ["EG", ""],
                        hintText: 'phone number'.tr,
                        errorMessage: "Invalid phone number",
                        initialValue: PhoneNumber(isoCode: 'EG'),
                        // validator: (value) {
                        //   debugPrint('Phone ::  ${value}');
                        //   debugPrint(
                        //       '${value?.length ?? 0} ***********************');
                        //   if (value!.isEmpty) {
                        //     debugPrint('111111111111111110');
                        //     return "Invalid number".tr;
                        //   } else if (value.startsWith('0') &&
                        //       value.length != 11) {
                        //     debugPrint('2222222222222222');
                        //     return "Invalid number".tr;
                        //   } else if (!value.startsWith('0') &&
                        //       value.length != 12) {
                        //     debugPrint('333333333333333');
                        //
                        //     return "Invalid number".tr;
                        //   }
                        //   return null;
                        // },
                        inputDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'phone number'.tr,
                        ),
                      ),
                    ),
                  ),

                  //  TextFormField(
                  //   inputFormatters: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                  //   ],
                  //   controller: mobileCtrl,
                  //   textAlign: TextAlign.center,
                  //   maxLength: 11,
                  //   validator: (v) {
                  //     if (v == null || v.length != 11) {
                  //       return "Wrong Phone Number".tr;
                  //     }
                  //     var start = v.substring(0, 3);
                  //     if (start != "010" &&
                  //         start != "011" &&
                  //         start != "012" &&
                  //         start != "015") {
                  //       return "invalid phone number".tr;
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (v) {
                  //     setState(() {
                  //       CurrentUser.phoneNumber = v;
                  //     });
                  //   },
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //     counterText: '',
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(12),
                  //       ),
                  //       borderSide: BorderSide(
                  //         color: Colors.grey,
                  //         width: 1,
                  //       ),
                  //     ),
                  //     contentPadding: EdgeInsets.all(8),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(12),
                  //       ),
                  //       borderSide: BorderSide(
                  //         color: Colors.grey,
                  //         width: 1,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: Get.width,
                  child: RoundButton(
                    onPressed: clickable ? () async {
                      if (mobileCtrl.text.isEmpty) {
                        return;
                      } else {
                        setState(() {
                          clickable = false;
                        });
                        bool success = await CurrentUser.resetPass();
                        if (success) {
                          Get.to(() => OtpPage(
                                forgetPass: true,
                                integration: false,
                              ));
                          setState(() {
                            clickable = true;
                          });
                        } else {
                          setState(() {
                            clickable = true;
                          });
                        }
                      }
                    } : (){},
                    padding: true,
                    text: clickable ? 'continue'.tr : "Loading......".tr,
                    color: mainColor,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
