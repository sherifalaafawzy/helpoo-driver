import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../round_button.dart';

class retakeImageButton extends StatelessWidget {
  final Function clearImagePath;
  const retakeImageButton({
    Key? key,
    required this.clearImagePath,
    required this.imagePath,
  }) : super(key: key);
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundButton(
            padding: false,
            color: Get.theme.primaryColor,
            text: (imagePath == null || imagePath!.isEmpty)
                ? "Take".tr
                : "Retake".tr,
            onPressed: clearImagePath),
      ),
    );
  }
}
