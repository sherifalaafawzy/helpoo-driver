import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../dataLayer/Constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import 'homeScreen.dart';
import '../widgets/round_button.dart';
import 'forgetPass.dart';
import 'welcome.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> fk = GlobalKey<FormState>();
  final GetStorage prefs = GetStorage();
  String? name = '';
  bool showConfirmPass = false;
  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => welcome());
        return false;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: appWhite,
        appBar: AppBar(
          backgroundColor: appWhite,
          actionsIconTheme: IconThemeData(
            color: mainColor,
          ),
          elevation: 0,
          centerTitle: true,
          leading: Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Utils.closeKeyboard(context);
                  Get.offAll(() => welcome());
                },
                child: Icon(
                  CurrentUser.isEnglish
                      ? MdiIcons.arrowLeftThin
                      : MdiIcons.arrowRightThin,
                  color: mainColor,
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: appWhite,
                    padding: EdgeInsets.all(8),
                    elevation: 0),
              ),
            ),
          ),
          title: SizedBox(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: fk,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: Get.height / 7,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 39.0),
                    child: SizedBox(
                      height: 60,
                      child: Image.asset('assets/imgs/newLogo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                        ),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 38.0,
                    ),
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-z A-Z 0-9]'))
                      ],
                      validator: (val) {
                        if (val == null || val.length < 3) {
                          return 'Wrong Phone Number'.tr;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: appInput.copyWith(
                        counterText: '',
                      ),
                      onChanged: (v) {
                        setState(() {
                          CurrentUser.userName = v;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 39.0,
                    ),
                    child: Text(
                      "password".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                        ),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 38.0,
                    ),
                    child: TextFormField(
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(
                      //       RegExp('[a-z A-Z 0-9]'))
                      // ],
                      obscureText: !showConfirmPass,
                      validator: (val) {
                        if (val == null) {
                          return 'required field'.tr;
                        } else if (val.length < 7) {
                          return 'password length'.tr;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: appInput.copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirmPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirmPass = !showConfirmPass;
                            });
                          },
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          CurrentUser.password = v;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => ForgotPasswordPage()),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 39.0,
                      ),
                      child: Text(
                        "forgot password?".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0,
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: Get.width,
                    child: RoundButton(
                      onPressed: () async {
                        if (fk.currentState!.validate()) {
                          setState(() {
                            clickable = false;
                          });
                          String success = await CurrentUser.userSignIn();
                          if (success == "Done") {
                            prefs.write('userName', CurrentUser.userName);
                            prefs.write('pass', CurrentUser.password);

                            setState(() {
                              CurrentUser.isLoggedIn = true;
                            });

                            Get.to(() => homeScreen(
                                  index: 0,
                                ));
                          } else {
                            setState(() {
                              clickable = true;
                            });
                          }
                        } else {
                          setState(() {
                            clickable = true;
                          });
                        }
                      },
                      padding: true,
                      text: clickable ? 'Login'.tr : "Loading......".tr,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
