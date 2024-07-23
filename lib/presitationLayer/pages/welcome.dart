import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import '../widgets/round_button.dart';
import 'login_page.dart';
import 'register/registerNumber.dart';
import 'shared/language_selection_page.dart';
import 'shared/waitingPage.dart';

import 'package:platform_device_id/platform_device_id.dart';


class welcome extends StatefulWidget {
  welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => welcomeState();
}

class welcomeState extends State<welcome> {
  GetStorage prefs = GetStorage();
  String str = "";
  // bool working = true;
  Future checkFirstSeen() async {
    str = await prefs.read("seen") ?? "";
    bool _seen = str.isNotEmpty;

    if (_seen == false) {
      setState(() {
        CurrentUser.working = false;
      });
      Get.to(() => languageSelection());
      // Get.to(() => Intro());
    }
    setState(() {
      CurrentUser.working = false;
    });
  }

  // autoLogIn() async {
  //   CurrentUser.userName = prefs.read('userName') ?? "";
  //   CurrentUser.password = prefs.read('pass') ?? "";

  //   if (CurrentUser.userName != "") {
  //     setState(() {
  //       CurrentUser.isLoggedIn = true;
  //     });
  //     String success = await CurrentUser.userSignIn();
  //     if (success == "Done") {
  //       Get.to(() => homeScreen(
  //             index: 0,
  //           ));
  //       setState(() {
  //         CurrentUser.working = false;
  //       });
  //     }
  //   } else {
  //     checkFirstSeen();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      CurrentUser.language = prefs.read("lang") ?? "";
    });
    // autoLogIn();
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    if (CurrentUser.working) {
      return waitingWidget();
    } else {
      return Scaffold(
        backgroundColor: appWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 46.0),
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () async {
                    if(_counter < 10) {
                      _counter++;
                    } else {
                      _counter = 0;

                      String? imei = await PlatformDeviceId.getDeviceId;

                      Clipboard.setData(
                        ClipboardData(
                          text: imei ?? '',
                        ),
                      );

                      // show snackbar
                      HelpooInAppNotification.showSuccessMessage(
                        duration: Duration(seconds: 2),
                        message: 'IMEI Copied to clipboard',
                      );
                    }
                  },
                  child: SizedBox(
                    height: 84,
                    child: Image.asset('assets/imgs/newLogo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'معاك في الطريق',
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.normal,
                    fontSize: 30.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              SizedBox(
                  width: Get.width,
                  child: RoundButton(
                    onPressed: () => Get.to(
                      () => LoginPage(),
                    ),
                    padding: true,
                    text: 'Login'.tr,
                    color: mainColor,
                  )),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: Get.width,
                child: RoundButton(
                  onPressed: () => Get.to(
                    () => RegisterNumber(),
                  ),
                  padding: true,
                  text: 'Register New Account'.tr,
                  color: mainColor,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "or".tr,
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Get.height * .02,
              ),
              SizedBox(
                  height: Get.height * .22,
                  child: GestureDetector(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse('tel:17000'))) {
                        HelpooInAppNotification.showErrorMessage(
                            message: "Could not Make Call".tr);
                        // Get.snackbar("Error".tr, "Could not Make Call");
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/imgs/callCenter.png'),
                        RoundButton(
                          onPressed: () async {
                            if (!await launchUrl(Uri.parse('tel:17000'))) {
                              HelpooInAppNotification.showErrorMessage(
                                  message: "Could not Make Call".tr);
                              // Get.snackbar("Error".tr, "Could not Make Call");
                            }
                          },
                          padding: false,
                          text: 'Call 17000'.tr,
                          color: mainColor,
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    }
  }
}
