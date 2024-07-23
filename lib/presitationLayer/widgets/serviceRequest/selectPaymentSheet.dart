import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:slack_notifier/slack_notifier.dart';
import '../../../dataLayer/Constants/variables.dart';
import '../../../dataLayer/models/FCM.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../pages/onlinePayment.dart';
import '../../pages/shared/packageActivation.dart';
import '../../pages/shared/selectPaymentMethod.dart';
import '../round_button.dart';

class selectPaymentSheet extends StatefulWidget {
  final String type;
  final bloc;

  const selectPaymentSheet({super.key, required this.type, required this.bloc});

  @override
  State<selectPaymentSheet> createState() => _selectPaymentSheetState();
}

class _selectPaymentSheetState extends State<selectPaymentSheet> {
  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        child: Container(
          color: appOffWhite,
          height: Get.height * .4,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17.0,
                  vertical: 20,
                ),
                child: Text(
                  "select payment method".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Visibility(
                visible: widget.type != "package",
                child: selectPaymentMethod(
                  title: "pay driver using cash".tr,
                  value: "cash",
                  icon: 'assets/imgs/cash.png',
                  onChanged: (v) {
                    if (clickable) {
                      setState(() {
                        if (widget.type == "package") {
                          widget.bloc.paymentMethod = 'cash';
                        } else {
                          widget.bloc.request.paymentMethod = 'cash';
                        }
                      });
                    }
                  },
                  paymentGroup: widget.type == "package"
                      ? widget.bloc.paymentMethod
                      : widget.bloc.request.paymentMethod,
                ),
              ),
              Visibility(
                visible: widget.type != "package",
                child: selectPaymentMethod(
                  title: "pay driver using credit card".tr,
                  value: "card-to-driver",
                  icon: 'assets/imgs/pos.png',
                  onChanged: (v) {
                    if (clickable) {
                      setState(() {
                        if (widget.type == "package") {
                          widget.bloc.paymentMethod = v;
                        } else {
                          widget.bloc.request.paymentMethod = v;
                        }
                      });
                    }
                  },
                  paymentGroup: widget.type == "package"
                      ? widget.bloc.paymentMethod
                      : widget.bloc.request.paymentMethod,
                ),
              ),
              selectPaymentMethod(
                title: "Online Payment".tr,
                value: "online-card",
                icon: 'assets/imgs/credit-card.png',
                onChanged: (v) {
                  if (clickable) {
                    setState(() {
                      if (widget.type == "package") {
                        widget.bloc.paymentMethod = v;
                        debugPrint(widget.bloc.paymentMethod);
                      } else {
                        widget.bloc.request.paymentMethod = v;
                      }
                    });
                  }
                },
                paymentGroup: widget.type == "package"
                    ? widget.bloc.paymentMethod
                    : widget.bloc.request.paymentMethod,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RoundButton(
                            onPressed: clickable
                                ? () async {
                                    setState(() {
                                      clickable = false;
                                    });
                                    if (widget.type == "package") {
                                      if (widget.bloc.paymentMethod ==
                                          "online-card") {
                                        String url = await widget.bloc
                                            .getPaymentTokenPackage();
                                        Get.to(() => onlinePayment(
                                            url: url, type: "package"));
                                      } else {
                                        bool success = await widget.bloc
                                            .subscribePackage(
                                                CurrentUser.selectedPackage,
                                                widget.bloc);
                                        if (success) {
                                          Get.back();
                                          Get.bottomSheet(Material(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(18),
                                                topRight: Radius.circular(18),
                                              ),
                                              child: Container(
                                                color: appOffWhite,
                                                height: Get.height * .35,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [

                                                    Text(
                                                      "Payment Done Successfuly"
                                                          .tr,
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: appBlack,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                        child: Image.asset(
                                                            'assets/imgs/paid-logo.png')),
                                                    RoundButton(
                                                        onPressed: () {
                                                          Get.to(() =>
                                                              packageActivation());
                                                        },
                                                        padding: true,
                                                        text: "Done".tr,
                                                        color: mainColor)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                        }
                                      }
                                    } else {
                                      if (widget.bloc.request.paymentMethod !=
                                          "") {
                                        setState(() {
                                          widget.bloc.request.isWorking = true;
                                        });
                                        bool success =
                                            await widget.bloc.confirmRequest();
                                        if (success) {
                                          bool done = await widget.bloc
                                              .assignDrivertoRequest();
                                          if (done) {
                                            await FCM.sendMessage(
                                                widget.bloc.request.driver
                                                    .fcmToken!,
                                                "helpoo",
                                                "تم استقبال طلب جديد",
                                                // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                                                widget.bloc.request.id
                                                    .toString(),
                                                'service-request');
                                            SlackNotifier(
                                                    'T03V3CBN65P/B03UQLXN1QB/fmqrwgTnkxt1ml1huGvVKJy3')
                                                .send(
                                                    "Request ID: ${widget.bloc.request.id.toString()}\nClient Name: ${widget.bloc.request.clientName}\nClient Phone: ${widget.bloc.request.clientPhone}\nDriver: ${widget.bloc.request.driver.name} \nDriver Phone: ${widget.bloc.request.vehiclePhoneNumber} \nOriginal Fees: ${widget.bloc.request.originalFees.toString()}\nFinal Fees: ${widget.bloc.request.fees.toString()}\nCorporate: ${widget.bloc.request.corporateName != "" ? 'Yes' : 'No'}\nCreated by: ${widget.bloc.request.createdByUser}\nFrom: ${widget.bloc.request.clientAddress.toString()}\nTo: ${widget.bloc.request.destinationAddress.toString()}\nLink: ${widget.bloc.request.link}",
                                                    channel: 'helpoo-requests');
                                            if (widget.bloc.request
                                                    .paymentMethod ==
                                                "online-card") {
                                              String url;
                                              url = await widget.bloc
                                                  .getPaymentTokenRequest(
                                                      widget.bloc);
                                              if (url == "") {
                                                url = await widget.bloc
                                                    .getPaymentTokenRequest(
                                                        widget.bloc);
                                              }

                                              Get.to(() => onlinePayment(
                                                    url: url,
                                                    type: "SR",
                                                    cubit: widget.bloc,
                                                  ));
                                            } else {
                                              await widget.bloc
                                                  .drawLinesFromDriverToClient();
                                              Navigator.pop(context);

                                              // String success = await widget.bloc.getDriver();
                                              // if (success == "Done") {
                                              //   if (widget.bloc.request.open) {
                                              //     await widget.bloc
                                              //         .changePaymentMethod(widget.bloc);
                                              //   } else {
                                              //     await widget.bloc.createRequest(widget.bloc);
                                              //   }
                                              //   if (widget.bloc.request.paymentMethod ==
                                              //       "online-card") {
                                              //     String url;
                                              //     url = await widget.bloc
                                              //         .getPaymentTokenRequest(widget.bloc);
                                              //     if (url == "") {
                                              //       url = await widget.bloc
                                              //           .getPaymentTokenRequest(widget.bloc);
                                              //     }
                                              //     Get.to(() => onlinePayment(
                                              //           url: url,
                                              //         type: "SR",
                                              //           cubit: widget.bloc,
                                              //         ));
                                              //   } else {
                                              //     await widget.bloc
                                              //         .drawLinesFromDriverToClient();
                                              //     Navigator.pop(context);
                                              //     Navigator.pop(context);
                                              //     setState(() {
                                              //       widget.bloc.request.isWorking = false;
                                              //     });
                                              //   }
                                              // } else if (success == "Distance") {
                                              //   Get.to(() => callCenterupport());
                                              // } else {
                                              //   setState(() {
                                              //     widget.bloc.request.isWorking = false;
                                              //   });
                                              //   widget.bloc.googleMapsModel.clearMapModel();
                                              //   await widget.bloc.getLocation();
                                              //   await widget.bloc.request.clearRequest();
                                              //   Get.to(() => chooseService());
                                              // }
                                            }
                                            setState(() {
                                              clickable = true;
                                            });
                                          } else {
                                            HelpooInAppNotification.showMessage(
                                                message:
                                                    "No Drivers Avaliable".tr);
                                            // Get.snackbar("Helpoo".tr,
                                            // "No Drivers Avaliable".tr);
                                            setState(() {
                                              clickable = true;
                                            });
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          HelpooInAppNotification
                                              .showErrorMessage(
                                                  message:
                                                      "Something Wrong".tr);
                                          // Get.snackbar("Helpoo".tr,
                                          // "SomeThing Wrong".tr);

                                          Navigator.pop(context);
                                        }
                                      } else {
                                        HelpooInAppNotification.showMessage(
                                            message:
                                                "Please Choose Payment Method"
                                                    .tr);
                                        // Get.snackbar("Helpoo".tr,
                                        // "Please Choose Payment Method".tr);
                                      }
                                    }
                                    setState(() {
                                      clickable = true;
                                    });
                                  }
                                : () {},
                            padding: false,
                            text: clickable ? "confirm".tr : "Loading......".tr,
                            color: mainColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
