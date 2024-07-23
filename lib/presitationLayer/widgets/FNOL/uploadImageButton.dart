import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/models/FNOL.dart';
import '../round_button.dart';

class uploadImageButton extends StatelessWidget {
  final FNOL accidentReport;

  final String requiredImage;

  final int idx;

  const uploadImageButton(
      {Key? key,
      required this.imagePath,
      required this.idx,
      required this.accidentReport,
      required this.requiredImage})
      : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    if (imagePath == null || imagePath!.isEmpty) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundButton(
            padding: false,
            color: Get.theme.primaryColor,
            text: "next".tr,
            onPressed: () {
              bloc.uploadImageFNOL(
                requiredImage,
                bloc.fnol.base64String,
                bloc.fnol.id,
                false,
              );
              bloc.fnol.allImagesCounter++;
              // bloc.emit(imageTake());
              bloc.fnol.nextImagePage(bloc: bloc, idx: idx);
            }),
      ),
    );
  }
}
