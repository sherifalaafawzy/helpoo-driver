import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../widgets/FNOL/summary/repairReport.dart';
import '../../../widgets/round_button.dart';

import '../../../../dataLayer/models/currentUser.dart';
import '../../../widgets/FNOL/requestBill.dart';
import '../../../widgets/willPopScopeWidget.dart';
import 'FNOLQuestions.dart';
import 'aRepairQuestions.dart';
import 'policeReport.dart';
import 'package:intl/intl.dart' as intl;

class fNOLSteps extends StatefulWidget {
  final FNOL fnol;

  fNOLSteps({Key? key, required this.fnol}) : super(key: key);

  @override
  State<fNOLSteps> createState() => fNOLStepsState();
}

class fNOLStepsState extends State<fNOLSteps> {
  @override
  Widget build(BuildContext context) {
    return willPopScopeWidget(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainColor,
          actionsIconTheme: const IconThemeData(
            color: mainColor,
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "FNOL Follow Up".tr + " # " + widget.fnol.id.toString(),
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appWhite,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 22.0,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          leading: Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.symmetric(horizontal: 8),
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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    "Please Choose Next Step".tr,
                    style: GoogleFonts.tajawal().copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: 30,
                  width: 250,
                  child: Center(
                    child: Text(
                      "police report".tr,
                      style: GoogleFonts.tajawal().copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  strokeWidth: 1,
                  radius: const Radius.circular(20),
                  borderType: BorderType.RRect,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info,
                            color: mainColor,
                          ),
                          Text(
                            'Add Policy Report'.tr,
                            style: GoogleFonts.tajawal().copyWith(
                              fontSize: 15,
                              color: mainColor,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * .04,
                            child: RoundButton(
                                onPressed: () {
                                  Get.to(() => policeReport(widget.fnol));
                                },
                                padding: false,
                                text: "Add".tr,
                                color: mainColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: 30,
                  width: 250,
                  child: Center(
                    child: Text(
                      "Before Repair Inspections".tr,
                      style: GoogleFonts.tajawal().copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  strokeWidth: 1,
                  radius: const Radius.circular(20),
                  borderType: BorderType.RRect,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                color: mainColor,
                              ),
                              Text(
                                'Before Repair Request'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontSize: 15,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * .04,
                                child: RoundButton(
                                    onPressed: () {
                                      Get.to(() => fnolQuestions(
                                          widget.fnol, "bRepair"));
                                    },
                                    padding: false,
                                    text: "Request".tr,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                color: mainColor,
                              ),
                              Text(
                                'Additional Inspection'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontSize: 15,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * .04,
                                child: RoundButton(
                                    onPressed: () {
                                      Get.to(() => fnolQuestions(
                                          widget.fnol, "supplement"));
                                    },
                                    padding: false,
                                    text: "Request".tr,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                color: mainColor,
                              ),
                              Text(
                                'New Inspection request'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontSize: 15,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * .04,
                                child: RoundButton(
                                    onPressed: () {
                                      Get.to(() => repairReport(
                                            widget.fnol,
                                            type: 'resurvey',
                                          ));
                                      // Get.to(() =>
                                      //     fnolQuestions(widget.fnol, "resurvey"));
                                    },
                                    padding: false,
                                    text: "Request".tr,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: 30,
                  width: 250,
                  child: Center(
                    child: Text(
                      "After Repair Inspections".tr,
                      style: GoogleFonts.tajawal().copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  strokeWidth: 1,
                  radius: const Radius.circular(20),
                  borderType: BorderType.RRect,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                color: mainColor,
                              ),
                              Text(
                                'After Repair Inspection'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontSize: 15,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * .04,
                                child: RoundButton(
                                    onPressed: () {
                                      Get.to(() => aRepairQuestions(
                                          widget.fnol, "aRepair"));
                                    },
                                    padding: false,
                                    text: "Request".tr,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                color: mainColor,
                              ),
                              Text(
                                'Right Save Inspection'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontSize: 15,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * .04,
                                child: RoundButton(
                                    onPressed: () {
                                      Get.to(() => aRepairQuestions(
                                          widget.fnol, "rightSave"));
                                    },
                                    padding: false,
                                    text: "Request".tr,
                                    color: mainColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: 30,
                  width: 250,
                  child: Center(
                    child: Text(
                      "Billing Delivery".tr,
                      style: GoogleFonts.tajawal().copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  strokeWidth: 1,
                  radius: const Radius.circular(20),
                  borderType: BorderType.RRect,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: widget.fnol.billDeliveryDate != null ? 80 : 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                color: mainColor,
                              ),
                              Text(
                                'Bill Delivery Request'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontSize: 15,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * .04,
                                child: RoundButton(
                                    onPressed: () {
                                      Get.to(() => requestBill());
                                    },
                                    padding: false,
                                    text: widget.fnol.billDeliveryDate != null
                                        ? 'Edit'.tr
                                        : "Add".tr,
                                    color: mainColor),
                              )
                            ],
                          ),
                          if (widget.fnol.billDeliveryDate != null) ...[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'current billing date'.tr,
                                  style: GoogleFonts.tajawal().copyWith(
                                    fontSize: 15,
                                    color: mainColor,
                                  ),
                                ),
                                Text(
                                  '${intl.DateFormat('yyyy/MM/dd').format(widget.fnol.billDeliveryDate!)}',
                                  style: GoogleFonts.tajawal().copyWith(
                                    fontSize: 15,
                                    color: mainColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
