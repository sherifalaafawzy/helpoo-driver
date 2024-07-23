import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class CountersWidget extends StatelessWidget {
  const CountersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'arrival time'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  cubit.request.driverDirectionDetails!=null?
                  '${(cubit.request.driverDirectionDetails!.durationValue / 60).ceil()}':"Checking...",
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: Color(0xff7f7f7f),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "mins".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: Color(0xff7f7f7f),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'distance'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  cubit.request.driverDirectionDetails != null
                      ? '${(cubit.request.driverDirectionDetails!.distanceValue / 1000).toStringAsFixed(1)}'
                      : "checking...".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: Color(0xff7f7f7f),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "km".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: Color(0xff7f7f7f),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'total cost'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              cubit.request.fees.toString(),
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: Color(0xff7f7f7f),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
            ),
          ]),
    ]);
  }
}
