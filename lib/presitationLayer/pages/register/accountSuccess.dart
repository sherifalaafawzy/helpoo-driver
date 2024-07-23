import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';

import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../widgets/round_button.dart';
import '../homeScreen.dart';
import 'registerVehicle.dart';

class accountSuccess extends StatelessWidget {
  const accountSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
                CurrentUser.isArabic
                    ? MdiIcons.arrowRightThin
                    : MdiIcons.arrowLeftThin,
                // Icons.arrow_back,
                color: appWhite),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "account success".tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appWhite,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(
                  height: 210,
                  width: 210,
                  child: Image.asset('assets/imgs/accunt__success.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 38.0),
                child: Text("account success".tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 22.0),
                    ),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: 120,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      border:
                          Border.all(color: const Color(0xff707070), width: 1),
                      color: const Color(0xfff0f0f0)),
                  child: Text(
                      "Dear Client, Do You want to Register your vehicles Now to Save Time When you Need Urgent Service?"
                          .tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 19),
                      ),
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: Get.width,
                child: RoundButton(
                  onPressed: () {
                    var cubit = BlocProvider.of<AppBloc>(context);
                    cubit.getAllManufacture();
                    Get.to(() => registerVehicle(
                          withBack: true,
                        ));
                  },
                  padding: true,
                  text: 'Yes Now'.tr,
                  color: mainColor,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: Get.width,
                child: RoundButton(
                  onPressed: () {
                    Get.offAll(() => const homeScreen(
                          index: 0,
                        ));
                  },
                  padding: true,
                  text: 'Later'.tr,
                  color: mainColor,
                ),
              ),
            ]),
      ),
    );
  }
}
