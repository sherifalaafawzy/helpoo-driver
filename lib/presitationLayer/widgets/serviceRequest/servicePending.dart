import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dataLayer/constants/variables.dart';
import 'request_details_container_widget.dart';

class servicePending extends StatelessWidget {
  const servicePending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return RequestDetailsContainerWidget(
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Text(
                'Wrong Car, Please Call 17000'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
