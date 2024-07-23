import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../homeScreen.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../widgets/round_button.dart';

class shootingNotes extends StatefulWidget {
  const shootingNotes({Key? key}) : super(key: key);

  @override
  State<shootingNotes> createState() => shootingNotesState();
}

class shootingNotesState extends State<shootingNotes> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    return willPopScopeWidget(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Get.offAll(() => homeScreen(
              index: 0,
            ));
        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "instructions".tr,
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
                  Get.offAll(() => homeScreen(
                        index: 0,
                      ));
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
        body: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(2),
                height: Get.height * .4,
                child: Image.asset(
                  "assets/imgs/car-top.png",
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "instructions".tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.checkboxBlank,
                  color: mainColor,
                ),
                title: Text(
                  "vehicle shooting light".tr,
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
                  "vehicle shooting distance".tr,
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
                  "vehicle shooting landscape".tr,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RoundButton(
                  padding: false,
                  color: Get.theme.primaryColor,
                  text: 'next'.tr,
                  onPressed: () {
                    bloc.fnol.nextImagePage(idx: -1, bloc: bloc);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
