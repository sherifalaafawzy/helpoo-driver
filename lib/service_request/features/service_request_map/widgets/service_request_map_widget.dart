import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpoo/dataLayer/Constants/variables.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/presitationLayer/widgets/round_button.dart';
import 'package:helpoo/service_request/core/di/injection.dart';
import 'package:helpoo/service_request/core/network/local/cache_helper.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/choose_vehicle_type_sheet.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/order_done_sheet.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/order_number_sheet.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/payment_way_sheet.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_bottom_sheet.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_button.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_search_field.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceRequestMapWidget extends StatefulWidget {
  const ServiceRequestMapWidget({Key? key}) : super(key: key);

  @override
  State<ServiceRequestMapWidget> createState() =>
      _ServiceRequestMapWidgetState();
}

class _ServiceRequestMapWidgetState extends State<ServiceRequestMapWidget> {
  @override
  void initState() {
    super.initState();

    debugPrint('ServiceRequestMapWidget initState');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
      listener: (context, state) {
        if (state is GetIFrameUrlSuccessState) {
          context.pushNamed = Routes.paymentWebView;
        }

        if (state is CreateNewRequestErrorState) {
          HelpooInAppNotification.showErrorMessage(
            message: state.error,
          );
        }

        ///* display dialog if Error happened
        if (state is GetDriverInfoErrorState) {
          Get.dialog(
            AlertDialog(
              title: Text(
                state.error,
                textAlign: TextAlign.start,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0,
                  ),
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: RoundButton(
                    onPressed: () async {
                      if (!await launchUrl(
                        Uri.parse('tel:17000'),
                      )) {
                        HelpooInAppNotification.showErrorMessage(
                            message: "Could not Make Call".tr);
                      }
                      Get.back();
                    },
                    padding: false,
                    text: 'Call 17000'.tr,
                    color: mainColorHex,
                  ),
                )
              ],
            ),
          );
          // HelpooInAppNotification.showErrorMessage(
          //   message: state.error,
          // );
        }

