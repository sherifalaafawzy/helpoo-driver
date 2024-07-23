// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dataLayer/constants/variables.dart';
import '../plateNumberInput.dart';
import '../round_button.dart';

class PlateDialog extends StatelessWidget {
  Function onPressed;
  PlateDialog({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        // width: 500,
        height: Get.height * 0.30,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 320.0, child: plateNumberInput(packageCar: false,enable: false,)),
              SizedBox(
                  child: RoundButton(
                      onPressed: () async {
                        await onPressed;
                      },
                      padding: true,
                      text: 'text'.tr,
                      color: mainColor)),
            ],
          ),
        ),
      ),
    );
  }
}
