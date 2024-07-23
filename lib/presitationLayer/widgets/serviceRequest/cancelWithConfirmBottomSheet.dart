import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../dataLayer/Constants/variables.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/models/FCM.dart';
import '../../pages/homeScreen.dart';
import '../round_button.dart';

class cancelWithConfirmBottomSheet extends StatefulWidget {
  const cancelWithConfirmBottomSheet({super.key});

  @override
  State<cancelWithConfirmBottomSheet> createState() =>
      _cancelWithConfirmBottomSheetState();
}

class _cancelWithConfirmBottomSheetState
    extends State<cancelWithConfirmBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return Material(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        child: Container(
          color: appOffWhite,
          height: Get.height * .45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Icon(MdiIcons.closeCircle, size: 42, color: appBlack),
                ),
              ),
              Center(
                child: Text(
                  "sure you want to cancel".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 9),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "cancel confirmation text".tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: Color(0xff848484),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 11.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 46),
              Row(
                children: [
                  SizedBox(width: 20),
                  RoundButton(
                    onPressed: () async {
                      bool success = await cubit.cancelRequest(cubit.request);
                      if (success) {
                        if (!cubit.request.open) {
                          FCM.sendMessage(
                              cubit.request.driver.fcmToken!,
                              "helpoo",
                              "لقد تم الغاء االطلب",
                              // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                              cubit.request.id!.toString(),
                              'service-request');
                        }
                        // await cubit.getLocation();
                        cubit.googleMapsModel.clearMapModel();
                        cubit.request.clearRequest();
                        Get.to(() => homeScreen(index: 0));
                      } else {
                        // Get.snackbar("Error", "Please try again");
                      }
                    },
                    padding: false,
                    text: "cancel request".tr,
                    color: appBlack,
                  ),
                  Spacer(),
                  RoundButton(
                    onPressed: () {
                      Get.back();
                    },
                    padding: false,
                    text: "resume".tr,
                    color: mainColor,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
