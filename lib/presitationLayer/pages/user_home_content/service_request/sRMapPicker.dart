// ignore_for_file: invalid_use_of_visible_for_testing_member, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as place;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:map_picker/map_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../dataLayer/constants/enum.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../widgets/serviceRequest/cancelWithConfirmBottomSheet.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../homeScreen.dart';
import '../../../widgets/round_button.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../shared/waitingPage.dart';
import 'chooseService.dart';
import 'shared/currentLoc_search.dart';
import 'shared/desLoc_search.dart';
import '../../../widgets/serviceRequest/serviceOpenOrConfirm.dart';
import '../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../widgets/serviceRequest/serviceAcceptedArrivedStarted.dart';
import '../../../widgets/serviceRequest/serviceAcceptedArrivedStartedAbove.dart';
import '../../../widgets/serviceRequest/serviceClientRate.dart';
import '../../../widgets/serviceRequest/serviceDoneCancelled.dart';
import '../../../widgets/serviceRequest/serviceDoneAbove.dart';
import '../../../widgets/serviceRequest/serviceOpenOrConfirmAbove.dart';
import '../../../widgets/serviceRequest/servicePending.dart';

class serviceRMapPicker extends StatefulWidget {
  serviceRMapPicker({Key? key, this.isUpdatedRequest = false})
      : super(key: key);
  bool isUpdatedRequest;

  @override
  State<serviceRMapPicker> createState() => serviceRMapPickerState();
}

