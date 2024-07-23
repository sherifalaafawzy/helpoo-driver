import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/extensions/days_extensions.dart';

Future showPrimaryPopUp({
  required List<Widget> body,
  required double popUpWidth,
  double? height,
  String? title,
  String? label,
  required isDismissible,
  required BuildContext context,
  bool isScrollable = true,
  Color? popUpShadow,
}) =>
    showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.transparent,
      builder: (_) {
        return Directionality(
          textDirection:
              CurrentUser.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: GestureDetector(
            onTap: () => Navigator.pop(navigatorKey.currentContext!),
            child: Material(
              color: Colors.black.withOpacity(0.4),
              //* this container is all screen except the dialoge ************
              child: Container(
                width: popUpWidth,
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.80,
                  maxWidth: Get.width * 0.90,
                ),
                color: popUpShadow ?? Colors.transparent,
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      //* To Prevent above GestureDetector Tap Action (POP)
                      InkWell(
                        onTap: () {},
                        mouseCursor: SystemMouseCursors.basic,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: popUpWidth,
                          height: Get.height * 0.80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 8.br,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          //* Items Of Dialog **********************************
                          child: body[0],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
