import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../audio/audioFileCard.dart';

class description extends StatelessWidget {
  final FNOL fnol;

  const description({super.key, required this.fnol});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              "Description".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
              // textAlign: TextAlign.right,
            ),
            Spacer(),
            fnol.mediaController.audioFilePath != null
                ? audioFileCard(fnol: fnol)
                : Container(),
          ],
        ),
        fnol.comment.isNotEmpty
            ? Text(
                fnol.comment,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                // textAlign: TextAlign.right,
                maxLines: 3,
              )
            : Container(),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