class serviceRMapPickerState extends State<serviceRMapPicker> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MapPickerController mapPickerController = MapPickerController();
  final _controller = Completer<GoogleMapController>();
  List<place.Placemark> placemarks = [];
  PanelController panelCtrl = new PanelController();
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  draw(cubit) async {
    await cubit.drawLinesFromDriverToClient();
  }

  void initState() {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    print("init every time");
    if (widget.isUpdatedRequest) {
      draw(cubit);
    } else {
      cubit.request.destinationAddress = "";
      cubit.request.towingDestination = null;
      cubit.ableToUsePicker = true;
      cubit.pickerUsability();
    }

    Timer.periodic(Duration(seconds: 6), (timer) async {
      if (!cubit.request.rated) {
        cubit.getRequest(cubit);
      }

      if (cubit.request.open) {
        cubit.ableToUsePicker = false;
        cubit.pickerUsability();
        await cubit
            .driverUpdateLocation()
            .then((value) async => cubit.drawLinesFromDriverToClient());
        // cubit.drawLinesFromDriverToClient();
      } else if (cubit.request.pending) {
        cubit.request.status = ServiceRequestStatus.pending;
        cubit.emit(GetMap());
        cubit.ableToUsePicker = false;
        cubit.pickerUsability();
      } else if (cubit.request.confirmed || cubit.request.accepted) {
        cubit.ableToUsePicker = false;
        cubit.pickerUsability();
        await cubit
            .driverUpdateLocation()
            .then((value) async => cubit.drawLinesFromDriverToClient());
      } else if (cubit.request.started || cubit.request.arrived) {
        await cubit.driverUpdateLocation().then((value) async =>
            await cubit.drawLinesFromDriverToDestination(cubit));

        cubit.ableToUsePicker = false;
        cubit.pickerUsability();
      } else if (cubit.request.done) {
        cubit.ableToUsePicker = false;
        cubit.pickerUsability();
        cubit.request.status = ServiceRequestStatus.done;
        cubit.emit(GetMap());
        if (cubit.request.paid) {
          cubit.ableToUsePicker = false;
          cubit.pickerUsability();
          cubit.request.paymentStatus = PaymentStatus.paid;
          cubit.emit(GetMap());
          // timer.cancel();
        }
      } else if (cubit.request.canceled) {
        cubit.ableToUsePicker = false;
        cubit.pickerUsability();
        cubit.request.status = ServiceRequestStatus.canceled;
        cubit.emit(GetMap());
        // timer.cancel();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
      builder: (context, state) {
        return (state is ServiceRequestInitial)
            ? waitingWidget()
            : willPopScopeWidget(
                onWillPop: () async {
                  if (cubit.request.open) {
                    Get.bottomSheet(cancelWithConfirmBottomSheet());
                  } else if (cubit.request.id == null) {
                    await cubit.googleMapsModel.clearMapModel();
                    await cubit.request.clearRequest();
                    Get.to(() => chooseService());
                    // timer.cancel();
                  } else {
                    await cubit.googleMapsModel.clearMapModel();
                    await cubit.request.clearRequest();
                    cubit.cameraPosition = CameraPosition(
                        target: LatLng(cubit.request.clientLatitude,
                            cubit.request.clientLongitude));
                    Get.to(() => homeScreen(index: 0));
                    // timer.cancel();
                  }
                  return true;
                },
                child: Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: appWhite),
                    backgroundColor: mainColor,
                    centerTitle: true,
                    leading: Container(
                      height: 48,
                      width: 48,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            if (cubit.request.open) {
                              Get.bottomSheet(cancelWithConfirmBottomSheet());
                            } else if (cubit.request.id == null) {
                              await cubit.googleMapsModel.clearMapModel();
                              await cubit.request.clearRequest();
                              Get.to(() => chooseService());
                              // timer.cancel();
                            } else {
                              cubit.cameraPosition = CameraPosition(
                                  target: LatLng(
                                      double.parse(
                                          cubit.request.clientLatitude),
                                      double.parse(
                                          cubit.request.clientLongitude)));
                              await cubit.googleMapsModel.clearMapModel();
                              await cubit.request.clearRequest();
                              Get.to(() => homeScreen(index: 0));
                              // timer.cancel();
                            }
                          },
                          icon: Icon(
                            CurrentUser.isArabic
                                ? MdiIcons.arrowRightThin
                                : MdiIcons.arrowLeftThin,
                            color: appWhite,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      (cubit.request.create)
                          ? 'Select Your Location'.tr
                          : 'status'.tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appWhite,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  // floatingActionButtonLocation: cubit.request.create
                  //     ? FloatingActionButtonLocation.endFloat
                  //     : FloatingActionButtonLocation.miniEndTop,
                  // floatingActionButton: Padding(
                  //   padding: EdgeInsets.only(
                  //       top: cubit.request.create ? 0 : 60,
                  //       bottom: cubit.request.create ? 60 : 0),
                  //   child: FloatingActionButton(
                  //     onPressed: () {
                  //       if (cubit.request.create) {
                  //         cubit.getLocationUsingButton();
                  //       } else if (cubit.request.open ||
                  //           cubit.request.confirmed ||
                  //           cubit.request.accepted) {
                  //         cubit.drawLinesFromDriverToClient();
                  //       } else {
                  //         cubit.drawLinesFromDriverToDestination(cubit);
                  //       }
                  //     },
                  //     tooltip: 'Get Location',
                  //     child: Icon(Icons.location_on),
                  //   ),
                  // ),
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      MapPicker(
                        iconWidget: cubit.request.create
                            ? Image.asset(
                                'assets/imgs/pin.png',
                                height: 60,
                              )
                            : Container(),
                        mapPickerController: mapPickerController,
                        child: GoogleMap(
                          myLocationEnabled: false,
                          mapType: MapType.normal,
                          mapToolbarEnabled: false,
                          tiltGesturesEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomGesturesEnabled: true,
                          // minMaxZoomPreference:
                          //     MinMaxZoomPreference(10, 18),
                          markers: cubit.googleMapsModel.markers,
                          circles: cubit.googleMapsModel.circle,
                          polylines: cubit.googleMapsModel.polylines,
                          zoomControlsEnabled: true,
                          initialCameraPosition: cubit.ableToUsePicker ||
                                  cubit.cameraPosition == null
                              ? CameraPosition(
                                  target: LatLng(
                                      double.parse(
                                          cubit.request.clientLatitude == null
                                              ? "0"
                                              : cubit.request.clientLatitude
                                                  .toString()),
                                      double.parse(
                                          cubit.request.clientLongitude == null
                                              ? "0"
                                              : cubit.request.clientLongitude
                                                  .toString())),
                                  zoom: 15)
                              : cubit.cameraPosition!,
                          onMapCreated: (GoogleMapController controller) async {
                            if (!_controller.isCompleted) {
                              _controller.complete(controller);
                            }
                            cubit.mapController = controller;
                            cubit.mapController
                                ?.animateCamera(cubit.cameraUpdate!);
                          },
                          onCameraMoveStarted: () async {
                            mapPickerController.mapMoving!();
                          },
                          onTap: (LatLng latLng) async {
                            if (cubit.ableToUsePicker) {
                              switch (cubit.request.fieldPin) {
                                case MapPickerStatus.pickup:
                                  setState(() {
                                    cubit.cameraPosition = CameraPosition(
                                        target: LatLng(
                                            latLng.latitude, latLng.longitude),
                                        zoom: 15);
                                    cubit.cameraUpdate =
                                        CameraUpdate.newCameraPosition(
                                            cubit.cameraPosition!);
                                    cubit.mapController
                                        ?.animateCamera(cubit.cameraUpdate!);
                                  });
                                  break;
                                case MapPickerStatus.destination:
                                  setState(() {
                                    cubit.cameraPosition = CameraPosition(
                                        target: LatLng(
                                            latLng.latitude, latLng.longitude),
                                        zoom: 15);
                                    cubit.cameraUpdate =
                                        CameraUpdate.newCameraPosition(
                                            cubit.cameraPosition!);
                                    cubit.mapController
                                        ?.animateCamera(cubit.cameraUpdate!);
                                  });
                                  break;
                              }
                            }
                          },
                          onCameraIdle: () async {
                            if (cubit.ableToUsePicker) {
                              switch (cubit.request.fieldPin) {
                                case MapPickerStatus.pickup:
                                  GeocodingResponse geocodingResponse =
                                      await GoogleMapsGeocoding(
                                              apiKey: MapApiKey)
                                          .searchByLocation(cubit
                                              .cameraPosition!
                                              .target
                                              .toGoogleLocation);
                                  GeocodingResult geocodingResult =
                                      geocodingResponse.results.first;
                                  setState(() {
                                    cubit.request.clientAddress =
                                        geocodingResult.formattedAddress ?? '';
                                    cubit.request.pickup =
                                        cubit.cameraPosition!.target;
                                  });
                                  break;
                                case MapPickerStatus.destination:
                                  GeocodingResponse geocodingResponse =
                                      await GoogleMapsGeocoding(
                                              apiKey: MapApiKey)
                                          .searchByLocation(cubit
                                              .cameraPosition!
                                              .target
                                              .toGoogleLocation);
                                  GeocodingResult geocodingResult =
                                      geocodingResponse.results.first;
                                  setState(() {
                                    cubit.request.destinationAddress =
                                        geocodingResult.formattedAddress ?? '';
                                    cubit.request.towingDestination =
                                        cubit.cameraPosition!.target;
                                  });
                                  break;
                              }
                            }
                            mapPickerController.mapFinishedMoving!();
                          },
                          onCameraMove: (cameraPosition) async {
                            if (cubit.ableToUsePicker) {
                              cubit.cameraPosition = cameraPosition;
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: cubit.request.create,
                        child: Positioned(
                            top: 20,
                            left: 5,
                            right: 5,
                            child: CurrentLocSearch()),
                      ),
                      Visibility(
                        visible: cubit.request.create,
                        child: Positioned(
                            top: 80, left: 5, right: 5, child: DesLocSearch()),
                      ),
                      Visibility(
                        visible: cubit.request.create,
                        child: Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: SizedBox(
                            height: 50,
                            child: RoundButton(
                              color: mainColor,
                              padding: false,
                              text: 'Submit'.tr,
                              onPressed: () async {
                                if (cubit.request.isClickAble) {
                                  if (cubit.request.destinationAddress == "") {
                                    HelpooInAppNotification.showErrorMessage(
                                        message:
                                            "Please Choose Destination".tr);
                                    // Get.snackbar("Error".tr,
                                    // "Please Choose Destination".tr);
                                    setState(() {
                                      cubit.request.isClickAble = true;
                                    });
                                  } else {
                                    setState(() {
                                      cubit.request.isClickAble = false;
                                      cubit.request.isWorking = true;
                                    });
                                    cubit.getDirections(cubit);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      (cubit.request.open || cubit.request.confirmed)
                          ? SlidingUpPanel(
                              controller: panelCtrl,
                              renderPanelSheet: false,
                              maxHeight: 450,
                              minHeight: 200,
                              defaultPanelState: PanelState.OPEN,
                              panel: Container(
                                margin: const EdgeInsets.only(
                                    right: 24.0, left: 24.0),
                                child: Stack(
                                  children: [
                                    serviceOpenOrConfirm(
                                        scaffoldKey: scaffoldKey),
                                    Positioned(
                                      top: 140,
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: panelCtrl.isAttached &&
                                                  panelCtrl.isPanelOpen
                                              ? GestureDetector(
                                                  onTap: () {
                                                    panelCtrl.close();
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .arrow_circle_down_sharp,
                                                    size: 40,
                                                  ),
                                                )
                                              : panelCtrl.isAttached &&
                                                      panelCtrl.isPanelClosed
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        panelCtrl.open();
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .arrow_circle_up_sharp,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Container()),
                                    ),
                                    serviceOpenOrConfirmAbove(),
                                  ],
                                ),
                              ),
                            )
                          : (cubit.request.accepted ||
                                  cubit.request.arrived ||
                                  cubit.request.started)
                              ? SlidingUpPanel(
                                  controller: panelCtrl,
                                  renderPanelSheet: false,
                                  maxHeight: 450,
                                  minHeight: 200,
                                  defaultPanelState: PanelState.OPEN,
                                  panel: Container(
                                    margin: const EdgeInsets.only(
                                        right: 24.0, left: 24.0),
                                    child: Stack(
                                      children: [
                                        serviceAcceptedArrivedStarted(),
                                        Positioned(
                                          top: 140,
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: panelCtrl.isAttached &&
                                                      panelCtrl.isPanelOpen
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        panelCtrl.close();
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .arrow_circle_down_sharp,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : panelCtrl.isAttached &&
                                                          panelCtrl
                                                              .isPanelClosed
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            panelCtrl.open();
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .arrow_circle_up_sharp,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : Container()),
                                        ),
                                        serviceAcceptedArrivedStartedAbove(),
                                      ],
                                    ),
                                  ),
                                )
                              : ((cubit.request.done ||
                                          cubit.request.canceled) &&
                                      !cubit.request.paid)
                                  ? SlidingUpPanel(
                                      controller: panelCtrl,
                                      renderPanelSheet: false,
                                      maxHeight: 450,
                                      minHeight: 200,
                                      defaultPanelState: PanelState.OPEN,
                                      panel: Container(
                                        margin: const EdgeInsets.only(
                                            right: 24.0, left: 24.0),
                                        child: Stack(
                                          children: [
                                            serviceDoneCancelled(),
                                            Positioned(
                                              top: 140,
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: panelCtrl.isAttached &&
                                                          panelCtrl.isPanelOpen
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            panelCtrl.close();
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .arrow_circle_down_sharp,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : panelCtrl.isAttached &&
                                                              panelCtrl
                                                                  .isPanelClosed
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                panelCtrl
                                                                    .open();
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_circle_up_sharp,
                                                                size: 40,
                                                              ),
                                                            )
                                                          : Container()),
                                            ),
                                            cubit.request.done
                                                ? serviceDoneWidget()
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : (cubit.request.done &&
                                          cubit.request.paid &&
                                          !cubit.request.rated)
                                      ? Stack(
                                          children: [
                                            Positioned(
                                              bottom: 0,
                                              left: 24,
                                              right: 24,
                                              child: Stack(
                                                children: [
                                                  serviceDoneCancelled(),
                                                ],
                                              ),
                                            ),
                                            serviceClientRate(),
                                          ],
                                        )
                                      : (cubit.request.done &&
                                              cubit.request.paid &&
                                              cubit.request.rated)
                                          ? Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 0,
                                                  left: 24,
                                                  right: 24,
                                                  child: Stack(
                                                    children: [
                                                      serviceDoneCancelled(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : cubit.request.pending
                                              ? Stack(
                                                  children: [
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 24,
                                                      right: 24,
                                                      child: Stack(
                                                        children: [
                                                          servicePending(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
