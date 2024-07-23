import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dataLayer/constants/variables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class helpButtons extends StatelessWidget {
  const helpButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            if (!await launchUrl(Uri.parse('tel:123'))) {
              throw 'Could not launch url'.tr;
            }
          },
          child: Container(
            width: 110,
            height: 30,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: mainColor,
            ),
            child: Center(
              child: Text(
                'ambulance'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appWhite,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            if (!await launchUrl(Uri.parse('tel:122'))) {
              throw 'Could not launch url'.tr;
            }
            // Get.to(() => mainPackageInsurance());
          },
          child: Container(
            width: 110,
            height: 30,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: mainColor,
            ),
            child: Center(
              child: Text(
                'police'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appWhite,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
