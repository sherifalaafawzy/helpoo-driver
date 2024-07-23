// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class normalTowingCard extends StatefulWidget {
  normalTowingCard({
    Key? key,
    this.voucherCode,
  }) : super(key: key);
  final bool? voucherCode;
  var cubit;

  @override
  State<normalTowingCard> createState() => _NormalTowingCardState();
}

class _NormalTowingCardState extends State<normalTowingCard> {
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/imgs/basicTowing.png",
            height: 100,
          ),
          Expanded(
            child: Center(
              child: Text(
                "basic towing".tr,
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
          widget.voucherCode! || cubit.request.normPercent != "0"
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
                          Text(cubit.request.normOriginalFees + " " + "EGP".tr),
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
                        cubit.request.normFees + " " + "EGP".tr,
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
                  label: Text(cubit.request.normOriginalFees + " " + "EGP".tr),
                  backgroundColor: Colors.grey,
                ),
          Radio(
              value: 2,
              groupValue: cubit.request.selectedTowingService,
              onChanged: (v) {
                cubit.request.selectedTowingService = 2;
                cubit.changeStateTo(changeRadioNormal());
                // cubit.emit(changeRadioNormal());
              }),
        ],
      ),
    );
  }
}
