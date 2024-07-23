import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dataLayer/constants/variables.dart';

class RequestDetailsContainerWidget extends StatelessWidget {
  const RequestDetailsContainerWidget({
    Key? key,
    required this.child,
    required this.height,
  }) : super(key: key);

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        width: Get.width,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0x33303030),
                offset: Offset(0, 5),
                blurRadius: 15,
                spreadRadius: 0)
          ],
          color: appWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: child,
        ),
      ),
    );
  }
}
