// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import '../../../../dataLayer/constants/enum.dart';
import '../../../../dataLayer/models/currentUser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/bloc/driver/driver_cubit.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FCM.dart';
import '../../../../dataLayer/models/SMS.dart';
import '../../../../dataLayer/models/serviceReqest.dart';
import '../../../../dataLayer/models/vehicle.dart';
import '../../plateNumberInput.dart';
import '../../round_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeStatusWidget extends StatefulWidget {
  ServiceRequest c;

  ChangeStatusWidget({super.key, required this.c});

  @override
  State<ChangeStatusWidget> createState() => _ChangeStatusWidgetState();
}

class _ChangeStatusWidgetState extends State<ChangeStatusWidget> {
  List<String> imgs = [];
  bool comingRequest = false;
  final ImagePicker picker = ImagePicker();

  Future<bool> selectImages(cubit) async {
    imgs.clear();
    for (int i = 0; i < 8; i++) {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        Uint8List imagebytes = await pickedFile.readAsBytes();
        String _base64String = base64.encode(imagebytes);
        imgs.add(_base64String);
        cubit.driverImages(widget.c.id, imgs);
      } else {
        debugPrint('No Image Selected');
        return false;
      }
    }
    //  Vehicle.plateNumberC.clear();
    return true;
  }

  @override
  void initState() {
    var cubit = BlocProvider.of<DriverCubit>(context);

    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.c.open) {
        DateTime now = DateTime.now().toUtc();
        DateTime past = widget.c.createdAt!;
        debugPrint(now.toString());
        debugPrint(past.toString());
        Duration timeDifference = now.difference(past);
        int minutesDifference = timeDifference.inMinutes;

        if (minutesDifference < 3) {
          setState(() {
            comingRequest = true;
          });
        } else {
          setState(() {
            comingRequest = false;
          });
          cubit.unAssinDriver(widget.c.id);
          debugPrint("-------------------");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = driverCubit;
    return BlocConsumer<DriverCubit, DriverState>(
      listener: (context, state) {
        if (state is UpdateRequestSuccessStatus) {
          cubit.getRequests();
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: appGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Request ID : ".tr +
                              " " +
                              widget.c.id.toString() +
                              " - ",
                          style: TextStyle(
                            fontFamily: "HelveticaNeue",
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                        Text(
                          widget.c.fees.toString() + " " + "EGP".tr + " - ",
                          style: TextStyle(
                            fontFamily: "HelveticaNeue",
                            fontWeight: FontWeight.bold,
                            color: appRed,
                          ),
                        ),
                        Text(
                          "${widget.c.paymentMethod}".tr,
                          style: TextStyle(
                            fontFamily: "HelveticaNeue",
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.c.status == ServiceRequestStatus.canceled
                            ? MdiIcons.carOff
                            : MdiIcons.carConnected,
                        color: widget.c.status == ServiceRequestStatus.done
                            ? mainColor
                            : widget.c.status == ServiceRequestStatus.canceled
                                ? appRed
                                : appBlack,
                      ),
                    ],
                  ),
                  title: Text((widget.c.car?.manufacture?.name ?? '') +
                      " - " +
                      (widget.c.car?.model?.name ?? '')),
                  subtitle: Text((widget.c.car?.color ?? '').tr
                      // + " /  " +
                      //     widget.c.car!.plateNo.toString()
                      ),
                  trailing: Visibility(
                    visible: widget.c.accepted ||
                        widget.c.arrived ||
                        widget.c.started,
                    child: IconButton(
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse(
                            widget.c.clientPhone != null
                                ? 'tel:${widget.c.clientPhone.toString()}'
                                : ''))) {
                          throw 'Could not launch url'.tr;
                        }
                      },
                      icon: Icon(
                        MdiIcons.phone,
                        color: mainColor,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: appGrey,
                  height: 2,
                ),
                const Divider(
                  color: appGrey,
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.c.paymentMethod.isEmpty ||
                              (widget.c.paymentMethod == 'online-card' &&
                                  widget.c.paymentStatus ==
                                      PaymentStatus.notPaid)
                          ? Expanded(
                              child: Text(
                                'Waiting for client confirmation'.tr,
                                style: GoogleFonts.tajawal(
                                  textStyle: TextStyle(
                                    color: appBlack,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : widget.c.started
                              ? Expanded(
                                  child: RoundButton(
                                      padding: false,
                                      color: mainColor,
                                      text: "Arrived to Destination".tr,
                                      isLoading:
                                          state is UpdateRequestLoadingStatus,
                                      onPressed: () {
                                        Get.dialog(AlertDialog(
                                          title:
                                              Text("Arrived to Destination".tr),
                                          actions: [
                                            RoundButton(
                                                onPressed: () async {
                                                  cubit.updateRequestStatus(
                                                      widget.c.id.toString(),
                                                      'destArrived');
                                                  setState(() {
                                                    widget.c.status ==
                                                        ServiceRequestStatus
                                                            .destArrived;
                                                  });
                                                  Get.back();
                                                },
                                                padding: false,
                                                text: "yes".tr,
                                                color: mainColor)
                                          ],
                                        ));
                                      }),
                                )
                              : widget.c.arrived
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          if (cubit.showStartShoot)
                                            RoundButton(
                                                padding: false,
                                                color: mainColor,
                                                text: "بدا التصوير؟".tr,
                                                onPressed: () {
                                                  Get.dialog(AlertDialog(
                                                    title:
                                                        Text("بدا التصوير؟".tr),
                                                    actions: [
                                                      RoundButton(
                                                          onPressed: () async {
                                                            if (widget.c.car!
                                                                    .plateNo !=
                                                                null) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0)),
                                                                      child:
                                                                          Container(
                                                                        // width: 500,
                                                                        height: Get.height *
                                                                            0.30,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(12.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 320.0,
                                                                                child: plateNumberInput(
                                                                                  visible: false,
                                                                                  packageCar: false,
                                                                                  enable: true,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                  child: RoundButton(
                                                                                      onPressed: () async {
                                                                                        if (cubit.checkPlateValidation()) {
                                                                                          bool validation = await cubit.validatePlate(widget.c.id, Vehicle.plateNumber);
                                                                                          if (false) {
                                                                                            Vehicle.clearVehiclePlate();
                                                                                            cubit.updateRequestStatus(widget.c.id, 'arrived');
                                                                                            widget.c.status == ServiceRequestStatus.arrived;
                                                                                            FCM.sendMessage(
                                                                                                widget.c.clientFcmToken ?? "",
                                                                                                "helpoo",
                                                                                                "لقد وصل السائق اليك",
                                                                                                // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                                                                                                widget.c.id.toString(),
                                                                                                'service-request');
                                                                                            await selectImages(cubit);

                                                                                            Navigator.pop(context);
                                                                                            Navigator.pop(context);
                                                                                          } else {
                                                                                            Vehicle.clearVehiclePlate();
                                                                                            Navigator.pop(context);
                                                                                            Navigator.pop(context);
                                                                                            //   await FCM.sendMessage(widget.c.clientFcmToken ?? "", "helpoo", "لقد وصل السائق اليك", widget.c.id.toString(), 'service-request');
                                                                                            await selectImages(cubit).then((value) {
                                                                                              setState(() {
                                                                                                cubit.showStartShoot = false;

                                                                                              });
                                                                                            });
                                                                                          }
                                                                                        } else {
                                                                                          HelpooInAppNotification.showMessage(message: "Please enter plate number".tr);
                                                                                          // Get.snackbar(
                                                                                          //   "waring".tr,
                                                                                          //   "Please enter plate number".tr,
                                                                                          // );
                                                                                        }
                                                                                      },
                                                                                      padding: true,
                                                                                      isLoading: state is UpdateRequestLoadingStatus,
                                                                                      text: 'Validate'.tr,
                                                                                      color: mainColor)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          padding: false,
                                                          isLoading: state
                                                              is UpdateRequestLoadingStatus,
                                                          text: "yes".tr,
                                                          color: mainColor)
                                                    ],
                                                  ));
                                                }),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (imgs.length==8&&!cubit.showStartShoot)
                                            RoundButton(
                                                padding: false,
                                                color: mainColor,
                                                text: "Start Service".tr,
                                                isLoading: state
                                                    is UpdateRequestLoadingStatus,
                                                onPressed: () {
                                                  Get.dialog(AlertDialog(
                                                    title: Text(
                                                        "Start Service".tr),
                                                    actions: [
                                                      RoundButton(
                                                          onPressed: () async {
                                                            cubit.updateRequestStatus(
                                                                widget.c.id
                                                                    .toString(),
                                                                'started');
                                                            widget.c.status ==
                                                                ServiceRequestStatus
                                                                    .started;
                                                            Get.back();
                                                            await FCM.sendMessage(
                                                                widget.c.clientFcmToken ?? "",
                                                                "helpoo",
                                                                "لقد تم بدأ الرحله",
                                                                // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                                                                widget.c.id.toString(),
                                                                'service-request');
                                                          },
                                                          padding: false,
                                                          text: "yes".tr,
                                                          color: mainColor)
                                                    ],
                                                  ));
                                                }),
                                        ],
                                      ),
                                    )
                                  : widget.c.destArrived
                                      ? Expanded(
                                          child: RoundButton(
                                              padding: false,
                                              color: mainColor,
                                              isLoading: state
                                                  is UpdateRequestLoadingStatus,
                                              text: "done".tr,
                                              onPressed: () {
                                                Get.dialog(AlertDialog(
                                                  title:
                                                      Text("Did you finish".tr),
                                                  actions: [
                                                    RoundButton(
                                                        onPressed: () async {
                                                          cubit.finishRequest(
                                                              widget.c);
                                                          cubit.updateRequestStatus(
                                                              widget.c.id
                                                                  .toString(),
                                                              'done');
                                                          setState(() {
                                                            widget.c.status ==
                                                                ServiceRequestStatus
                                                                    .done;
                                                          });
                                                          Get.back();
                                                          await FCM.sendMessage(
                                                              widget.c.clientFcmToken ??
                                                                  "",
                                                              "helpoo",
                                                              "لقد تم انهاء الخدمه",
                                                              // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                                                              widget.c.id
                                                                  .toString(),
                                                              'service-request');
                                                        },
                                                        padding: false,
                                                        text: "yes",
                                                        isLoading: state
                                                            is UpdateRequestLoadingStatus,
                                                        color: mainColor)
                                                  ],
                                                ));
                                              }),
                                        )
                                      : widget.c.accepted
                                          ? Expanded(
                                              child: RoundButton(
                                                  padding: false,
                                                  color: mainColor,
                                                  text: "Arrived".tr,
                                                  onPressed: () {
                                                    Get.dialog(AlertDialog(
                                                      title: Text("Arrived".tr),
                                                      actions: [
                                                        RoundButton(
                                                            onPressed:
                                                                () async {
                                                              cubit.showStartShoot =
                                                                  true;
                                                              await cubit
                                                                  .updateRequestStatus(
                                                                      widget
                                                                          .c.id,
                                                                      'arrived');
                                                              Get.back();
                                                              await FCM.sendMessage(
                                                                  widget.c.clientFcmToken ??
                                                                      "",
                                                                  "helpoo",
                                                                  "لقد وصل السائق اليك",
                                                                  widget.c.id
                                                                      .toString(),
                                                                  'service-request');
                                                              //   await selectImages(cubit);
                                                            },
                                                            padding: false,
                                                            isLoading: state
                                                                is UpdateRequestLoadingStatus,
                                                            text: "yes".tr,
                                                            color: mainColor)
                                                      ],
                                                    ));
                                                  }),
                                            )
                                          : widget.c.confirmed
                                              ? Expanded(
                                                  child: RoundButton(
                                                    color: mainColor,
                                                    isLoading: state
                                                        is UpdateRequestLoadingStatus,
                                                    onPressed: () async {
                                                      await cubit
                                                          .updateRequestStatus(
                                                              widget.c.id,
                                                              'accepted');
                                                      debugPrint(
                                                          '----- updateRequestStatus');
                                                      debugPrint(
                                                          '----- ${widget.c.corporateCompanyId}');
                                                      debugPrint(
                                                          '----- ${widget.c.clientUserId}');
                                                      debugPrint(
                                                          '----- ${widget.c.createdByUser}');
                                                      debugPrint(
                                                          '----- ${(widget.c.corporateCompanyId != null && widget.c.corporateCompanyId != '').toString()}');
                                                      debugPrint(
                                                          '----- ${(widget.c.clientUserId != widget.c.createdByUser).toString()}');
/*
                                                      if ((widget.c.corporateCompanyId !=
                                                                  null &&
                                                              widget.c.corporateCompanyId !=
                                                                  '') ||
                                                          widget.c.clientUserId !=
                                                              widget.c
                                                                  .createdByUser) {
                                                        debugPrint(
                                                            '----- send acceptance sms');
                                                        printWarning(
                                                            'Driver Phone : ${CurrentUser.phoneNumber}');
                                                        await SMS.sendSingleSMS(
                                                            widget
                                                                .c.clientPhone!,
                                                            "هذا رابط تتبع رحلة الخدمة على هلبو" +
                                                                widget.c.link);
                                                        await SMS.sendSingleSMS(
                                                            widget
                                                                .c.clientPhone!,
                                                            "هذه بيانات السائق الخاص بطلبك"
                                                                    " " +
                                                                CurrentUser
                                                                    .name! +
                                                                " - " +
                                                                CurrentUser
                                                                    .phoneNumber!);
                                                      }*/
                                                      // await FCM.sendMessage(
                                                      //     widget.c.clientFcmToken,
                                                      //     "helpoo",
                                                      //     "تم قبول طلبك ",
                                                      //     // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
                                                      //     widget.c.id.toString(),
                                                      //     'service-request');
                                                    },
                                                    text: "Accept Request".tr,
                                                    padding: false,
                                                  ),
                                                )
                                              : widget.c.pending
                                                  ? Expanded(
                                                      child: Text(
                                                        'There is a problem please contact with call center'
                                                            .tr,
                                                        style:
                                                            GoogleFonts.tajawal(
                                                          textStyle:
                                                              const TextStyle(
                                                            color: appBlack,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : widget.c.open &&
                                                          comingRequest
                                                      ? Expanded(
                                                          child: Text(
                                                            'Waiting for client confirmation'
                                                                .tr,
                                                            style: GoogleFonts
                                                                .tajawal(
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: appBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )
                                                      : widget.c.done
                                                          ? widget.c.paymentStatus ==
                                                                  PaymentStatus
                                                                      .paid
                                                              ? Expanded(
                                                                  child: Text(
                                                                    'Service is done'
                                                                        .tr,
                                                                    style: GoogleFonts
                                                                        .tajawal(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        color:
                                                                            appBlack,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                        fontSize:
                                                                            16.0,
                                                                      ),
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                )
                                                              : Expanded(
                                                                  child:
                                                                      RoundButton(
                                                                    padding:
                                                                        false,
                                                                    isLoading: state
                                                                        is UpdateRequestLoadingStatus,
                                                                    color:
                                                                        mainColor,
                                                                    text:
                                                                        "confirm payment"
                                                                            .tr,
                                                                    onPressed:
                                                                        () {
                                                                      Get.bottomSheet(
                                                                          Card(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 16.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.stretch,
                                                                            children: [
                                                                              Center(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(16.0),
                                                                                  child: Text(
                                                                                    "Did you recieve the payment?".tr,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    "service fees is".tr,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Center(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    widget.c.fees.toString() + "EGP".tr,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 16,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                                child: RoundButton(
                                                                                    onPressed: () async {
                                                                                      await cubit.updateRequestStatus(widget.c.id, 'paid');
                                                                                      Get.back();
                                                                                    },
                                                                                    padding: false,
                                                                                    isLoading: state is UpdateRequestLoadingStatus,
                                                                                    text: "Yes",
                                                                                    color: mainColor),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ));
                                                                    },
                                                                  ),
                                                                )
                                                          : Container(
                                                              child: Text(
                                                                  'Trip Canceled'
                                                                      .tr),
                                                            ),
                    ],
                  ),
                ),
                Visibility(
                    visible: widget.c.destinationAddress != null &&
                        (widget.c.started || widget.c.accepted),
                    child: Divider()),
                Visibility(
                  visible:
                      widget.c.destinationAddress != null && widget.c.started,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            color: mainColor,
                            text: "Dropoff Directions".tr,
                            padding: false,
                            onPressed: () async {
                              await MapsLauncher.launchCoordinates(
                                  double.parse(widget
                                      .c.towingDestination!.latitude
                                      .toString()),
                                  double.parse(widget
                                      .c.towingDestination!.longitude
                                      .toString()));
                              // await MapLauncher.showMarker(
                              //   mapType: MapType.google,
                              //   coords: Coords(
                              //       double.parse(widget.c.destinationLatitude),
                              //       double.parse(widget.c.destinationLongitude)),
                              //   title: 'title',
                              //   description: 'description',
                              // );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.c.accepted,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            color: mainColor,
                            text: "Pickup Directions".tr,
                            padding: false,
                            onPressed: () async {
                              await MapsLauncher.launchCoordinates(
                                  double.parse(
                                      widget.c.clientLatitude.toString()),
                                  double.parse(
                                      widget.c.clientLongitude.toString()));
                              // await MapLauncher.showMarker(
                              //   mapType: MapType.google,
                              //   coords: Coords(
                              //       double.parse(widget.c.clientLatitude),
                              //       double.parse(widget.c.clientLongitude)),
                              //   title: 'tisstle',
                              //   description: 'descrssiption',
                              // );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
