import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../dataLayer/models/currentUser.dart';

import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class serviceAcceptedArrivedStartedAbove extends StatelessWidget {
  const serviceAcceptedArrivedStartedAbove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return Positioned.fill(
      bottom: Get.height * .33,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 62,
              height: 54,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: appBlack,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cubit.request.driverDirectionDetails != null
                          ? '${(cubit.request.driverDirectionDetails!.durationValue / 60).ceil()}'
                          : "Checking...".tr,
                      // '${cubit.request.driverDirectionDetails!.durationText}',
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appWhite,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ]),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CurrentUser.isArabic ? 12 : 0),
                topRight: Radius.circular(CurrentUser.isArabic ? 0 : 12),
              ),
              child: Container(
                width: 186,
                height: 27,
                decoration: const BoxDecoration(
                  color: mainColor,
                ),
                child: Center(
                  child: Text(
                    cubit.request.accepted
                        ? 'accepted'.tr
                        : cubit.request.arrived
                            ? 'arrived'.tr
                            : 'started'.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appWhite,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
