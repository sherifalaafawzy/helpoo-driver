import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../widgets/willPopScopeWidget.dart';
import 'extraShooting.dart';
import '../../../../dataLayer/Constants/variables.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../widgets/round_button.dart';

class policeReport extends StatefulWidget {
  final FNOL report;

  const policeReport(this.report, {Key? key}) : super(key: key);

  @override
  State<policeReport> createState() => _policeReportPageState();
}

class _policeReportPageState extends State<policeReport> {
  @override
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
            "attach police report page".tr,
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
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset('assets/imgs/report.png',
                height: 190, width: Get.width),
          ),
          Text(
            "police report shooting comment".tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appBlack,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          ListTile(
            leading: Icon(
              MdiIcons.checkboxBlank,
              color: mainColor,
            ),
            title: Text(
              "please shoot clearly".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          ListTile(
            leading: Icon(
              MdiIcons.checkboxBlank,
              color: mainColor,
            ),
            title: Text(
              "shoot page by page".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          ListTile(
            leading: Icon(
              MdiIcons.checkboxBlank,
              color: mainColor,
            ),
            title: Text(
              "shoot in good light".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: RoundButton(
                      onPressed: () {
                        printMeLog("police report page");
                        Get.to(() => extraShooting(widget.report, "police"));
                      },
                      padding: false,
                      text: 'Take Photos'.tr,
                      color: mainColor),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: RoundButton(
                        onPressed: () async {
                          bloc.fnol
                              .pickupMultiImagesForReports(bloc, "police", "");
                        },
                        padding: false,
                        text: 'gallery'.tr,
                        color: mainColor)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
