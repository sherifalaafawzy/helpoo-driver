import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';

import '../../../dataLayer/Constants/variables.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../pages/user_home_content/service_request/chooseService.dart';
import '../FNOL/summary/requestAfterReport/callCenterSupport.dart';
import '../round_button.dart';
import 'normalTowingCard.dart';
import 'premiumTowingCard.dart';

class selectTowingSheet extends StatefulWidget {
  const selectTowingSheet({super.key});

  @override
  State<selectTowingSheet> createState() => _selectTowingSheetState();
}

class _selectTowingSheetState extends State<selectTowingSheet> {
  TextEditingController voucherCodeCtrl = TextEditingController();
  bool voucherCode = false;
  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return BlocListener<ServiceRequestBloc, ServiceRequestState>(
      listener: (context, state) {
        if (state is changeRadioPremium || state is changeRadioNormal) {
          setState(() {});
        }
      },
      child: SingleChildScrollView(
        child: SizedBox(
            height: Get.height * 0.68,
            child: Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucherCode
                              ? "Vaild Promo Code".tr
                              : "Have Voucher Code?".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: Get.width * .88,
                                height: Get.height * .055,
                                child: TextField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[a-z A-Z 0-9]'))
                                  ],
                                  controller: voucherCodeCtrl,
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Image.asset('assets/imgs/coupon.png'),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      hintText: "Voucher Code".tr,
                                      suffixIcon: voucherCode
                                          ? RoundButton(
                                              onPressed: () {
                                                setState(() {
                                                  voucherCodeCtrl.text = "";
                                                  voucherCode = false;
                                                });
                                              },
                                              padding: false,
                                              text: "Change".tr,
                                              color: mainColor)
                                          : RoundButton(
                                              onPressed: () {
                                                HelpooInAppNotification.showMessage(
                                                    message:
                                                        "This Feature Underdevelopment"
                                                            .tr);
                                                // Get.snackbar(
                                                // 'Alert'.tr,
                                                // "This Feature Underdevelopment"
                                                // .tr);
                                                // if (voucherCodeCtrl.text !=
                                                //     "") {
                                                //   setState(() {
                                                //     voucherCode = true;
                                                //   });
                                                // }
                                              },
                                              padding: false,
                                              text: "Submit".tr,
                                              color: mainColor)),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "choose towing service".tr,
                              style: GoogleFonts.tajawal(
                                textStyle: const TextStyle(
                                  color: appBlack,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 21.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  normalTowingCard(
                    voucherCode: voucherCode,
                  ),
                  Divider(
                    color: mainColor,
                    thickness: 1.5,
                    endIndent: 50,
                    indent: 50,
                  ),
                  premiumTowingCard(
                    voucherCode: voucherCode,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RoundButton(
                                onPressed: clickable
                                    ? () async {
                                        // Get.bottomSheet(selectPaymentSheet(
                                        //   type: 'SR',
                                        //   bloc: cubit,
                                        // ));
                                        setState(() {
                                          cubit.ableToUsePicker = false;
                                          clickable = false;
                                        });
                                        String success =
                                            await cubit.getDriver();
                                        if (success == "Done") {
                                          await cubit.createRequest(cubit);
                                          await cubit
                                              .drawLinesFromDriverToClient();
                                          Navigator.pop(context);
                                        } else if (success == "Distance") {
                                          Get.to(() => callCenterupport());
                                        } else {
                                          setState(() {
                                            cubit.request.isWorking = false;
                                          });
                                          cubit.googleMapsModel.clearMapModel();
                                          await cubit.getLocation();
                                          await cubit.request.clearRequest();
                                          Get.to(() => chooseService());
                                        }
                                      }
                                    : () {},
                                padding: false,
                                text: clickable
                                    ? "confirm".tr
                                    : "Loading......".tr,
                                color: mainColor)),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
