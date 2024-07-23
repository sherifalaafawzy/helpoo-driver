// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../pages/user_home_content/service_request/shared/basic_fees_widget.dart';
import '../../pages/user_home_content/service_request/shared/discount_widget.dart';
import '../../pages/user_home_content/service_request/shared/request_id_widget.dart';
import '../round_button.dart';
import 'cancelWithConfirmBottomSheet.dart';
import 'counters_widget.dart';
import 'request_details_container_widget.dart';
import 'selectPaymentSheet.dart';

class serviceOpenOrConfirm extends StatefulWidget {
  var scaffoldKey;
  serviceOpenOrConfirm({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<serviceOpenOrConfirm> createState() => _serviceOpenOrConfirmState();
}

class _serviceOpenOrConfirmState extends State<serviceOpenOrConfirm> {
  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return RequestDetailsContainerWidget(
      height: Get.height * .4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Row(
            children: [
              const SizedBox(width: 14.5),
              Column(
                children: [
                  const SizedBox(height: 5.5),
                  RequestIdWidget(),
                ],
              ),
              const Spacer(),
              DiscountWidget(),
              const SizedBox(width: 23),
            ],
          ),
          const SizedBox(height: 7),
          BasicFeesWidget(),
          const SizedBox(height: 18),
          CountersWidget(),
          Expanded(
            child: Row(
              mainAxisAlignment: (cubit.request.open)
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: cubit.request.open,
                  child: SizedBox(
                    width: Get.width * .4,
                    height: 43,
                    child: MaterialButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: mainColor,
                        child: Text(
                          clickable ? "confirm".tr : "Loading......".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appWhite,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          // if (cubit.request.paymentMethod == "") {

                          setState(() {
                            clickable = false;
                            cubit.ableToUsePicker = false;
                          });

                          Get.bottomSheet(selectPaymentSheet(
                            type: 'SR',
                            bloc: cubit,
                          ));
                          setState(() {
                            clickable = true;
                          });
                          // } else {
                          //   setState(() {
                          //     clickable = false;
                          //     cubit.ableToUsePicker = false;
                          //   });
                          //   bool success = await cubit.confirmRequest();
                          //   if (success) {
                          //     bool done = await cubit.assignDrivertoRequest();
                          //     if (done) {
                          //       await FCM.sendMessage(
                          //           cubit.request.driver.fcmToken!,
                          //           "helpoo",
                          //           "تم استقبال طلب جديد",
                          //           // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                          //           cubit.request.id.toString(),
                          //           'service-request');
                          //       SlackNotifier(
                          //               'T03V3CBN65P/B03UQLXN1QB/fmqrwgTnkxt1ml1huGvVKJy3')
                          //           .send(
                          //               "Request ID: ${cubit.request.id.toString()}\nClient Name: ${cubit.request.clientName}\nClient Phone: ${cubit.request.clientPhone}\nDriver: ${cubit.request.driver.name} \nDriver Phone: ${cubit.request.vehiclePhoneNumber} \nOriginal Fees: ${cubit.request.originalFees.toString()}\nFinal Fees: ${cubit.request.fees.toString()}\nCorporate: ${cubit.request.corporateName != "" ? 'Yes' : 'No'}\nCreated by: ${cubit.request.createdByUser}\nFrom: ${cubit.request.clientAddress.toString()}\nTo: ${cubit.request.destinationAddress.toString()}\nLink: ${cubit.request.link}",
                          //               channel: 'helpoo-requests');
                          //       setState(() {
                          //         clickable = true;
                          //       });
                          //     } else {
                          //       Get.snackbar(
                          //           "Helpoo".tr, "No Drivers Avaliable".tr);
                          //     }
                          //   } else {
                          //     Get.bottomSheet(selectPaymentSheet(
                          //       type: 'SR',
                          //       bloc: cubit,
                          //     ));
                          //     setState(() {
                          //       clickable = true;
                          //     });
                          //   }
                          // }
                        }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: Get.width * .4,
                    height: 43,
                    child: RoundButton(
                        onPressed: () {
                          if (clickable == true || cubit.request.open) {
                            Get.bottomSheet(cancelWithConfirmBottomSheet());
                          } else {
                            HelpooInAppNotification.showMessage(
                                message:
                                    "in order to cancel your request please call 17000");
                            // Get.snackbar("Helpoo",
                            //     "in order to cancel your request please call 17000");
                          }
                        },
                        padding: false,
                        text: "cancel request".tr,
                        color: appBlack)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
