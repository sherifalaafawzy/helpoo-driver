import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class premiumTowingCard extends StatefulWidget {
  premiumTowingCard({
    Key? key,
    this.voucherCode,
  }) : super(key: key);
  final bool? voucherCode;
  @override
  State<premiumTowingCard> createState() => _PremiumTowingCardState();
}

class _PremiumTowingCardState extends State<premiumTowingCard> {
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Image.asset(
            "assets/imgs/premiumTowing.png",
            height: 100,
          ),
          Expanded(
            child: Center(
              child: Text(
                "premium towing".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          widget.voucherCode! || cubit.request.euroPercent != "0"
              ? Column(
                  children: [
                    Text(
                      "Before Discount".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Chip(
                      label:
                          Text(cubit.request.euroOriginalFees + " " + "EGP".tr),
                      backgroundColor: Colors.grey,
                    ),
                    Text(
                      "After Discount".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        cubit.request.euroFees + " " + "EGP".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      backgroundColor: mainColor,
                    ),
                  ],
                )
              : Chip(
                  label: Text(cubit.request.euroOriginalFees + " " + "EGP".tr),
                  backgroundColor: Colors.grey,
                ),
          Radio(
              value: 1,
              groupValue: cubit.request.selectedTowingService,
              onChanged: (v) {
                cubit.request.selectedTowingService = 1;
                cubit.changeStateTo(changeRadioPremium());
                // cubit.emit(changeRadioPremium());
              }),
        ],
      ),
    );
  }
}
