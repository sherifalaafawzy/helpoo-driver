// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dataLayer/models/FNOL.dart';
import '../round_button.dart';

class nextImageButton extends StatelessWidget {
  nextImageButton(
      {Key? key,
      required this.img,
      required this.report,
      required this.idx,
      required this.bloc})
      : super(key: key);

  final String? img;
  final FNOL report;
  final int idx;
  var bloc;

  @override
  Widget build(BuildContext context) {
    if (img == null) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
    return RoundButton(
        padding: true,
        color: Get.theme.primaryColor,
        text: 'next'.tr,
        onPressed: () {
          bloc.fnol.nextImagePage(bloc: bloc, idx: idx);
        });
  }
}