        ///* display dialog if Error happened
        if (state is AssignDriverErrorState) {
          Get.dialog(
            AlertDialog(
              title: Text(
                state.error,
                textAlign: TextAlign.start,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0,
                  ),
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: RoundButton(
                    onPressed: () async {
                      if (!await launchUrl(
                        Uri.parse('tel:17000'),
                      )) {
                        HelpooInAppNotification.showErrorMessage(
                            message: "Could not Make Call".tr);
                      }
                      Get.back();
                    },
                    padding: false,
                    text: 'Call 17000'.tr,
                    color: mainColorHex,
                  ),
                )
              ],
            ),
          );
          // HelpooInAppNotification.showErrorMessage(
          //   message: state.error,
          // );
        }

        if (state is CancelServiceRequestSuccessState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => homeScreen(
                index: 0,
              ),
            ),
            (Route<dynamic> route) => false,
          );
          // if (sRBloc.countOpenedBottomSheets > 0) {
          //   context.pop;
          // }

          HelpooInAppNotification.showSuccessMessage(
            message: 'Request Cancelled Successfully'.tr,
          );
        }

        // if (state is GetMapPlaceCoordinatesDetailsLoading ||
        //     state is SetMapControllerLoading ||
        //     state is GetConfigLoadingState) {
        //   showDialog(
        //       context: context,
        //       useSafeArea: true,
        //       barrierDismissible: false,
        //       useRootNavigator: true,
        //       barrierColor: Colors.transparent,
        //       builder: (context) {
        //         return Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Container(
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(10)),
        //                   padding: const EdgeInsets.all(20),
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       SizedBox(
        //                         width: 100,
        //                         child: LinearProgressIndicator(
        //                           color: Theme.of(context).primaryColor,
        //                         ),
        //                       ),
        //                       space5Vertical(),
        //                       Text(
        //                         "Draw Path Loading".tr,
        //                         style: GoogleFonts.tajawal(
        //                           textStyle: TextStyle(
        //                             fontWeight: FontWeight.w700,
        //                             color: Theme.of(context).primaryColor,
        //                             fontStyle: FontStyle.normal,
        //                             fontSize: 16,
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         );

        //       });
        // }

        // if (state is GetDriverPathToDrawSuccess) {
        //   context.pop;
        // }

        if (state is GetCurrentServiceRequestStatusState) {
          // TODo Flag
          sRBloc.countOpenedBottomSheets += 1;

          printWarning(
              'GetCurrentSR BottomSheet Count :: ${sRBloc.countOpenedBottomSheets}');

          if (state.serviceRequestStatus == ServiceRequestStatusEnum.done) {
            debugPrint('Render OrderDoneSheet');
            // sl<CacheHelper>().clear('CURRENT_REQUEST_ID');
            primaryBottomSheet(
              context: context,
              child: OrderDoneSheet(),
            );
          } else if (state.serviceRequestStatus !=
                  ServiceRequestStatusEnum.canceled &&
              state.serviceRequestStatus != ServiceRequestStatusEnum.pending &&
              state.serviceRequestStatus !=
                  ServiceRequestStatusEnum.not_available &&
              state.serviceRequestStatus !=
                  ServiceRequestStatusEnum.cancelWithPayment) {
            debugPrint(
                'state.serviceRequestStatus: ${state.serviceRequestStatus}');
            printWarning('Render Primary BottomSheet');

            primaryBottomSheet(
              context: context,
              isTopIcon: false,
              minutes: '${sRBloc.driverPolylineResult?.durationInSec ?? ''}',
              price:
                  '${sRBloc.serviceRequestModel?.serviceRequestDetails.fees ?? ''}',
              isWaitingDriverToAccept: state.serviceRequestStatus ==
                  ServiceRequestStatusEnum.confirmed,
              child: OrderNumberBottomSheet(
                isOrderAccepted: state.serviceRequestStatus ==
                    ServiceRequestStatusEnum.confirmed,
              ),
            );
          } else if (state.serviceRequestStatus ==
                  ServiceRequestStatusEnum.pending ||
              state.serviceRequestStatus ==
                  ServiceRequestStatusEnum.not_available) {
            primaryBottomSheet(
              context: context,
              isTopIcon: true,
              child: PrimaryPadding(
                child: Column(
                  children: [
                    Text(
                      'pending request'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      '${'request is pending'.tr}${sRBloc.serviceRequestModel!.serviceRequestDetails.id}'
                          .tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Call Support'.tr,
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse('tel:17000'))) {
                          throw 'Could not launch url'.tr;
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state.serviceRequestStatus ==
                  ServiceRequestStatusEnum.canceled ||
              state.serviceRequestStatus ==
                  ServiceRequestStatusEnum.cancelWithPayment) {
            sl<CacheHelper>().clear('CURRENT_REQUEST_ID');

            sRBloc.closeAllBottomSheets();
            // sRBloc.isClearOnStartLoading = true;
            sRBloc.clearOnStart(
              isFirst: false,
            );

            sRBloc.setMyLocation();
          }
        }

        if (state is ShowPaymentBottomSheetState) {
          sRBloc.countOpenedBottomSheets += 1;
          printWarning(
              '==>>> showPaymentBottomSheetState ${sRBloc.countOpenedBottomSheets}');

          primaryBottomSheet(
            context: context,
            child: PaymentWayBottomSheet(),
          );
        }

        // if (state is TowingSelectedActionState) {
        if (sRBloc.isTowingSelected) {
          printWarning('Towing Selected Action State : getDriverInfo');
          sRBloc.getDriverInfo();
          sRBloc.isTowingSelected = false;

          // sRBloc.countOpenedBottomSheets += 1;
          //
          // primaryBottomSheet(
          //   context: context,
          //   isTopIcon: false,
          //   minutes: sRBloc.polylineResult!.durationInSec.toString(),
          //   price: sRBloc.selectedFees.toString(),
          //   child: OrderNumberBottomSheet(),
          // );
        }

        if (state is CreateNewRequestSuccessState) {
          sRBloc.countOpenedBottomSheets += 1;

          primaryBottomSheet(
            context: context,
            isTopIcon: false,
            minutes: sRBloc.driverPolylineResult!.durationInSec.toString(),
            price: sRBloc.serviceRequestModel!.serviceRequestDetails.fees
                .toString(),
            isWaitingDriverToAccept: false,
            child: OrderNumberBottomSheet(
              isOrderAccepted: false,
            ),
          );

          // sRBloc.toggleServiceOrdered(
          //   isOrdered: false,
          // );
        }

        if (state is CalculateServiceFeesSuccessState) {
          sRBloc.countOpenedBottomSheets += 1;
          sRBloc.isTowingSelectingLoading = false;

          primaryBottomSheet(
            context: context,
            child: ChooseVehicleTypeBottomSheet(),
          );

          // showBottomSheet(
          //   context: context,
          //   enableDrag: true,
          //   constraints: BoxConstraints(
          //     maxHeight: 200,
          //     minHeight: 200,
          //   ),
          //   builder: (context) => Container(
          //     height: 400,
          //     color: Colors.white,
          //     width: double.infinity,
          //     child: Column(
          //       children: [
          //         Text('Select Service Type'),
          //       ],
          //     ),
          //   ),
          // );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            GoogleMap(
              polylines: Set<Polyline>.of(sRBloc.polyLines.values),
              mapType: MapType.normal,
              markers: Set<Marker>.from(
                sRBloc.markers,
              ),
              // circles: Set<Circle>.from(
              //   AppBloc.get(context).circles,
              // ),
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: sRBloc.initialCameraPosition,
                zoom: 14.4746,
              ),
              // initialCameraPosition: widget.isUpdate
              //     ? CameraPosition(
              //         target: LatLng(
              //           double.parse(AppBloc.get(context)
              //               .selectAddressModel
              //               .latitude),
              //           double.parse(AppBloc.get(context)
              //               .selectAddressModel
              //               .longitude),
              //         ),
              //         zoom: 14.4746,
              //       )
              //     : CameraPosition(
              //         target: LatLng(
              //             AppBloc.get(context).myLatLong!.latitude!,
              //             AppBloc.get(context).myLatLong!.longitude!),
              //         zoom: 14.4746,
              //       ),
              // padding: EdgeInsets.all(24.0,),
              onLongPress: (value) {
                FocusScope.of(context).requestFocus(FocusNode());

                // AppBloc.get(context).addMarkerOnCameraMove(
                //   position: value,
                //   context: context,
                // );
                //
                // AppBloc.get(context).mapController!.animateCamera(
                //   CameraUpdate.newCameraPosition(
                //     CameraPosition(
                //       target:
                //       LatLng(value.latitude, value.longitude),
                //       zoom: 14.4746,
                //     ),
                //   ),
                // );
              },
              onCameraIdle: () {
                debugPrint('onCameraIdle');

                if (sRBloc.polyLines.isNotEmpty) {
                  return;
                }

                sRBloc.isFromSearch = false;

                if (!sRBloc.isCameraIdle && !sRBloc.isFromSearch) {
                  sRBloc.setLocationFromCameraMoving();
                }

                sRBloc.isCameraIdle = true;

                // sRBloc.setLocationFromCameraMoving();

                // sRBloc.mapPlaceDetailsCoordinatesModel = null;
                //
                // if(sRBloc.mapPlaceDetailsCoordinatesModel == null) {
                //   sRBloc.setLocationFromCameraMoving();
                // }

                // if(sRBloc.isOrigin) {
                //   if(sRBloc.originController.text.isEmpty) {
                //     sRBloc.setLocationFromCameraMoving();
                //   }
                // } else {
                //   if(sRBloc.destinationController.text.isEmpty) {
                //     sRBloc.setLocationFromCameraMoving();
                //   }
                // }
              },
              onCameraMove: (value) {
                debugPrint('onCameraMove');

                sRBloc.isCameraIdle = false;

                FocusScope.of(context).requestFocus(FocusNode());

                if (sRBloc.polyLines.isNotEmpty) {
                  return;
                }

                if (sRBloc.isFromSearch) {
                  return;
                }

                if (sRBloc.isOrigin) {
                  sRBloc.originController.clear();
                } else {
                  sRBloc.destinationController.clear();
                }

                sRBloc.cameraMovementPosition = value.target;

                sRBloc.addSvgMarker(
                  id: 'myLocation',
                  latitude: value.target.latitude,
                  longitude: value.target.longitude,
                );

                // if(sRBloc.polyLines.isNotEmpty) {
                //   return;
                // }
                //
                // sRBloc.cameraMovementPosition = value.target;

                // sRBloc.setLocationFromCameraMoving(
                //   context: context,
                //   position: value.target,
                // );

                // sRBloc.addMarkerOnCameraMove(
                //   position: value.target,
                //   context: context,
                // );
              },
              onTap: (value) {
                FocusScope.of(context).requestFocus(FocusNode());

                if (sRBloc.polyLines.isNotEmpty) {
                  return;
                }

                if (sRBloc.isOrigin) {
                  sRBloc.originController.clear();
                } else {
                  sRBloc.destinationController.clear();
                }

                sRBloc.cameraMovementPosition = value;
                sRBloc.setLocationFromCameraMoving();

                // AppBloc.get(context).addMarkerOnCameraMove(
                //   position: value,
                //   context: context,
                // );
                //
                // AppBloc.get(context).mapController!.animateCamera(
                //   CameraUpdate.newCameraPosition(
                //     CameraPosition(
                //       target:
                //       LatLng(value.latitude, value.longitude),
                //       zoom: 14.4746,
                //     ),
                //   ),
                // );
              },
              onMapCreated: (GoogleMapController controller) {
                sRBloc.setMapController(
                  controller: controller,
                );
              },
            ),
            if (!sRBloc.isSlidingUpPanelShow)
              if (sRBloc.serviceRequestModel == null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PrimaryPadding(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Submit'.tr,
                              isLoading: sRBloc.isGettingPathLoading,
                              onPressed: () {
                                if (sRBloc.originLatLng == null) {
                                  debugPrint('Choose origin and destination');
                                  debugPrint(sRBloc.originLatLng.toString());
                                  debugPrint(
                                      sRBloc.destinationLatLng.toString());

                                  HelpooInAppNotification.showSuccessMessage(
                                    message: 'Please choose origin'.tr,
                                  );

                                  return;
                                }

                                if (sRBloc.destinationLatLng == null) {
                                  debugPrint('Choose origin and destination');
                                  debugPrint(sRBloc.originLatLng.toString());
                                  debugPrint(
                                      sRBloc.destinationLatLng.toString());

                                  HelpooInAppNotification.showSuccessMessage(
                                    message: 'Please choose destination'.tr,
                                  );

                                  return;
                                }

                                // if ((sRBloc.originLatLng!.latitude < 22.0 ||
                                //         sRBloc.originLatLng!.latitude > 31.5 ||
                                //         sRBloc.originLatLng!.longitude < 31.0 ||
                                //         sRBloc.originLatLng!.longitude >
                                //             34.0) ||
                                //     (sRBloc.destinationLatLng!.latitude <
                                //             22.0 ||
                                //         sRBloc.destinationLatLng!.latitude >
                                //             31.5 ||
                                //         sRBloc.destinationLatLng!.longitude <
                                //             31.0 ||
                                //         sRBloc.destinationLatLng!.longitude >
                                //             34.0)) {
                                //   HelpooInAppNotification.showErrorMessage(
                                //     message:
                                //         'Current location is outside of Egypt'
                                //             .tr,
                                //   );
                                //   debugPrint(
                                //       ">>>>>>>>>>> Current location is outside of Egypt");
                                // } else {
                                debugPrint(
                                    ">>>>>>>>>>> Current location is inside Egypt");
                                sRBloc.isGettingPathLoading = true;
                                sRBloc.getMainTripPath(
                                  isDraw: false,
                                );
                                debugPrint('Submit');
                                debugPrint(
                                    sRBloc.originLatLng!.latitude.toString());
                                debugPrint(
                                    sRBloc.originLatLng!.longitude.toString());
                                debugPrint(sRBloc.destinationLatLng!.latitude
                                    .toString());
                                debugPrint(sRBloc.destinationLatLng!.longitude
                                    .toString());
                                // }
                              },
                            ),
                          ),
                          if (sRBloc.polyLines.isEmpty) space10Horizontal(),
                          if (sRBloc.polyLines.isEmpty)
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (sRBloc.isOrigin) {
                                  sRBloc.originController.clear();
                                } else {
                                  sRBloc.destinationController.clear();
                                }

                                sRBloc.setMyLocation();
                              },
                            ),
                          if (sRBloc.polyLines.isNotEmpty) space10Horizontal(),
                          if (sRBloc.polyLines.isNotEmpty)
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.expand_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                sRBloc.expandCameraToDisplayAllRoute();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            PrimaryPadding(
              child: Column(
                children: [
                  PrimarySearchField(
                    isOrigin: true,
                    controller: sRBloc.originController,
                    title: 'current location'.tr,
                    hint: 'current location'.tr,
                    onTap: () {
                      sRBloc.isOrigin = true;
                    },
                    onChanged: (value) {
                      if (value.length > 3) {
                        sRBloc.isOrigin = true;

                        sRBloc.searchMapPlace(
                          input: value,
                        );
                      }
                    },
                  ),
                  if (sRBloc.isOrigin &&
                      sRBloc.mapPlaceDetailsCoordinatesModel == null &&
                      sRBloc.serviceRequestModel == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: LinearProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  space15Vertical(),
                  PrimarySearchField(
                    isOrigin: false,
                    controller: sRBloc.destinationController,
                    title: 'towing destination'.tr,
                    hint: 'towing destination'.tr,
                    onTap: () {
                      sRBloc.isOrigin = false;
                    },
                    onChanged: (value) {
                      if (value.length > 3) {
                        sRBloc.isOrigin = false;

                        sRBloc.searchMapPlace(
                          input: value,
                        );
                      }
                    },
                  ),
                  if (!sRBloc.isOrigin &&
                      sRBloc.mapPlaceDetailsCoordinatesModel == null &&
                      sRBloc.serviceRequestModel == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: LinearProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  if (sRBloc.mapPlaceModel != null) ...[
                    space20Vertical(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...sRBloc.mapPlaceModel!.predictions
                                  .asMap()
                                  .map(
                                    (key, value) => MapEntry(
                                      key,
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              sRBloc.isFromSearch = true;
                                              // close the keyboard
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              debugPrint(value.mainText);
                                              if (sRBloc.isOrigin) {
                                                sRBloc.originName =
                                                    value.mainText;
                                              } else {
                                                sRBloc.destinationName =
                                                    value.mainText;
                                              }

                                              sRBloc.getMapPlaceDetails(
                                                value: value,
                                              );
                                            },
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      value.mainText,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall!
                                                          .copyWith(
                                                            fontSize: 16.0,
                                                            color:
                                                                secondaryGrey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                    ),
                                                    Text(
                                                      value.secondaryText,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall!
                                                          .copyWith(
                                                            fontSize: 12.0,
                                                            color:
                                                                secondaryGrey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (key !=
                                              sRBloc.mapPlaceModel!.predictions
                                                      .length -
                                                  1)
                                            const MyDivider(),
                                        ],
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (sRBloc.isSlidingUpPanelShow)
              SlidingUpPanel(
                minHeight: 60,
                maxHeight: !sRBloc.serviceRequestModel!.serviceRequestDetails
                        .isWaitingTimeApplied!
                    ? sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.arrived.name ||
                            sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.started.name ||
                            sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.done.name ||
                            sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.destArrived.name
                        ? 294
                        : 360
                    : sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.arrived.name ||
                            sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.started.name ||
                            sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.done.name ||
                            sRBloc.serviceRequestModel!.serviceRequestDetails
                                    .status ==
                                ServiceRequestStatusEnum.destArrived.name
                        ? 344
                        : 410,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.transparent,
                boxShadow: const [],
                onPanelClosed: () {
                  sRBloc.toggleSlidingUpPanel(isCollapsed: true);
                },
                onPanelSlide: (double pos) {
                  // debugPrint('onPanelSlide: $pos');
                  if (pos > 0 && sRBloc.isSlidingUpPanelCollapsed) {
                    sRBloc.toggleSlidingUpPanel(isCollapsed: false);
                  }
                  // sRBloc.toggleSlidingUpPanel(isCollapsed: false);
                },
                defaultPanelState: PanelState.OPEN,
                onPanelOpened: () {
                  debugPrint('onPanelOpened');

                  sRBloc.toggleSlidingUpPanel(isCollapsed: false);
                },
                panel: OrderNumberBottomSheet(
                  isOrderAccepted: true,
                  isSlidingUpPanel: true,
                  isShowDriverData: true,
                  isServiceInProgress: sRBloc.serviceRequestModel!
                              .serviceRequestDetails.status ==
                          ServiceRequestStatusEnum.arrived.name ||
                      sRBloc.serviceRequestModel!.serviceRequestDetails
                              .status ==
                          ServiceRequestStatusEnum.started.name ||
                      sRBloc.serviceRequestModel!.serviceRequestDetails
                              .status ==
                          ServiceRequestStatusEnum.done.name ||
                      sRBloc.serviceRequestModel!.serviceRequestDetails
                              .status ==
                          ServiceRequestStatusEnum.destArrived.name,
                  isCollapsed: sRBloc.isSlidingUpPanelCollapsed,
                ),
              ),
            if (state is CancelServiceRequestLoadingState)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              // space5Vertical(),
                              // Text(
                              //   "Draw Path Loading".tr,
                              //   style: GoogleFonts.tajawal(
                              //     textStyle: TextStyle(
                              //       fontWeight: FontWeight.w700,
                              //       color: Theme.of(context).primaryColor,
                              //       fontStyle: FontStyle.normal,
                              //       fontSize: 16,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
