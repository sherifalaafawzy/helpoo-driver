// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../widgets/round_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              MdiIcons.faceAgent,
              color: mainColor,
              size: 128,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "call customer support".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "17000".tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.normal,
                  fontSize: 64.0,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: RoundButton(
                        onPressed: () async {
                          if (!await launchUrl(Uri.parse('tel:17000'))) {
                            throw 'Could not launch url'.tr;
                          }
                        },
                        padding: false,
                        text: 'call'.tr,
                        color: mainColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              endIndent: 32,
              indent: 32,
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "send email".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse('mailto:support@helpooapp.com'))) {
                  throw 'Could not launch url'.tr;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.email,
                    color: mainColor,
                    size: 32,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "support@helpoo.com",
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Divider(
              endIndent: 32,
              indent: 32,
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "send whatsapp message".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                var whatsapp = "+201117750000";
                var whatsappURl_android =
                    "whatsapp://send?phone=" + whatsapp + "&text=hello";
                var whatappURL_ios =
                    "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                if (Platform.isIOS) {
                  // for iOS phone only
                  if (await canLaunch(whatappURL_ios)) {
                    await launch(whatappURL_ios, forceSafariVC: false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: new Text("whatsapp no installed".tr)));
                  }
                } else {
                  // android , web
                  if (await canLaunch(whatsappURl_android)) {
                    await launch(whatsappURl_android);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: new Text("whatsapp no installed".tr)));
                  }
                }
                // if (!await launchUrl(Uri.parse('https://wa.me/201117910000'))) {
                //   throw 'Could not launch url';
                // }
              },
              child: Icon(
                MdiIcons.whatsapp,
                size: 54,
                color: mainColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
