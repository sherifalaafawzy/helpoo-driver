import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/vehicle.dart';

class yearInput extends StatefulWidget {
  final int? value;
  final bool? enable;
  final Function(int) callbackfun;
  yearInput(
      {Key? key, required this.value, required this.callbackfun,required this.enable})
      : super(key: key);

  @override
  State<yearInput> createState() => _yearInputState();
}

class _yearInputState extends State<yearInput> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              text: 'year of manufacture'.tr,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
              children: <TextSpan>[
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
          SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: mainColor,
                width: 1,
              ),
            ),
            child: Center(
              child: DropdownButtonFormField<int>(
                // underline: SizedBox(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 6, vertical: 0),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null) {
                    return 'please select year'.tr;
                  }
                  return null;
                },
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                value: widget.value,
                isExpanded: true,
                items: Vehicle.years,
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
