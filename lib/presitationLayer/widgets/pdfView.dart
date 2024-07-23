import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import '../pages/homeScreen.dart';

class PdfView extends StatefulWidget {
  final String pdf;
  final bool isFile;

  const PdfView({
    Key? key,
    required this.pdf,
    required this.isFile,
  }) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  void initState() {
    super.initState();
    debugPrint(widget.pdf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: appWhite),
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text(
          "Accident Report".tr,
          style: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: appWhite,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
            ),
          ),
        ),
        leading: Container(
          height: 48,
          width: 48,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                CurrentUser.isArabic
                    ? MdiIcons.arrowRightThin
                    : MdiIcons.arrowLeftThin,
                color: appWhite,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.off(() => homeScreen(index: 0));
                },
                child: Icon(
                  MdiIcons.homeOutline,
                  color: appWhite,
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: mainColor,
                    padding: EdgeInsets.all(8),
                    elevation: 0),
              ),
            ),
          ),
        ],
      ),
      body: widget.isFile
          ? SfPdfViewer.file(
              File(widget.pdf),
            )
          : SfPdfViewer.network(
              widget.pdf,
            ),
    );
  }
}
