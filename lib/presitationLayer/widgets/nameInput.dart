import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/models/vehicle.dart';

class nameInput extends StatefulWidget {
  const nameInput({
    Key? key,
  }) : super(key: key);

  @override
  State<nameInput> createState() => _nameInputState();
}

class _nameInputState extends State<nameInput> {
  TextEditingController nameCtrl = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: RichText(
            text: TextSpan(
              text:
                  CurrentUser.isCorporate ? 'customer name'.tr : 'full name'.tr,
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
            controller: nameCtrl,
            onChanged: (v) {
              setState(() {
                Vehicle.selectedName = v;
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
