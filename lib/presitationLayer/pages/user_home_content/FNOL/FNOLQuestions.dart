// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../widgets/FNOL/summary/repairReport.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/willPopScopeWidget.dart';
import 'policeReport.dart';

class fnolQuestions extends StatefulWidget {
  final FNOL report;
  String? type;

  fnolQuestions(this.report, this.type, {Key? key}) : super(key: key);

  @override
  State<fnolQuestions> createState() => fnolQuestionsState();
}

class fnolQuestionsState extends State<fnolQuestions> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    return willPopScopeWidget(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "FNOL Follow Up".tr + " # " + widget.report.id.toString(),
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(children: [
            Container(
              height: Get.height * .05,
              width: Get.width * .8,
              child: Center(
                child: Text(
                  "Next Step".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: mainColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/imgs/report.png',
                  height: 190, width: Get.width),
            ),
            SizedBox(
              width: Get.width * .8,
              child: Text(
                widget.type == "police"
                    ? "Did you made Police Report?".tr
                    : widget.type == "bRepair" ||
                            widget.type == "supplement" ||
                            widget.type == "resurvey"
                        ? "Did the Vehicle Deliverd to the Work Shop and the Quotation is Ready for the Inspection?"
                            .tr
                        : widget.type == "aRepair"
                            ? "Please Choose Next Step".tr
                            : "",
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: Get.width * .4,
                      child: RoundButton(
                          onPressed: () async {
                            if (widget.type == "police") {
                              Get.to(() => policeReport(bloc.fnol));
                            } else if (widget.type == "bRepair") {
                              Get.to(() => repairReport(
                                    widget.report,
                                    type: 'beforeRepair',
                                  ));
                            } else if (widget.type == "supplement") {
                              Get.to(() => repairReport(
                                    widget.report,
                                    type: 'supplement',
                                  ));
                            } else if (widget.type == "resurvey") {
                              Get.to(() => repairReport(
                                    widget.report,
                                    type: 'resurvey',
                                  ));
                            }
                          },
                          padding: false,
                          text: 'yes'.tr,
                          color: mainColor)),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: Get.width * .4,
                    child: RoundButton(
                        onPressed: () async {
                          if (widget.type == "police") {
                            setState(() {
                              widget.type = "bRepair";
                            });
                            await bloc.updateStatus(
                                "policeReport", bloc.fnol.id);
                          } else if (widget.type == "bRepair" ||
                              widget.type == "supplement") {
                            Get.back();
                          }
                        },
                        padding: false,
                        text: widget.type == "bRepair" ||
                                widget.type == "supplement"
                            ? "no".tr
                            : 'Skip'.tr,
                        color: appBlack),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
