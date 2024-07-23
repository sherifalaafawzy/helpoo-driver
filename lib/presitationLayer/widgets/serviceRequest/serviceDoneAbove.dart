import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dataLayer/constants/variables.dart';

class serviceDoneWidget extends StatelessWidget {
  const serviceDoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 240,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                width: 248,
                height: 27,
                decoration: const BoxDecoration(
                  color: mainColor,
                ),
                child: Center(
                  child: Text(
                    'done'.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appWhite,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
