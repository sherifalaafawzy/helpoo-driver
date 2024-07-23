import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dataLayer/models/vehicle.dart';
import '../../dataLayer/models/currentUser.dart';

import '../../dataLayer/constants/variables.dart';

class phoneInput extends StatefulWidget {
  const phoneInput({Key? key}) : super(key: key);

  @override
  State<phoneInput> createState() => _phoneInputState();
}

class _phoneInputState extends State<phoneInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: RichText(
            text: TextSpan(
              text: CurrentUser.isCorporate
                  ? 'customer phone'.tr
                  : 'phone number'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: " *",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
            ],
            // controller: phoneCtrl,
            onChanged: (v) {
              setState(() {
                Vehicle.phone = v;
              });
            },
            validator: (v) {
              if (v == null || v.isEmpty) {
                return "required field".tr;
              }
              return null;
            },
            decoration: appInput,
          ),
        ),
      ],
    );
  }
}
