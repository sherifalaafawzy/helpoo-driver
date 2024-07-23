import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/extensions/days_extensions.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../../dataLayer/models/imagesModel.dart';
import '../../../widgets/FNOL/summary/description.dart';
import '../../../widgets/FNOL/summary/imagesSlider.dart';
import '../../../widgets/FNOL/summary/location.dart';
import '../../../widgets/FNOL/summary/showPdf.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../homeScreen.dart';
import 'package:intl/intl.dart';
import 'FNOLQuestions.dart';
import 'policeReport.dart';

class fnolSummary extends StatefulWidget {
  final FNOL fnol;

  const fnolSummary({super.key, required this.fnol});

  @override
  State<fnolSummary> createState() => _fnolSummaryState();
}

class _fnolSummaryState extends State<fnolSummary> {
  StepperType stepperType = StepperType.vertical;
  List<ImagesModel> mainImages = [];
  List<ImagesModel> additionalImages = [];
  List<ImagesModel> policeImages = [];
  List<ImagesModel> beforeImages = [];
  List<ImagesModel> supplementImages = [];
  List<ImagesModel> reinspectionImages = [];
  TextStyle style = GoogleFonts.tajawal(
    textStyle: TextStyle(
      color: appBlack,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
    ),
  );

  @override
  void initState() {
    // printWarning('${widget.fnol.to}');
    debugPrint('---------- widget.fnol.statusList.length ---------');
    debugPrint(widget.fnol.statusList.length.toString());

    setState(() {
      for (var i = 0; i < widget.fnol.allImages.length; i++) {
        if (widget.fnol.allImages[i].additional == false) {
          mainImages.add(widget.fnol.allImages[i]);
        }
        if (widget.fnol.allImages[i].additional == true &&
            (!widget.fnol.allImages[i].imageName!.contains("police") &&
                !widget.fnol.allImages[i].imageName!
                    .contains("repair_before") &&
                !widget.fnol.allImages[i].imageName!.contains("supplement") &&
                !widget.fnol.allImages[i].imageName!.contains("resurvey"))) {
          additionalImages.add(widget.fnol.allImages[i]);
        }
        if (widget.fnol.allImages[i].additional == true &&
            widget.fnol.allImages[i].imageName!.contains("police")) {
          policeImages.add(widget.fnol.allImages[i]);
        }
        if (widget.fnol.allImages[i].additional == true &&
            widget.fnol.allImages[i].imageName!.contains("repair_before")) {
          beforeImages.add(widget.fnol.allImages[i]);
        }
        if (widget.fnol.allImages[i].additional == true &&
            widget.fnol.allImages[i].imageName!.contains("supplement")) {
          supplementImages.add(widget.fnol.allImages[i]);
        }
        if (widget.fnol.allImages[i].additional == true &&
            widget.fnol.allImages[i].imageName!.contains("resurvey")) {
          reinspectionImages.add(widget.fnol.allImages[i]);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printWarning('======>>> ${widget.fnol.billDeliveryNotesList}');
    printWarning(
        '======>>> billDeliveryNotes ${widget.fnol.billDeliveryNotes}');
    return willPopScopeWidget(
      onWillPop: () async {
        Get.off(() => homeScreen(index: 0));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "accident report ".tr + " # " + widget.fnol.id.toString(),
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
                  Get.off(() => homeScreen(index: 0));
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
        body: mainImages.isNotEmpty
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: Get.width * .09,
                                  height: Get.height * .03,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    shape: BoxShape.circle,
                                    color: mainColor,
                                  ),
                                  child: Text(
                                    (widget.fnol.statusList.indexWhere(
                                                (element) => element
                                                    .startsWith("created")) +
                                            1)
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                width: Get.width * .01,
                                height: additionalImages.isNotEmpty
                                    ? Get.height * .8
                                    : Get.height * .3,
                                color: appGrey,
                              )
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (mainImages.isNotEmpty)
                                  Text(
                                    "FNOL Uploaded".tr +
                                        " : (${mainImages.first.date?.shortDateMonthYearFormat ?? ''})",
                                    style: GoogleFonts.tajawal(
                                      textStyle: const TextStyle(
                                        color: appBlack,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                if (mainImages.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, top: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "accident Photos".tr,
                                          style: style,
                                          textAlign: TextAlign.right,
                                        ),
                                        imagesSlider(
                                          fnol: widget.fnol,
                                          images: mainImages,
                                        ),
                                        additionalImages.isNotEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Additional Photos".tr +
                                                        " : (${additionalImages.first.date?.shortDateMonthYearFormat ?? ''})",
                                                    style: style,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  imagesSlider(
                                                    fnol: widget.fnol,
                                                    images: additionalImages,
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        description(fnol: widget.fnol),
                                        location(fnol: widget.fnol),
                                        showPdf(fnol: widget.fnol),
                                        Container(
                                          width: Get.width * .8,
                                          height: Get.height * .05,
                                          child: Divider(
                                            thickness: 2,
                                            color: appBlack,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible:
                            widget.fnol.statusList.contains("policeReport"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) =>
                                                      element.startsWith(
                                                          "policeReport")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .2,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "police Report Uploaded".tr +
                                      '${policeImages.isEmpty ? '' : " : (${policeImages.first.date?.shortDateMonthYearFormat ?? ''})"}',
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    policeImages.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "If you have Police Report Please Add it",
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: appBlack,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * .4,
                                                height: Get.height * .055,
                                                child: RoundButton(
                                                    onPressed: () {
                                                      Get.to(() => policeReport(
                                                          widget.fnol));
                                                    },
                                                    padding: false,
                                                    text:
                                                        'Add Policy Report'.tr,
                                                    color: mainColor),
                                              ),
                                            ],
                                          )
                                        : imagesSlider(
                                            fnol: widget.fnol,
                                            images: policeImages,
                                          ),
                                    Container(
                                      width: Get.width * .8,
                                      child: Divider(
                                        thickness: 2,
                                        color: appBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.fnol.statusList.contains("bRepair"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) => element
                                                      .startsWith("bRepair")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .3,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Before Repair Report Uploaded".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${beforeImages.isEmpty ? '' : "(${beforeImages.first.date?.shortDateMonthYearFormat ?? ''})"}',
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Repair Location".tr,
                                      style: style,
                                    ),
                                    widget.fnol.beforeRepairLocation.isNotEmpty
                                        ? Text(
                                            widget
                                                .fnol.beforeRepairLocation.last,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    GestureDetector(
                                      onTap: () async {
                                        await MapsLauncher.launchCoordinates(
                                            double.parse(widget
                                                .fnol
                                                .beforeRepairAddressLatLng!
                                                .latitude
                                                .toString()),
                                            double.parse(widget
                                                .fnol
                                                .beforeRepairAddressLatLng!
                                                .longitude
                                                .toString()));
                                      },
                                      child: Container(
                                        width: Get.width * .8,
                                        child: Text(
                                          widget.fnol.beforeRepairAddress ?? "",
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.blue,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                    beforeImages.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Have before Repair Report? Please Add it"
                                                    .tr,
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: appBlack,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * .4,
                                                height: Get.height * .055,
                                                child: RoundButton(
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          fnolQuestions(
                                                              widget.fnol,
                                                              "bRepair"));
                                                    },
                                                    padding: false,
                                                    text: 'Add Report'.tr,
                                                    color: mainColor),
                                              ),
                                            ],
                                          )
                                        : imagesSlider(
                                            fnol: widget.fnol,
                                            images: beforeImages,
                                          ),
                                    Container(
                                      width: Get.width * .8,
                                      child: Divider(
                                        thickness: 2,
                                        color: appBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.fnol.statusList.contains("supplement"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) =>
                                                      element.startsWith(
                                                          "supplement")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .2,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Supplement Report Uploaded".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${supplementImages.isEmpty ? '' : "(${supplementImages.first.date?.shortDateMonthYearFormat ?? ''})"}',
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Repair Location".tr,
                                      style: style,
                                    ),
                                    Text(
                                      widget.fnol.supplementLocation ?? "",
                                      style: GoogleFonts.tajawal(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await MapsLauncher.launchCoordinates(
                                            double.parse(widget
                                                .fnol
                                                .supplementAddressLatLng!
                                                .latitude
                                                .toString()),
                                            double.parse(widget
                                                .fnol
                                                .supplementAddressLatLng!
                                                .longitude
                                                .toString()));
                                      },
                                      child: Container(
                                        width: Get.width * .8,
                                        child: Text(
                                          widget.fnol.supplementAddress ?? "",
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.blue,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                    supplementImages.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Have supplement Report? Please Add it"
                                                    .tr,
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: appBlack,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * .4,
                                                height: Get.height * .055,
                                                child: RoundButton(
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          fnolQuestions(
                                                              widget.fnol,
                                                              "supplement"));
                                                    },
                                                    padding: false,
                                                    text: 'Add Report'.tr,
                                                    color: mainColor),
                                              ),
                                            ],
                                          )
                                        : imagesSlider(
                                            fnol: widget.fnol,
                                            images: supplementImages,
                                          ),
                                    Container(
                                      width: Get.width * .8,
                                      child: Divider(
                                        thickness: 2,
                                        color: appBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.fnol.statusList.contains("resurvey"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) => element
                                                      .startsWith("resurvey")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .2,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reinspection Report Uploaded".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${reinspectionImages.isEmpty ? '' : "(${reinspectionImages.first.date?.shortDateMonthYearFormat ?? ''})"}',
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Repair Location".tr,
                                      style: style,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await MapsLauncher.launchCoordinates(
                                            double.parse(widget.fnol
                                                .resurveyAddressLatLng!.latitude
                                                .toString()),
                                            double.parse(widget
                                                .fnol
                                                .resurveyAddressLatLng!
                                                .longitude
                                                .toString()));
                                      },
                                      child: Container(
                                        width: Get.width * .8,
                                        child: Text(
                                          widget.fnol.resurveyAddress ?? "",
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.blue,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.fnol.resurveyLocation ?? "",
                                      style: GoogleFonts.tajawal(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    reinspectionImages.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Have reinspection Report? Please Add it"
                                                    .tr,
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: appBlack,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * .4,
                                                height: Get.height * .055,
                                                child: RoundButton(
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          fnolQuestions(
                                                              widget.fnol,
                                                              "resurvey"));
                                                    },
                                                    padding: false,
                                                    text: 'Add Report'.tr,
                                                    color: mainColor),
                                              ),
                                            ],
                                          )
                                        : imagesSlider(
                                            fnol: widget.fnol,
                                            images: reinspectionImages,
                                          ),
                                    Container(
                                      width: Get.width * .8,
                                      child: Divider(
                                        thickness: 2,
                                        color: appBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.fnol.statusList.contains("aRepair"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) => element
                                                      .startsWith("aRepair")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .2,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "After Repair Report Updated".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Inspection Location".tr,
                                      style: style,
                                    ),
                                    Text(
                                      widget.fnol.aRepairLocation ?? "",
                                      style: GoogleFonts.tajawal(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await MapsLauncher.launchCoordinates(
                                            double.parse(widget.fnol
                                                .aRepairAddressLatLng!.latitude
                                                .toString()),
                                            double.parse(widget.fnol
                                                .aRepairAddressLatLng!.longitude
                                                .toString()));
                                      },
                                      child: Container(
                                        width: Get.width * .8,
                                        child: Text(
                                          widget.fnol.aRepairAddress ?? "",
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              decorationColor: Colors.blue,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * .8,
                                      child: Divider(
                                        thickness: 2,
                                        color: appBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.fnol.statusList.contains("rightSave"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) =>
                                                      element.startsWith(
                                                          "rightSave")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .2,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Right Save Report Updated".tr,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Right save inspection location".tr,
                                      style: style,
                                    ),
                                    Text(
                                      widget.fnol.rightSaveLocation ?? "",
                                      style: GoogleFonts.tajawal(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await MapsLauncher.launchCoordinates(
                                            double.parse(widget
                                                .fnol
                                                .rightSaveAddressLatLng!
                                                .latitude
                                                .toString()),
                                            double.parse(widget
                                                .fnol
                                                .rightSaveAddressLatLng!
                                                .longitude
                                                .toString()));
                                      },
                                      child: Container(
                                        width: Get.width * .8,
                                        child: Text(
                                          widget.fnol.rightSaveAddress ?? "",
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.blue,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * .8,
                                      child: Divider(
                                        thickness: 2,
                                        color: appBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.fnol.statusList.contains("billing"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: Get.width * .09,
                                    height: Get.height * .03,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                    child: Text(
                                      (widget.fnol.statusList.indexWhere(
                                                  (element) => element
                                                      .startsWith("billing")) +
                                              1)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: Get.width * .01,
                                  height: Get.height * .2,
                                  color: appGrey,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Billing Request Delivery Received".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: appBlack,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width * .8,
                                  decoration: BoxDecoration(
                                      color: appGrey,
                                      border: Border.all(
                                        color: appBlack,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Final Data".tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w800,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                        widget.fnol.billDeliveryDate != null
                                            ? Text(
                                                "Bill Will Deliver At".tr +
                                                    "  " +
                                                    ' ${DateFormat("dd/MM/yyyy").format(widget.fnol.billDeliveryDate!)}',
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        widget.fnol.billDeliveryTimeRangeList
                                                .isNotEmpty
                                            ? Text(
                                                "At time Range".tr +
                                                    "  " +
                                                    widget
                                                        .fnol
                                                        .billDeliveryTimeRangeList[
                                                            0]
                                                        .toString(),
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          "Bill Delivery Location".tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w800,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 8.0, left: 8, top: 2),
                                          child: InkWell(
                                            onTap: () async {
                                              await MapsLauncher
                                                  .launchCoordinates(
                                                      double.parse(widget
                                                          .fnol
                                                          .billingAddressLatLng!
                                                          .latitude
                                                          .toString()),
                                                      double.parse(widget
                                                          .fnol
                                                          .billingAddressLatLng!
                                                          .longitude
                                                          .toString()));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.mapMarker,
                                                  color: mainColor,
                                                ),
                                                Spacer(),
                                                Container(
                                                  width: Get.width * .6,
                                                  child: Text(
                                                    widget.fnol.billingAddress,
                                                    style: GoogleFonts.tajawal(
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            Colors.blue,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (widget.fnol.billDeliveryNotesList
                                            .isNotEmpty)
                                          Text(
                                            '${widget.fnol.billDeliveryNotesList.last}',
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  child: Center(
                    child: Text(
                      "No Summary Data".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
