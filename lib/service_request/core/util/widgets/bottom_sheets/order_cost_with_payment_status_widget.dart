import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';

class OrderCostWithPaymentStatus extends StatelessWidget {
  const OrderCostWithPaymentStatus({
    super.key,
    required this.isOrderAccepted,
  });

  final bool isOrderAccepted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.withOpacity(0.3),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: 10,
              ),
              child: Text(
                '${'basic cost'.tr} ${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.fees.toString() : ''} ${'EGP'.tr}',
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.fade,
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          if (!isOrderAccepted)
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: 20,
              ),
              child: Text(
                '${'wench'.tr} ${sRBloc.isNormalTowingSelected ? 'basic towing'.tr : 'premium towing'.tr}',
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          if (isOrderAccepted)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[600],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              alignment: Alignment.center,
              child: Text(
                '${'Pay'.tr} ${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.paymentMethod : ''}',
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
