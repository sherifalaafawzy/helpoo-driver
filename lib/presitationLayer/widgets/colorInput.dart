import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/vehicle.dart';

class colorInput extends StatefulWidget {
  final String? value;
  final bool? enable;
  final Function(String) callbackfun;

  const colorInput({
    Key? key,
    this.value,
    required this.callbackfun,
    required this.enable,
  }) : super(key: key);

  @override
  State<colorInput> createState() => colorInputState();
}

class colorInputState extends State<colorInput> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              text: 'color'.tr,
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
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: mainColor,
                width: 1,
              ),
            ),
            child: Center(
              child: DropdownButtonFormField<String>(
                // underline: const SizedBox(),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  border: InputBorder.none,
                ),
                validator: (v) {
                  if (v == null) {
                    return 'please select color'.tr;
                  }
                  return null;
                },
                isExpanded: true,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                value: widget.value,
                items: Vehicle.colors,
                onChanged:
                    widget.enable! ? (v) => widget.callbackfun(v!) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
