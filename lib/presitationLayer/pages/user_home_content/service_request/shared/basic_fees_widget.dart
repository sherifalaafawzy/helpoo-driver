import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../dataLayer/constants/variables.dart';
import '../../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';

class BasicFeesWidget extends StatelessWidget {
  const BasicFeesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return Center(
      child: Container(
        width: 300,
        height: 29,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(11)),
            border: Border.all(color: const Color(0xff707070), width: 1),
            color: const Color(0xff909090).withOpacity(0.2865059971809387)),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Text(
              'basic cost'.tr +
                  " ${cubit.request.originalFees} " +
                  " " +
                  "EGP".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                ),
              ),
            ),
            const Spacer(),
            Container(
                width: 126,
                height: 29,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                    color: Color(0xff095e25)),
                child: Center(
                  child: Text(
                    cubit.request.paymentMethod.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appWhite,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
