// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../requestBill.dart';

class billDeliveryRequest extends StatefulWidget {
  const billDeliveryRequest({super.key});

  @override
  State<billDeliveryRequest> createState() => _billDeliveryRequestState();
}

class _billDeliveryRequestState extends State<billDeliveryRequest> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return BlocListener<FnolBloc, FnolState>(
      listener: (context, state) {
        if (state is billAdded) {
          setState(() {});
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Text(
                  "bill delivery request".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Spacer(),
              bloc.fnol.billDeliveryDate != null &&
                      bloc.fnol.billingAddress != null
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        Get.to(() => requestBill());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          "request delivery agent".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 8),
          bloc.fnol.billingAddress != null
              ? SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'pickup date and time'.tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appBlack,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          intl.DateFormat('yyyy-MM-dd')
                                  .format(bloc.fnol.billDeliveryDate!) +
                              '  ' +
                              bloc.fnol.billDeliveryTimeRange[0],
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appBlack,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0,
                            ),
                          ),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'delivery location'.tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appBlack,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          bloc.fnol.billingAddress,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appBlack,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Visibility(
                        //   visible: widget.report.billDeliveryNotes.isNotEmpty,
                        //   maintainSize: false,
                        //   child: Padding(
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 28.0),
                        //     child: Text(
                        //       widget.report.billDeliveryNotes,
                        //       style: GoogleFonts.tajawal(
                        //         textStyle: const TextStyle(
                        //           color: appBlack,
                        //           fontWeight: FontWeight.w400,
                        //           fontStyle: FontStyle.normal,
                        //           fontSize: 15.0,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      "bill delivery desc".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
