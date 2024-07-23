import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';

class location extends StatelessWidget {
  final FNOL fnol;

  const location({super.key, required this.fnol});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "accident location".tr,
          style: GoogleFonts.tajawal(
            textStyle: const TextStyle(
              color: appBlack,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
            ),
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            await MapsLauncher.launchCoordinates(
                double.parse(fnol.addressLatLng!.lat.toString()),
                double.parse(fnol.addressLatLng!.lng.toString()));
          },
          child: Container(
            width: Get.width * .8,
            child: Text(
              fnol.addressLatLng!.address!,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                ),
              ),
              maxLines: 3,
            ),
          ),
        ),
      ],
    );
  }
}
