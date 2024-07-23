// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../dataLayer/constants/variables.dart';
import '../../../../../dataLayer/models/currentUser.dart';
import '../widgets/round_button.dart';

class paymentConfirmation extends StatefulWidget {
  paymentConfirmation({Key? key}) : super(key: key);

  @override
  State<paymentConfirmation> createState() => paymentConfirmationState();
}

class paymentConfirmationState extends State<paymentConfirmation> {
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
          title: Text(
            "Payment Success".tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appWhite,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
          leading: Container(
            height: 48,
            width: 48,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Get.to(() => homeScreen(index: 0));
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(children: [
            Container(
              height: Get.height * .05,
              width: Get.width * .8,
              child: Center(
                child: Text(
                  "Subscribtion Done Successfully".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: mainColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/imgs/paid-logo.png',
                  height: 190, width: Get.width),
            ),
            SizedBox(
              width: Get.width * .8,
              child: Text(
                "You Can Add Cars Now".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: Get.width * .4,
                      child: RoundButton(
                          onPressed: () async {
                            Get.to(() => homeScreen(index: 1,));
                          },
                          padding: false,
                          text: 'Yes Now'.tr,
                          color: mainColor)),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: Get.width * .4,
                    child: RoundButton(
                        onPressed: () async {
                          Get.to(() => homeScreen(
                                index: 0,
                              ));
                        },
                        padding: false,
                        text: 'Later'.tr,
                        color: appBlack),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
