import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import '../../../../../dataLayer/constants/variables.dart';

import '../../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return BlocBuilder<NewServiceRequestBloc, NewServiceRequestState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset('assets/imgs/discount.png'),
            ),
            const SizedBox(height: 6),
            Container(
              width: 101,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    11,
                  ),
                ),
                border: Border.all(color: const Color(0xff707070), width: 1),
                color: const Color(0xff58be3f).withOpacity(0.2865059971809387),
              ),

              child: Center(
                child: Text(
                  // "discount".tr + cubit.request.discountPercentage.toString() + "%",
                  "discount".tr +
                      double.parse(
                        sRBloc.getHighestDiscount(
                          [
                            cubit.request.adminDiscount ?? 0,
                            cubit.request.discountPercentage ?? 0,
                          ],
                        ),
                      ).toString() +
                      "%",
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
