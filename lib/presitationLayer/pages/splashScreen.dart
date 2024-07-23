import 'dart:async';
import 'dart:io';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/presitationLayer/pages/welcome.dart';
import 'package:helpoo/service_request/core/di/injection.dart';
import 'package:helpoo/service_request/core/network/local/cache_helper.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:helpoo/service_request/core/util/utils.dart';
import '../../dataLayer/constants/variables.dart';
import 'shared/language_selection_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../dataLayer/models/currentUser.dart';
import 'homeScreen.dart';

class SplashFuturePage extends StatefulWidget {
  SplashFuturePage({Key? key}) : super(key: key);

  @override
  _SplashFuturePageState createState() => _SplashFuturePageState();
}

class _SplashFuturePageState extends State<SplashFuturePage> {
  @override
  void initState() {
    setState(() {
      CurrentUser.language = prefs.read("lang") ?? "";
    });

    // getAppConfig();
    startAppFlow();
    debugPrint('start init state in splash page');
    super.initState();
  }

  Future<void> getAppConfig() async {
    await sRBloc.getConfig();
    if (sRBloc.config != null) {
      if (sRBloc.config?.underMaintaining ?? false) {
        Utils.showUpdateDialog(navigatorKey.currentContext!,
            isUnderMaintenance: true);
      } else {
        if (Platform.isAndroid) {
          PackageInfo.fromPlatform().then(
            (deviceInfo) {
              printWarning('Android version is => ${deviceInfo.version}');
              printWarning(
                  'minAndroidVersion is => ${sRBloc.config?.minimumAndroidVersion}');
              if (Utils.checkAndroidVersionUpdate(
                  appVersionNum: deviceInfo.version,
                  minAndroidVersionApp:
                      sRBloc.config?.minimumAndroidVersion ?? '0')) {
                Utils.showUpdateDialog(navigatorKey.currentContext!);
              } else {
                startAppFlow();
              }
            },
          );
        } else if (Platform.isIOS) {
          PackageInfo.fromPlatform().then(
            (deviceInfo) {
              printWarning('IOS version is ${deviceInfo.version}');
              printWarning(
                  'minIOSVersion is => ${sRBloc.config?.minimumIOSVersion}');
              if (Utils.checkIosVersionUpdate(
                  appVersionNum: deviceInfo.version,
                  minIosVersionApp: sRBloc.config?.minimumIOSVersion ?? '0')) {
                Utils.showUpdateDialog(navigatorKey.currentContext!);
              } else {
                startAppFlow();
              }
            },
          );
        } else {
          HelpooInAppNotification.showErrorMessage(
              message: 'Unknown device'.tr);
        }
      }
    }
  }

  GetStorage prefs = GetStorage();
  String str = "";

  // autoLogIn() async {
  //   CurrentUser.userName = prefs.read('userName') ?? "";
  //   CurrentUser.password = prefs.read('pass') ?? "";
  //
  //   if (CurrentUser.userName != "" && CurrentUser.password != "") {
  //     setState(() {
  //       CurrentUser.isLoggedIn = true;
  //     });
  //     String success = await CurrentUser.userSignIn();
  //     if (success == "Done") {
  //       Get.offAll(() => homeScreen(
  //             index: 0,
  //           ));
  //       setState(() {
  //         CurrentUser.working = false;
  //       });
  //     } else {
  //       checkFirstSeen();
  //     }
  //   } else {
  //     checkFirstSeen();
  //   }
  // }

  // Future checkFirstSeen() async {
  //   str = await prefs.read("seen") ?? "";
  //   bool _seen = str.isNotEmpty;
  //
  //   if (_seen == false) {
  //     setState(() {
  //       CurrentUser.working = false;
  //     });
  //     Get.offAll(() => languageSelection());
  //   } else {
  //     Get.offAll(() => languageSelection());
  //   }
  //   setState(() {
  //     CurrentUser.working = false;
  //   });
  // }

  void startAppFlow() async {
    bool? isFirstTime = await sl<CacheHelper>().get(Keys.firstTime);
    if (isFirstTime ?? true) {
      sl<CacheHelper>().put(Keys.firstTime, false);
      printWarning("first time");
      setState(() {
        CurrentUser.working = false;
      });
      Get.offAll(() => languageSelection());
    } else {
      if (CurrentUser.isLoggedIn) {
        printWarning("not first time and logged in");
        CurrentUser.userName = prefs.read('userName') ?? "";
        CurrentUser.password = prefs.read('pass') ?? "";
        printWarning("user name: ${CurrentUser.userName}");
        printWarning("user name: ${CurrentUser.password}");
        if (CurrentUser.userName != "" && CurrentUser.password != "") {
          setState(() {
            CurrentUser.isLoggedIn = true;
          });

          String success = await CurrentUser.userSignIn();
          printWarning("userSignIn: ${success}");
          if (success == "Done") {
            Get.offAll(
              () => homeScreen(
                index: 0,
              ),
            );
            setState(() {
              CurrentUser.working = false;
            });
          } else {
            printWarning("===>>> Sign in Failure");
            prefs.write("userName", "");
            prefs.write("pass", "");
            setState(() {
              CurrentUser.isLoggedIn = false;
            });
            Get.offAll(() => welcome());
          }
        } else {
          printWarning("user name and Password ==''");
          prefs.write("userName", "");
          prefs.write("pass", "");
          setState(() {
            CurrentUser.isLoggedIn = false;
          });
          Get.offAll(() => welcome());
        }
      } else {
        printWarning("not first time and not logged in");
        Get.offAll(() => welcome());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: EasySplashScreen(
        logo: Image.asset(
          'assets/imgs/newLogo.png',
          width: 300,
          height: 90,
        ),
        logoWidth: 200,

        backgroundColor: appWhite,
        showLoader: false,
        // showLoader: true,
        // loadingText: Text("Loading..."),
        // futureNavigator: autoLogIn(),
      ),
    );
  }
}
