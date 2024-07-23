//create class Utils
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/widgets/round_button.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  ///* Open URL in browser
  static Future openUrl(String url) async {
    printMe(url);
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      printMeLog(e);
    }
  }

  ///* Check if the app version need to Update (IOS)
  static bool checkIosVersionUpdate(
      {required String appVersionNum, required String minIosVersionApp}) {
    List<int> appVersionList =
        appVersionNum.split('.').map((e) => int.parse(e)).toList();

    List<int> minIosVersionAppList = minIosVersionApp.split('.').map((e) {
      debugPrint('minIosVersionAppList: $e');
      return int.parse(e);
    }).toList();
    bool needToUpdate = false;

    for (var i = 0; i < appVersionList.length; i++) {
      if (appVersionList[i] < minIosVersionAppList[i]) {
        needToUpdate = true;
        break;
      }
    }
    return needToUpdate;
  }

  ///* Check if the app version need to Update (Android)
  static bool checkAndroidVersionUpdate(
      {required String appVersionNum, required String minAndroidVersionApp}) {
    List<int> appVersionList =
        appVersionNum.split('.').map((e) => int.parse(e)).toList();
    List<int> minAndroidVersionAppList =
        minAndroidVersionApp.split('.').map((e) => int.parse(e)).toList();
    bool needToUpdate = false;

    for (var i = 0; i < appVersionList.length; i++) {
      if (appVersionList[i] < minAndroidVersionAppList[i]) {
        needToUpdate = true;
        break;
      }
    }
    return needToUpdate;
  }

  static void showUpdateDialog(BuildContext context,
      {bool isUnderMaintenance = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Image.asset(
            'assets/imgs/newLogo.png',
            // width: 150,
            height: 150,
          ),
          content: Text(
            isUnderMaintenance
                ? 'The app is under maintenance. Please Contact the call center'
                    .tr
                : 'A new update is available. Please update the app to enjoy the latest features.'
                    .tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
              ),
            ),
          ),
          actions: <Widget>[
            if (isUnderMaintenance) ...[
              SizedBox(
                width: double.infinity,
                child: RoundButton(
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse('tel:17000'))) {
                      HelpooInAppNotification.showErrorMessage(
                          message: "Could not Make Call");
                    }
                  },
                  padding: false,
                  text: 'Call 17000'.tr,
                  color: mainColorHex,
                ),
              )
            ] else ...[
              if (Platform.isAndroid) ...[
                SizedBox(
                  width: double.infinity,
                  child: RoundButton(
                    onPressed: () {
                      Utils.openUrl(
                        "https://play.google.com/store/apps/details?id=com.helpoo.app",
                      );
                    },
                    padding: false,
                    text: "Update".tr,
                    color: mainColorHex,
                  ),
                )
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: RoundButton(
                    onPressed: () {
                      Utils.openUrl(
                        "https://apps.apple.com/eg/app/helpoo/id1627316561",
                      );
                    },
                    padding: false,
                    text: "Update".tr,
                    color: mainColorHex,
                  ),
                )
              ],
            ],
          ],
        );
      },
    );
  }
}
