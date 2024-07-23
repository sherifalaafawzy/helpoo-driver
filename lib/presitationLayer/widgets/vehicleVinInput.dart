import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/vehicle.dart';

class vehicleVinInput extends StatefulWidget {
  final Vehicle? vehicle;
  final bool packageCar;

  vehicleVinInput({Key? key, this.vehicle, required this.packageCar})
      : super(key: key);

  @override
  State<vehicleVinInput> createState() => _vehicleVinInputState();
}

class _vehicleVinInputState extends State<vehicleVinInput> {
  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      Vehicle.chassisCtrl.text = widget.vehicle!.chassisNo ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              text: 'Vehicle Chassis No.'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: widget.packageCar ? " *" : " (optional)".tr,
                  style: TextStyle(
                    color: widget.packageCar ? Colors.red : mainColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: mainColor,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Center(
                child: TextFormField(
                  
                  enabled:
                      widget.packageCar && widget.vehicle!.chassisNo!.isNotEmpty
                          ? false
                          : true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                  ],
                  controller: Vehicle.chassisCtrl,
                  decoration: InputDecoration(
                    hintText: "Insert VIN that return in the vehicle license".tr,
                    hintStyle: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    setState(() {
                      if (widget.vehicle != null) {
                        widget.vehicle!.chassisNo = v;
                      }
                      // else {
                      //   Vehicle.chassisCtrl.text = v;
                      // }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
