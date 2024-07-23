import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dataLayer/constants/variables.dart';

class serviceNotAvaliable extends StatelessWidget {
  const serviceNotAvaliable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appWhite,
      padding: const EdgeInsets.all(39.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/warning.png',
              height: 120,
            ),
            const SizedBox(
              height: 27,
            ),
            Text(
              'not available yet'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 22.0,
                ),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
