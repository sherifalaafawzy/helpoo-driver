import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/prints.dart';

// i want to know if this bottom sheet is open
// i want to know if this bottom sheet is open

primaryBottomSheet({
  required BuildContext context,
  required Widget child,
  bool isTopIcon = true,
  bool isWaitingDriverToAccept = false,
  String? minutes,
  String? price,
}) {
  return showBottomSheet(
    context: context,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    // constraints: BoxConstraints(
    //   maxHeight: 600,
    //   minHeight: 200,
    // ),
    builder: (context) => Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: isTopIcon
                ? 0.0
                : isWaitingDriverToAccept
                    ? 90.0
                    : 30.0,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isTopIcon)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                if (!isTopIcon && !isWaitingDriverToAccept) space30Vertical(),
                SingleChildScrollView(
                  child: child,
                ),
              ],
            ),
          ),
        ),
        if (!isTopIcon && isWaitingDriverToAccept)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          minutes ?? '--',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          'minute'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  space20Horizontal(),
                  Container(
                    width: 80.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price ?? '0',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          'EGP'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffb78339),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                alignment: Alignment.center,
                child: Text(
                  "please wait for driver to accept your request".tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (!isTopIcon && !isWaitingDriverToAccept)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      minutes ?? '--',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      'minute'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              space20Horizontal(),
              Container(
                width: 80.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      price ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      'EGP'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    ),
  ).closed.then(
    (value) {
      printWarning('close ==>> bottom sheet closed');
      printWarning(
          '${sRBloc.serviceRequestModel?.serviceRequestDetails.status ?? ''}');
      // sRBloc.isPrimaryBottomSheetOpened = false;

      if (sRBloc.countOpenedBottomSheets != 0) {
        printWarning('close ==>> bottom sheet case 1');
        sRBloc.countOpenedBottomSheets -= 1;
      }

      if (sRBloc.serviceRequestModel != null) {
        //* Open
        if (sRBloc.serviceRequestModel!.serviceRequestDetails.status ==
            ServiceRequestStatusEnum.open.name) {
          printWarning('close ==>> bottom sheet case 2 (open)');
          sRBloc.cancelServiceRequest();
        }

        //* Confirmed
        if (sRBloc.serviceRequestModel!.serviceRequestDetails.status ==
            ServiceRequestStatusEnum.confirmed.name) {
          printWarning('close ==>> bottom sheet case 3 (Confirmed)');
          sRBloc.getCurrentServiceRequestStatus();
        }

        //* Done || Dest Arrived
        if (sRBloc.serviceRequestModel!.serviceRequestDetails.status ==
                ServiceRequestStatusEnum.done.name) {
          printWarning('close ==>> bottom sheet (SR DONE)');
          sRBloc.countOpenedBottomSheets = 0;
          if (sRBloc.timer != null) {
            sRBloc.timer!.cancel();
          }
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => homeScreen(
                index: 0,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    },
  );
}
