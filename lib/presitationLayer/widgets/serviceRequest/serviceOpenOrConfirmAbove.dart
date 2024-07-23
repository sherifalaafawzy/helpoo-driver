import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class serviceOpenOrConfirmAbove extends StatelessWidget {
  const serviceOpenOrConfirmAbove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return Positioned.fill(
      bottom: (cubit.request.confirmed) ? Get.height * .39 : Get.height * .36,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 62,
                  height: 54,
                  decoration: BoxDecoration(
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
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appWhite,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        Text(
                          "mins".tr,
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
                const SizedBox(width: 16),
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
                          cubit.request.fees.toString(),
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appWhite,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        Text(
                          "egp".tr,
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
              ],
            ),
            (cubit.request.confirmed)
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Container(
                          width: 248,
                          height: 27,
                          decoration: const BoxDecoration(
                            color: Color(0xffcb8c00),
                          ),
                          child: Center(
                            child: Text(
                              'please wait for driver to accept your request'
                                  .tr,
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
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
