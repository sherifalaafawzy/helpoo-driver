import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpoo/dataLayer/models/accident_report_details_model.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/dataLayer/models/vehicle.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/models/create_service_dto.dart';
import 'package:helpoo/service_request/core/models/drivers/driver_model.dart';
import 'package:helpoo/service_request/core/models/get_config.dart';
import 'package:helpoo/service_request/core/models/maps/map_place_details__coordinates_model.dart';
import 'package:helpoo/service_request/core/models/maps/map_place_details_model.dart';
import 'package:helpoo/service_request/core/models/maps/map_place_model.dart';
import 'package:helpoo/service_request/core/models/service_request/calculate_fees.dart';
import 'package:helpoo/service_request/core/models/service_request/check_service_request_model.dart';
import 'package:helpoo/service_request/core/models/service_request/get_types.dart';
import 'package:helpoo/service_request/core/models/service_request/service_request_model.dart';
import 'package:helpoo/service_request/core/models/service_request/voucher_model.dart';
import 'package:helpoo/service_request/core/network/remote/api_endpoints.dart';
import 'package:helpoo/service_request/core/network/repository.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/flutter_polyline_points.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/src/PointLatLng.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/src/utils/polyline_result.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/src/utils/request_enums.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'dart:ui' as ui;

import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../dataLayer/models/FCM.dart';

NewServiceRequestBloc get sRBloc => NewServiceRequestBloc.get(navigatorKey.currentContext!);

class NewServiceRequestBloc extends Cubit<NewServiceRequestState> {
  final Repository _repository;

  NewServiceRequestBloc({
    required Repository repository,
  })  : _repository = repository,
        super(Empty());

  static NewServiceRequestBloc get(context) => BlocProvider.of(context);

  // late TranslationModel translationModel;

  bool isRtl = false;

  late ThemeData lightTheme;

  late String family;

  String _billingAddress = '';

  String get billingAddress => _billingAddress;

  set billingAddress(String value) {
    _billingAddress = value;
    emit(BillingAddressChanged());
  }

  // void setThemes({
  //   required bool rtl,
  // }) {
  //   isRtl = rtl;
  //
  //   changeTheme();
  //
  //   emit(ThemeLoaded());
  // }
  //
  // void changeTheme() {
  //   family = isRtl ? 'Somar' : 'Sofia';
  //
  //   lightTheme = ThemeData(
  //     scaffoldBackgroundColor: Colors.white,
  //     appBarTheme: AppBarTheme(
  //       systemOverlayStyle: const SystemUiOverlayStyle(
  //         statusBarColor: whiteColor,
  //         statusBarIconBrightness: Brightness.dark,
  //       ),
  //       backgroundColor: whiteColor,
  //       elevation: 0.0,
  //       titleSpacing: 0.0,
  //       iconTheme: const IconThemeData(
  //         color: Colors.black,
  //         size: 20.0,
  //       ),
  //       titleTextStyle: TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.bold,
  //         fontFamily: family,
  //       ),
  //     ),
  //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //       backgroundColor: whiteColor,
  //       elevation: 50.0,
  //       selectedItemColor: HexColor(mainColor),
  //       unselectedItemColor: Colors.grey[400],
  //       type: BottomNavigationBarType.fixed,
  //       selectedLabelStyle: const TextStyle(
  //         height: 1.5,
  //       ),
  //     ),
  //     primarySwatch: MaterialColor(int.parse('0xff$mainColor'), color),
  //     textTheme: TextTheme(
  //       titleLarge: TextStyle(
  //         fontSize: 21.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w600,
  //         color: secondary,
  //         height: 1.4,
  //       ),
  //       titleMedium: TextStyle(
  //         fontSize: 17.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w600,
  //         color: secondary,
  //         height: 1.4,
  //       ),
  //       titleSmall: TextStyle(
  //         fontSize: 15.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w400,
  //         color: secondaryVariant,
  //         height: 1.4,
  //       ),
  //       labelLarge: TextStyle(
  //         fontSize: 16.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w600,
  //         color: Colors.white,
  //         height: 1.4,
  //       ),
  //       displaySmall: TextStyle(
  //         fontSize: 12.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w400,
  //         color: secondaryGrey,
  //         height: 1.4,
  //       ),
  //       displayMedium: TextStyle(
  //         fontSize: 14.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w400,
  //         color: secondaryVariant,
  //         height: 1.4,
  //       ),
  //       displayLarge: TextStyle(
  //         fontSize: 16.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w400,
  //         color: secondary,
  //         height: 1.4,
  //       ),
  //       bodySmall: TextStyle(
  //         fontSize: 13.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w600,
  //         color: secondary,
  //         height: 1.4,
  //       ),
  //       bodyMedium: TextStyle(
  //         fontSize: 14.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w500,
  //         color: secondaryGrey,
  //         height: 1.4,
  //       ),
  //       bodyLarge: TextStyle(
  //         fontSize: 19.0,
  //         fontFamily: family,
  //         fontWeight: FontWeight.w600,
  //         color: secondary,
  //         height: 1.4,
  //       ),
  //     ),
  //   );
  // }
  //
  // void setTranslation({
  //   required String translation,
  // }) {
  //   translationModel = TranslationModel.fromJson(
  //     json.decode(
  //       translation,
  //     ),
  //   );
  //
  //   emit(LanguageLoaded());
  // }
  //
  // void changeLanguage({
  //   required String code,
  // }) async {
  //   debugPrint(code);
  //
  //   if (code == 'ar') {
  //     isRtl = true;
  //   } else {
  //     isRtl = false;
  //   }
  //
  //   sl<CacheHelper>().put('isRtl', isRtl);
  //
  //   isEnglish = !isRtl;
  //
  //   String translation = await rootBundle
  //       .loadString('assets/translations/${isRtl ? 'ar' : 'en'}.json');
  //
  //   changeTheme();
  //
  //   setTranslation(
  //     translation: translation,
  //   );
  //
  //   emit(ChangeLanguage());
  // }

  //**********************************************************
  // GetConfig
  Config? config;

  bool isGetConfigLoading = false;

  Future<void> getConfig() async {
    isGetConfigLoading = true;

    emit(GetConfigLoadingState());
    final results = await _repository.getConfig();
    results.fold(
      (error) {
        isGetConfigLoading = false;

        debugPrint('-----error------');
        debugPrint(error.toString());
        emit(
          GetConfigErrorState(
            error: error,
          ),
        );
      },
      (data) {
        debugPrint('----- Config Data ------');
        debugPrintFullText(data.toJson().toString());
        config = data.config![0];
        isGetConfigLoading = false;
        emit(GetConfigSuccessState());
      },
    );
  }

  //**********************************************************
  int _countOpenedBottomSheets = 0;

  int get countOpenedBottomSheets => _countOpenedBottomSheets;

  set countOpenedBottomSheets(int value) {
    _countOpenedBottomSheets = value;
    printWarning('Count Bottom Sheets = $value');
    emit(CountOpenedBottomSheets());
  }

  GetServiceReqTypes? getServiceReqTypes;

  ServiceRequestsType? normalTowing;
  ServiceRequestsType? euroTowing;

  void getServiceRequestTypes() async {
    emit(GetServiceRequestTypesLoadingState());

    final result = await _repository.getServiceReqTypes();
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());

        emit(
          GetServiceRequestTypesErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        getServiceReqTypes = data;
        printWarning('-----getServiceReqTypes ${getServiceReqTypes!.toJson()}');

        isGettingPathLoading = false;

        euroTowing = getServiceReqTypes!.serviceRequestsTypes!.firstWhere((element) => element.id == 5);
        normalTowing = getServiceReqTypes!.serviceRequestsTypes!.firstWhere((element) => element.id == 4);

        // getServiceReqTypes!.serviceRequestsTypes!.forEach((element) {
        //   if(element.id == 1 || element.id == 2) {
        //     debugPrint('-----element------');
        //     debugPrint(element.arName);
        //     debugPrint(element.enName);
        //   }
        // });

        emit(GetServiceRequestTypesSuccessState());
      },
    );
  }

  //******************************************************************************

  CalculateFeesModel? calculateFeesModel;

  void calculateServiceFees() async {
    emit(CalculateServiceFeesLoadingState());

    final result = await _repository.calculateServiceFees(
      userId: userId,
      carId: selectedCarId,
      destinationDistance: json.encode({
        'distance': {
          'value': (mainTripPolylineResult!.distanceInKm * 1000).toString(),
        }
      }),
      distance: "",
    );
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());

        emit(
          CalculateServiceFeesErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        calculateFeesModel = data;
        printWarning('-----calculateFeesModel ${calculateFeesModel!.toJson()}');
        isGettingPathLoading = false;

        emit(CalculateServiceFeesSuccessState());
      },
    );
  }

//convert (2 hours 15 mins) or (1 min) To mins only
  int convertTimeToMins({required String time}) {
    int hours = 0;
    int mins = 0;
    if (time.contains('hours')) {
      hours = int.parse(time.split(' ')[0]);
      mins = int.parse(time.split(' ')[2]);
    } else if (time.contains('hour')) {
      hours = int.parse(time.split(' ')[0]);
    } else if (time.contains('mins')) {
      mins = int.parse(time.split(' ')[0]);
    } else if (time.contains('min')) {
      mins = int.parse(time.split(' ')[0]);
    }
    return (hours * 60) + mins;
  }

  DriverModel? driverModel;

  void getDriverInfo() async {
    emit(GetDriverInfoLoadingState());

    final result = await _repository.getDriverDetails(
      carServiceTypeId: json.encode([isNormalTowingSelected ? normalTowing!.carType : euroTowing!.carType]),
      location: json.encode({
        'clientLatitude': originLatLng!.latitude,
        'clientLongitude': originLatLng!.longitude,
      }),
    );
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isTowingSelectingLoading = false;

        emit(
          GetDriverInfoErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        driverModel = data;

        emit(GetDriverInfoSuccessState());

        getDriverPath(
          from: LatLng(driverModel!.driver.latitude.toDouble(), driverModel!.driver.longitude.toDouble()),
          to: originLatLng!,
          heading: double.parse(driverModel!.driver.heading),
        );
      },
    );
  }

  int _corporateClientId = 0;

  int get corporateClientId => _corporateClientId;

  set corporateClientId(int value) {
    _corporateClientId = value;
    emit(SetCorporateClientId());
  }

  ServiceRequestModel? serviceRequestModel;

  bool isCreateNewRequestLoading = false;

  void createNewRequest() async {
    isCreateNewRequestLoading = true;

    emit(CreateNewRequestLoadingState());

    debugPrint('-----selectedCarId------');
    debugPrint(selectedCarId.toString());
    debugPrint('-----clientId------');
    debugPrint(currentId.toString());
    debugPrint('-----corporateId------');
    debugPrint('');
    debugPrint('-----createdByUser------');
    debugPrint(userId.toString());
    debugPrint('-----driverId------');
    debugPrint(driverModel!.driver.id.toString());
    debugPrint('-----carServiceTypeId------');
    debugPrint(
        json.encode([isNormalTowingSelected ? normalTowing!.carType.toString() : euroTowing!.carType.toString()]));
    debugPrint('-----distance------');
    debugPrint(json.encode({
      "distance": {
        "value": driverPolylineResult!.distanceInKm * 1000,
        "text": driverPolylineResult!.distance,
      }
    })); // between driver and client
    debugPrint('-----destinationDistance------');
    debugPrint(
      json.encode(
        {
          "distance": {
            "value": mainTripPolylineResult!.distanceInKm * 1000,
          }
        },
      ),
    ); // between client and destination
    debugPrint('-----destinationAddress------');
    debugPrint(destinationAddress);
    debugPrint('-----clientAddress------');
    debugPrint(originAddress);
    debugPrint('-----clientLatitude------');
    debugPrint(originLatLng!.latitude.toString());
    debugPrint('-----clientLongitude------');
    debugPrint(originLatLng!.longitude.toString());
    debugPrint('-----destinationLat------');
    debugPrint(destinationLatLng!.latitude.toString());
    debugPrint('-----destinationLng------');
    debugPrint(destinationLatLng!.longitude.toString());

    final result = await _repository.createNewServiceRequest(
      createServiceDto: CreateServiceDto(
        carId: selectedCarId.toString(),
        clientId: CurrentUser.isCorporate ? corporateClientId.toString() : currentId.toString(),
        corporateId: CurrentUser.isCorporate ? currentId.toString() : '',
        createdByUser: CurrentUser.isCorporate ? currentId.toString() : userId.toString(),
        driverId: driverModel!.driver.id.toString(),
        carServiceTypeId:
            json.encode([isNormalTowingSelected ? normalTowing!.carType.toString() : euroTowing!.carType.toString()]),
        distance: json.encode({
          "distance": {
            "value": driverPolylineResult!.distanceInKm * 1000,
            "text": driverPolylineResult!.distance,
          }
        }),
        destinationDistance: json.encode({
          "distance": {
            "value": mainTripPolylineResult!.distanceInKm * 1000,
          }
        }),
        destinationAddress: destinationAddress,
        clientAddress: originAddress,
        clientLatitude: originLatLng!.latitude.toString(),
        clientLongitude: originLatLng!.longitude.toString(),
        destinationLat: destinationLatLng!.latitude.toString(),
        destinationLng: destinationLatLng!.longitude.toString(),
      ),
    );

    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isCreateNewRequestLoading = false;

        isTowingSelectingLoading = false;

        emit(
          CreateNewRequestErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        serviceRequestModel = data;

        isCreateNewRequestLoading = false;
        isTowingSelectingLoading = false;

        // if (!CurrentUser.isCorporate) {
        //   sl<CacheHelper>().put('CURRENT_REQUEST_ID',
        //       serviceRequestModel!.serviceRequestDetails.id);
        //
        //   CURRENT_REQUEST_ID = serviceRequestModel!.serviceRequestDetails.id;
        // } else {
        //   CORPORATE_REQUEST_ID = serviceRequestModel!.serviceRequestDetails.id;
        // }

        printWarning('${serviceRequestModel!.toJson()}');
        emit(CreateNewRequestSuccessState());
      },
    );
  }

  Timer? _timer;

  Timer? get timer => _timer;

  void startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) {
        if (serviceRequestModel != null) {
          getCurrentActiveServiceRequest(
            reqID: serviceRequestModel!.serviceRequestDetails.id,
          );
        } else {
          _timer!.cancel();
        }
      },
    );
  }

  CheckServiceRequestModel? checkServiceRequestModel;

  void checkServiceRequest() async {
    emit(CheckServiceRequestLoadingState());

    final result = await _repository.checkServiceRequest(
      userId: CurrentUser.id!,
      // serviceRequestId: (CurrentUser.isCorporate && _corporateRequestId != null)
      //     ? CORPORATE_REQUEST_ID
      //     : CURRENT_REQUEST_ID,
    );

    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());

        emit(
          CheckServiceRequestErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        debugPrint('-----data------');
        checkServiceRequestModel = data;

        debugPrint('-----data------ ${checkServiceRequestModel?.status}');
        debugPrint('-----data------ ${checkServiceRequestModel?.serviceRequestDetails?.toJson()}');

        if (checkServiceRequestModel!.serviceRequestDetails != null) {
          debugPrint('-->> checkSR Status ${checkServiceRequestModel!.status}');
          debugPrintFullText('-->> checkSR Details ${checkServiceRequestModel!.serviceRequestDetails!.toJson()}');

          if (checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.accepted.name &&
              checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.arrived.name &&
              checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.confirmed.name &&
              checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.started.name &&
              checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.destArrived.name &&
              checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.pending.name &&
              checkServiceRequestModel!.serviceRequestDetails!.status != ServiceRequestStatusEnum.not_available.name) {
            //then it's done
            debugPrint('-----done------');
            checkServiceRequestModel = null;
          } else {
            serviceRequestModel = ServiceRequestModel(
              status: checkServiceRequestModel!.status,
              serviceRequestDetails: checkServiceRequestModel!.serviceRequestDetails!,
            );
          }
        } else {
          serviceRequestModel = null;
          closeAllBottomSheets();

          clearOnStart(
            isFirst: false,
          );
        }
        // isClearOnStartLoading = false;
        //
        // isClearOnStartLoadingFromTopButton = false;
        debugPrint('-----66------');
        emit(
          CheckServiceRequestSuccessState(
            isRequestActive: checkServiceRequestModel?.serviceRequestDetails != null,
          ),
        );
      },
    );
  }

//***************************************************************************************
//isPrimaryBottomSheetOpened

  // bool _isPrimaryBottomSheetOpened = false;
  //
  // bool get isPrimaryBottomSheetOpened => _isPrimaryBottomSheetOpened;
  //
  // set isPrimaryBottomSheetOpened(bool value) {
  //   _isPrimaryBottomSheetOpened = value;
  //   emit(PrimaryBottomSheetOpenedState());
  // }

  void handleCurrentRequestUi({bool isFirstTime = false}) {
    debugPrint('----->>> countOpenedBottomSheets 1 ${countOpenedBottomSheets} ------');

    if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.open.name ||
        serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.done.name) {
      if (timer != null) {
        timer!.cancel();
      }
    } else {
      if (timer != null) {
        if (!timer!.isActive) {
          debugPrint('-----timer is not active ------');
          startTimer();
        }
      } else {
        debugPrint('-----timer is null ------');
        startTimer();
      }
    }

    if (timer != null) {
      debugPrint('-----timer is running ------');
    }

    originLatLng = LatLng(
      serviceRequestModel!.serviceRequestDetails.locationRequestDetailsModel!.clientLatitude.toDouble(),
      serviceRequestModel!.serviceRequestDetails.locationRequestDetailsModel!.clientLongitude.toDouble(),
    );

    destinationLatLng = LatLng(
      serviceRequestModel!.serviceRequestDetails.locationRequestDetailsModel!.destinationLatitude.toDouble(),
      serviceRequestModel!.serviceRequestDetails.locationRequestDetailsModel!.destinationLongitude.toDouble(),
    );

    originController.text = serviceRequestModel!.serviceRequestDetails.locationRequestDetailsModel!.clientAddress;
    destinationController.text =
        serviceRequestModel!.serviceRequestDetails.locationRequestDetailsModel!.destinationAddress;

    if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.confirmed.name ||
        serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.accepted.name ||
        serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.arrived.name ||
        serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.started.name ||
        serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.destArrived.name) {
      debugPrint('status is ==>> (confirmed || accepted || arrived || started)');
      if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.arrived.name ||
          serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.started.name ||
          serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.destArrived.name) {
        debugPrint('status is ==>> (arrived || started) ONLY');
        debugPrint(serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.heading);

        getDriverPath(
          heading: double.parse(serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.heading),
          from: LatLng(serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.latitude.toDouble(),
              serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.longitude.toDouble()),
          to: destinationLatLng!,
          withCreateNewRequest: false,
          isLastTripPath: true,
        );
        // isSlidingUpPanelShow = false;
      } else {
        debugPrint('status is ==>> (confirmed || accepted) ONLY');
        // isSlidingUpPanelShow = false;
        //TODO Review This **
        if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.confirmed.name &&
            isFirstTime) {
          debugPrint('***** Confirmed && isFirstTime *****');
          countOpenedBottomSheets = 0;
        }
        debugPrint(serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.heading);
        getDriverPath(
          heading: double.parse(serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.heading),
          from: LatLng(serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.latitude.toDouble(),
              serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.longitude.toDouble()),
          to: originLatLng!,
          withCreateNewRequest: false,
        );
      }

      debugPrint(
          'isRefreshFixedBottomSheet : ${serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.confirmed.name}');
      getMainTripPath(
        isFromCurrentRequest: true,
        isRefreshFixedBottomSheet:
            serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.confirmed.name,
      );
    } else {
      debugPrint('status is Not ==>> (confirmed || accepted || arrived || started)');
      markers.clear();
      polyLines.clear();
      isSlidingUpPanelShow = false;
      getCurrentServiceRequestStatus();
      // getPathToDraw(
      //   isFromCurrentRequest: true,
      // );
    }
    debugPrint('----->>> countOpenedBottomSheets 2 ${countOpenedBottomSheets} ------');
  }

  // ********* get_current_service_request *********

  bool _isGetSRLoading = false;

  bool get isGetSRLoading => _isGetSRLoading;

  set isGetSRLoading(bool value) {
    _isGetSRLoading = value;
    emit(SetIsGetSRLoadingState());
  }

  int _currentLoadingIndex = 0;

  int get currentLoadingIndex => _currentLoadingIndex;

  set currentLoadingIndex(int value) {
    _currentLoadingIndex = value;
    emit(SetCurrentLoadingIndexState());
  }

  void getCurrentActiveServiceRequest({
    bool fromIframe = false,
    required int reqID,
  }) async {
    isGetSRLoading = true;
    emit(GetCurrentActiveServiceRequestLoadingState());

    final result = await _repository.getOneServiceRequest(
      serviceRequestId: reqID,
      // serviceRequestId: (CurrentUser.isCorporate && _corporateRequestId != null)
      //     ? CORPORATE_REQUEST_ID
      //     : CURRENT_REQUEST_ID,
    );
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isGetSRLoading = false;
        emit(
          GetCurrentActiveServiceRequestErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        debugPrint('-----data------');
        serviceRequestModel = data;
        // if (!CurrentUser.isCorporate) {
        //   sl<CacheHelper>().put('CURRENT_REQUEST_ID',
        //       serviceRequestModel!.serviceRequestDetails.id);
        //   CURRENT_REQUEST_ID = serviceRequestModel!.serviceRequestDetails.id;
        // }
        debugPrint('-----serviceRequestModel------');
        debugPrint(serviceRequestModel!.serviceRequestDetails.status);

        if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.canceled.name ||
            serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.cancelWithPayment.name) {
          clearOnStart(
            isFirst: false,
          );

          setMyLocation();

          emit(CancelServiceRequestSuccessState());
        } else {
          handleCurrentRequestUi();
        }

        isGetSRLoading = false;
        emit(GetCurrentActiveServiceRequestSuccessState(
          fromIframe: fromIframe,
        ));
      },
    );
  }

  // void getCurrentActiveServiceRequest({bool fromIframe = false}) async {
  //   emit(GetCurrentActiveServiceRequestLoadingState());
  //
  //   final result = await _repository.getOneServiceRequest(
  //     serviceRequestId: serviceRequestModel!.serviceRequestDetails.id,
  //     // serviceRequestId: (CurrentUser.isCorporate && _corporateRequestId != null)
  //     //     ? CORPORATE_REQUEST_ID
  //     //     : CURRENT_REQUEST_ID,
  //   );
  //
  //   result.fold(
  //     (failure) {
  //       debugPrint('-----failure------');
  //       debugPrint(failure.toString());
  //
  //       emit(
  //         GetCurrentActiveServiceRequestErrorState(
  //           error: failure,
  //         ),
  //       );
  //     },
  //     (data) {
  //       debugPrint('-----data------');
  //       serviceRequestModel = data;
  //
  //       debugPrint(
  //           '%%%%%%%%%% ${serviceRequestModel!.serviceRequestDetails.status}');
  //
  //       // if (!CurrentUser.isCorporate) {
  //       //   sl<CacheHelper>().put('CURRENT_REQUEST_ID',
  //       //       serviceRequestModel!.serviceRequestDetails.id);
  //       //   CURRENT_REQUEST_ID = serviceRequestModel!.serviceRequestDetails.id;
  //       // }
  //
  //       debugPrint('-----serviceRequestModel------');
  //       debugPrint(serviceRequestModel!.serviceRequestDetails.status);
  //
  //       handleCurrentRequestUi();
  //
  //       debugPrint('-----66------');
  //       emit(
  //           GetCurrentActiveServiceRequestSuccessState(fromIframe: fromIframe));
  //     },
  //   );
  // }

  // replace english numbers with arabic numbers

  String replaceEnNumberToAr(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '۷', '۸', '۹'];
    for (int i = 0; i < english.length; i++) {
      if (input.contains(english[i])) input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }

  String replaceArNumToEn(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '۷', '۸', '۹'];
    for (int i = 0; i < arabic.length; i++) {
      if (input.contains(arabic[i])) input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  ///************ Corporate Payment ************///
  List<String> paymentMethodsList = [];

  void getPaymentMethodsList() {
    for (int i = 0; i < availablePayments.keys.length; i++) {
      if (availablePayments.values.elementAt(i) == true) {
        paymentMethodsList.add(availablePayments.keys.elementAt(i));
      }
    }
    debugPrint('paymentMethodsList ==> $paymentMethodsList');
    emit(GetPaymentMethodsListSuccess());
  }

  bool isUpdateServiceRequestLoading = false;

  void updateServiceRequest() async {
    isUpdateServiceRequestLoading = true;

    emit(UpdateServiceRequestLoadingState());

    printWarning('isFeesEqualZero ??  ==> ${isFeesEqualZero}');

    final result = await _repository.updateOneServiceRequest(
      serviceRequestId: serviceRequestModel!.serviceRequestDetails.id,
      status: 'confirmed',
      paymentMethod: isFeesEqualZero ? ServicePaymentMethods.cash.value : paymentMethod.value,
      paymentStatus: isFeesEqualZero
          ? 'paid'
          : paymentMethod == ServicePaymentMethods.onlineCard
              ? 'paid'
              : 'pending',
    );

    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());

        isUpdateServiceRequestLoading = false;

        emit(
          UpdateServiceRequestErrorState(
            error: failure,
          ),
        );
      },
      (data) async {
        serviceRequestModel = data;
        isUpdateServiceRequestLoading = false;
        debugPrint('-----serviceRequestModel------');
        debugPrint(serviceRequestModel!.serviceRequestDetails.status);
        getCurrentServiceRequestStatus();

        ///* online payment case
        if (paymentMethod == ServicePaymentMethods.onlineCard) {
          printWarning('online Payment ==> 3}');
          if (driverModel!.driver.fcmtoken.isNotEmpty) {
            FCM.sendMessage(
              driverModel!.driver.fcmtoken,
              "helpoo",
              "تم استقبال طلب جديد",
              serviceRequestModel!.serviceRequestDetails.id.toString(),
              'service-request',
            );
          }
        } else {
          assignDriver();
        }

        emit(UpdateServiceRequestSuccessState());
      },
    );
  }

  ///************************ Assign Driver ********************************
  Future<void> assignDriver({
    bool isWithTimer = true,
  }) async {
    emit(AssignDriverLoadingState());
    debugPrint('---->>> assignDriver');

    final result = await _repository.assignDriver(
      requestId: serviceRequestModel!.serviceRequestDetails.id.toString(),
      driverId: driverModel!.driver.id.toString(),
    );

    result.fold(
      (error) {
        debugPrintFullText('---->>> ERROR :: ${error}');
        emit(AssignDriverErrorState(error: error.toString()));
      },
      (data) {
        if (isWithTimer) {
          startTimer();
        }
        printWarning('online Payment ==> 1}');
        if (driverModel!.driver.fcmtoken.isNotEmpty) {
          printWarning('FCM TOKEN :: ${driverModel!.driver.fcmtoken ?? 'Emptyyyyyyyyyyyyy'}');
          printWarning('FCM TOKEN :: Assign Driver');

          ///* online payment case
          if (paymentMethod == ServicePaymentMethods.onlineCard) {
            printWarning('online Payment ==> 2}');
            FCM.sendMessage(
              driverModel!.driver.fcmtoken,
              "helpoo",
              'سوف يصلك طلب جديد قريبا في انتظار تأكيد العميل',
              serviceRequestModel!.serviceRequestDetails.id.toString(),
              'service-request',
            );
          } else {
            FCM.sendMessage(
              driverModel!.driver.fcmtoken,
              "helpoo",
              "تم استقبال طلب جديد",
              serviceRequestModel!.serviceRequestDetails.id.toString(),
              'service-request',
            );
          }
        }

        emit(AssignDriverSuccessState());
      },
    );
  }

  ///************************ Un Assign Driver ********************************
  void unAssignDriver() async {
    emit(UnAssignDriverLoadingState());
    debugPrint('---->>> un assign driver');

    final result = await _repository.unAssignDriver(
      requestId: serviceRequestModel!.serviceRequestDetails.id.toString(),
    );
    // TODO : *** send Notification to Driver ***
    ///* online payment case
    if (driverModel!.driver.fcmtoken.isNotEmpty) {
      FCM.sendMessage(
        driverModel!.driver.fcmtoken,
        "helpoo",
        "تم الغاء الطلب",
        serviceRequestModel!.serviceRequestDetails.id.toString(),
        'service-request',
      );
    }

    result.fold(
      (error) {
        debugPrintFullText('---->>> ERROR :: ${error}');
        emit(UnAssignDriverErrorState(error: error.toString()));
      },
      (data) {
        emit(UnAssignDriverSuccessState());
      },
    );
  }

  void getCurrentServiceRequestStatus({bool isFirstTime = false}) {
    printWarning('==>> CURRENT_SR_STATUS ${serviceRequestModel!.serviceRequestDetails.status}');
    emit(
      GetCurrentServiceRequestStatusState(
        serviceRequestStatus: ServiceRequestStatusEnum.values
            .firstWhere((element) => element.name == serviceRequestModel!.serviceRequestDetails.status),
      ),
    );
  }

  void cancelServiceRequest({
    int? id,
    bool fromHome = false,
  }) async {
    debugPrint('----- SR Id ------> ');
    emit(CancelServiceRequestLoadingState());
    final result = await _repository.cancelServiceRequest(
      serviceRequestId: id != null ? id : serviceRequestModel!.serviceRequestDetails.id,
    );
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());

        emit(
          CancelServiceRequestErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        // sl<CacheHelper>().clear('CURRENT_REQUEST_ID');
        if (serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel != null) {
          printWarning(
              'FCM TOKEN :: ${serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel?.fcmtoken ?? 'Emptyyyyyyyyyyyyyyyyyy'}');
          printWarning('FCM TOKEN :: Assign Driver');
          FCM.sendMessage(
            serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.fcmtoken,
            "helpoo",
            "لقد تم الغاء الطلب",
            // cubit.request.driver.arabic ? "تم استقبال طلب جديد" : "New request",
            serviceRequestModel!.serviceRequestDetails.id.toString(),
            'service-request',
          );
        }
        if (!fromHome) {
          closeAllBottomSheets();

          clearOnStart(
            isFirst: false,
          );

          setMyLocation();
        }

        emit(CancelServiceRequestSuccessState());
      },
    );
  }

  String IFrameUrl = '';

  void getIFrameUrl() async {
    emit(GetIFrameUrlLoadingState());

    final result = await _repository.getPaymentToken(
      serviceRequestId: serviceRequestModel!.serviceRequestDetails.id,
      amount: serviceRequestModel!.serviceRequestDetails.fees.toString(),
    );

    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());

        emit(
          GetIFrameUrlErrorState(
            error: failure,
          ),
        );
      },
      (data) {
        IFrameUrl = data;
        debugPrint('-----IFrameUrl------');
        debugPrint(IFrameUrl);

        emit(GetIFrameUrlSuccessState());
      },
    );
  }

  bool _isPaymentLoading = false;

  bool get isPaymentLoading => _isPaymentLoading;

  set isPaymentLoading(bool value) {
    _isPaymentLoading = value;
    emit(ChangeIsPaymentLoadingState());
  }

  bool _isPaymentSuccess = false;

  bool get isPaymentSuccess => _isPaymentSuccess;

  set isPaymentSuccess(bool value) {
    _isPaymentSuccess = value;
    emit(ChangeIsPaymentSuccessState());
  }

  void onlinePaymentSuccess() {
    isPaymentSuccess = true;

    emit(OnlinePaymentSuccessState());
  }

  void showPaymentBottomSheet() {
    emit(ShowPaymentBottomSheetState());
  }

//   double calculateDistancePrice({
//     bool isNormalTowing = true,
// }) {
//     if(isNormalTowing) {
//       return (normalTowing!.costPerKm!.toDouble() * polylineResult!.distanceInKm);
//     }
//
//     return (euroTowing!.costPerKm!.toDouble() * polylineResult!.distanceInKm);
//   }

  //****************************************************************************
  /// ----------------- get highest discount -----------------

  String getHighestDiscount(List<int> discounts) {
    String highestDiscount = '';
    if (discounts.isNotEmpty) {
      discounts.sort((a, b) => a.compareTo(b));
      debugPrint('-----highest discount>>>>>> ${discounts.last}------');
      highestDiscount = discounts.last.toString();
    }
    return highestDiscount;
  }

  //****************************************************************************

  num _selectedFees = 0;

  num get selectedFees => _selectedFees;

  set selectedFees(num value) {
    _selectedFees = value;
    emit(ChangeSelectedFees());
  }

  num _selectedPercentage = 0;

  num get selectedPercentage => _selectedPercentage;

  set selectedPercentage(num value) {
    _selectedPercentage = value;
    emit(ChangeSelectedPercentage());
  }

  bool isTowingSelectingLoading = false;

  bool _isTowingSelected = false;

  bool get isTowingSelected => _isTowingSelected;

  set isTowingSelected(bool value) {
    _isTowingSelected = value;
    emit(TowingSelectedActionState());
  }

  void towingSelectedAction() {
    isTowingSelectingLoading = true;
    selectedFees = isNormalTowingSelected ? calculateFeesModel!.normalFees : calculateFeesModel!.euroFees;
    selectedPercentage =
        isNormalTowingSelected ? calculateFeesModel!.normalPercentage : calculateFeesModel!.euroPercentage;
    isTowingSelected = true;
    emit(TowingSelectedActionState());
  }

  bool _isNormalTowingSelected = true;

  bool get isNormalTowingSelected => _isNormalTowingSelected;

  set isNormalTowingSelected(bool value) {
    _isNormalTowingSelected = value;
    emit(ChangeIsNormalTowingSelected());
  }

  //******************************************************************************
  ///******************** Search Places ******************************///
  //******************************************************************************
  MapPlaceModel? mapPlaceModel;

  bool _isOrigin = true;

  bool get isOrigin => _isOrigin;

  set isOrigin(bool value) {
    _isOrigin = value;
    emit(ChangeIsOrigin());
  }

  String _originAddress = '';

  String get originAddress => _originAddress;

  set originAddress(String value) {
    _originAddress = value;
    emit(ChangeOriginAddress());
  }

  String _destinationAddress = '';

  String get destinationAddress => _destinationAddress;

  set destinationAddress(String value) {
    _destinationAddress = value;
    emit(ChangeDestinationAddress());
  }

  LatLng? _originLatLng;

  LatLng? get originLatLng => _originLatLng;

  set originLatLng(LatLng? value) {
    _originLatLng = value;
    emit(ChangeOriginLatLng());
  }

  LatLng? _destinationLatLng;

  LatLng? get destinationLatLng => _destinationLatLng;

  set destinationLatLng(LatLng? value) {
    _destinationLatLng = value;
    emit(ChangeDestinationLatLng());
  }

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  void searchMapPlace({
    required String input,
  }) async {
    emit(SearchMapPlaceLoading());

    final result = await _repository.searchPlace(
      input: input,
    );

    result.fold(
      (failure) {
        debugPrint(failure.toString());
        emit(
          SearchMapPlaceError(
            error: failure,
          ),
        );
      },
      (data) {
        mapPlaceModel = data;

        debugPrint("mapPlaceModel ::::: ${mapPlaceModel!.predictions.length}");

        emit(
          SearchMapPlaceSuccess(),
        );
      },
    );
  }

  MapPlaceDetailsModel? mapPlaceDetailsModel;

  String _originName = '';

  String get originName => _originName;

  set originName(String value) {
    _originName = value;
    emit(ChangeOriginName());
  }

  String _destinationName = '';

  String get destinationName => _destinationName;

  set destinationName(String value) {
    _destinationName = value;
    emit(ChangeDestinationName());
  }

  bool _isFromSearch = false;

  bool get isFromSearch => _isFromSearch;

  set isFromSearch(bool value) {
    _isFromSearch = value;
    emit(ChangeIsFromSearch());
  }

  void getMapPlaceDetails({
    required MapPlaceDataModel value,
  }) async {
    // mapPlaceDataModel = value;
    //
    // debugPrint('mapPlaceDataModel');
    // debugPrint(mapPlaceDataModel!.placeId);
    // debugPrint(mapPlaceDataModel!.mainText);
    // debugPrint(mapPlaceDataModel!.secondaryText);

    emit(GetMapPlaceDetailsLoading());

    final result = await _repository.getPlaceDetails(
      placeId: value.placeId,
    );

    result.fold(
      (failure) {
        debugPrint(failure.toString());
        emit(
          GetMapPlaceDetailsError(
            error: failure,
          ),
        );
      },
      (data) {
        mapPlaceDetailsModel = data;
        mapPlaceModel = null;

        if (isOrigin) {
          originController.clear();
          // originController.text = mapPlaceDetailsModel!.result.address;
          originController.text = originName;
          _originAddress = originName;
          originLatLng = LatLng(
            mapPlaceDetailsModel!.result.latitude.toDouble(),
            mapPlaceDetailsModel!.result.longitude.toDouble(),
          );
        } else {
          destinationController.clear();
          // destinationController.text = mapPlaceDetailsModel!.result.address;
          destinationController.text = destinationName;

          _destinationAddress = destinationName;
          destinationLatLng = LatLng(
            mapPlaceDetailsModel!.result.latitude.toDouble(),
            mapPlaceDetailsModel!.result.longitude.toDouble(),
          );
        }

        cameraMovementPosition = LatLng(
          mapPlaceDetailsModel!.result.latitude.toDouble(),
          mapPlaceDetailsModel!.result.longitude.toDouble(),
        );

        addSvgMarker(
          latitude: mapPlaceDetailsModel!.result.latitude.toDouble(),
          longitude: mapPlaceDetailsModel!.result.longitude.toDouble(),
          id: 'myLocation',
        );

        setLocationFromCameraMoving();

        emit(
          GetMapPlaceDetailsSuccess(),
        );
      },
    );
  }

  MapPlaceDetailsCoordinatesModel? mapPlaceDetailsCoordinatesModel;

  // bool isGetMapsGoordinatesDetailsLoading = false;

  void getPlaceDetailsByCoordinates({
    required double latitude,
    required double longitude,
    bool isMyLocation = true,
  }) async {
    // isGetMapsGoordinatesDetailsLoading = true;
    emit(GetMapPlaceCoordinatesDetailsLoading());

    final result = await _repository.getPlaceDetailsByCoordinates(
      latLng: '$latitude,$longitude',
    );

    result.fold(
      (failure) {
        debugPrint(failure.toString());
        emit(
          GetMapPlaceCoordinatesDetailsError(
            error: failure,
          ),
        );
      },
      (data) {
        mapPlaceDetailsCoordinatesModel = data;

        if (isOrigin) {
          if (originController.text.isEmpty) {
            debugPrint('originName.isEmpty');
            originController.clear();
            originController.text = mapPlaceDetailsCoordinatesModel!.placeName;
          }

          debugPrint('Origin ==> : ${mapPlaceDetailsCoordinatesModel!.placeName}');
          originAddress = mapPlaceDetailsCoordinatesModel!.placeName;
          originLatLng = LatLng(
            latitude,
            longitude,
          );
        } else {
          if (destinationController.text.isEmpty) {
            destinationController.clear();
            destinationController.text = mapPlaceDetailsCoordinatesModel!.placeName;
          }
          debugPrint('Destination ==> : ${mapPlaceDetailsCoordinatesModel!.placeName}');
          destinationAddress = mapPlaceDetailsCoordinatesModel!.placeName;
          destinationLatLng = LatLng(
            latitude,
            longitude,
          );
        }

        if (isMyLocation) {
          addSvgMarker(
            id: 'myLocation',
            latitude: currentPosition!.latitude,
            longitude: currentPosition!.longitude,
          );
        } else {
          addSvgMarker(
            id: 'myLocation',
            latitude: cameraMovementPosition!.latitude,
            longitude: cameraMovementPosition!.longitude,
          );
        }

        // isGetMapsGoordinatesDetailsLoading = false;
        emit(
          GetMapPlaceCoordinatesDetailsSuccess(),
        );
      },
    );
  }

  //******************************************************************************
  ///******************** Set Map Controller ******************************///

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  // bool isSetMapControllerLoading = false;

  void setMapController({
    required GoogleMapController controller,
  }) async {
    // isSetMapControllerLoading = true;
    debugPrint('setMapController--------------------------');
    // emit(SetMapControllerLoading());
    mapController = controller;

    // rootBundle.loadString('assets/images/map_style.txt').then((string) {
    //   mapController!.setMapStyle(string);
    //
    //   emit(SetMapThemeSuccess());
    // });

    if (currentPosition != null) {
      moveCameraToPosition(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );
    }

    markers = {};

    debugPrint('setMapController');
    // debugPrint(isRunning.toString());

    if (false) {
      // markers.add(
      //   Marker(
      //     onTap: () {},
      //     markerId: const MarkerId('selectedLocation'),
      //     position: LatLng(
      //       double.parse(selectAddressModel.latitude),
      //       double.parse(selectAddressModel.longitude),
      //     ),
      //     icon: bitmapDescriptor!,
      //   ),
      // );
    } else {
      // markers.add(
      //   Marker(
      //     onTap: () {},
      //     markerId: const MarkerId('selectedLocation'),
      //     position: LatLng(myLatLong!.latitude!, myLatLong!.longitude!),
      //     icon: bitmapDescriptor!,
      //   ),
      // );
    }

    // isSetMapControllerLoading = false;

    emit(SetMapControllerSuccess());
  }

  LatLng _initialCameraPosition = LatLng(30.0595581, 31.223445);

  LatLng get initialCameraPosition => _initialCameraPosition;

  set initialCameraPosition(LatLng value) {
    _initialCameraPosition = value;
    emit(ChangeInitialCameraPosition());
  }

  LocationData? myLatLong;

  BitmapDescriptor? bitmapDescriptor;

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(BuildContext context, String assetName) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, 'key');

    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 32 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 32 * devicePixelRatio; // same thing

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Position? currentPosition;

  void startLocationService() {
    Location().hasPermission().then((value) async {
      if (value == PermissionStatus.granted) {
        debugPrint('PermissionStatus.granted');

        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            distanceFilter: 10,
            timeLimit: Duration(seconds: 10),
          ),
        ).listen((event) {
          currentPosition = event;
        });

        // Location().getLocation().then((LocationData? myLocation) {
        //   debugPrint('thenMyLocation=> $myLocation');
        //
        //   if (myLocation != null) {
        //     myLatLong = myLocation;
        //
        //     emit(SetMyLocationSuccess());
        //   }
        // }).catchError((error) {
        //   debugPrint(error.toString());
        //   emit(SetMyLocationError());
        // });

        debugPrint('PermissionStatus');
      } else if (value == PermissionStatus.denied) {
        debugPrint('PermissionStatus.denied');

        Location().requestPermission().then((value) {
          startLocationService();
        }).catchError((error) {
          emit(SetMyLocationError());
        });
      } else if (value == PermissionStatus.deniedForever) {
        debugPrint('PermissionStatus.deniedForever');

        Location().requestPermission().then((value) {
          startLocationService();
        }).catchError((error) {
          emit(SetMyLocationError());
        });
      }
    });
  }

  void startLocationServiceOnce() {
    Location().hasPermission().then((value) async {
      if (value == PermissionStatus.granted) {
        debugPrint('PermissionStatus.granted');

        Geolocator.getCurrentPosition().then((event) {
          currentPosition = event;

          startLocationService();

          debugPrint('currentPosition=> $currentPosition');
          emit(SetMyLocationSuccess());
        });

        // Location().getLocation().then((LocationData? myLocation) {
        //   debugPrint('thenMyLocation=> $myLocation');
        //
        //   if (myLocation != null) {
        //     myLatLong = myLocation;
        //
        //     emit(SetMyLocationSuccess());
        //   }
        // }).catchError((error) {
        //   debugPrint(error.toString());
        //   emit(SetMyLocationError());
        // });

        debugPrint('PermissionStatus');
      } else if (value == PermissionStatus.denied) {
        debugPrint('PermissionStatus.denied');

        Location().requestPermission().then((value) {
          startLocationServiceOnce();
        }).catchError((error) {
          emit(SetMyLocationError());
        });
      } else if (value == PermissionStatus.deniedForever) {
        debugPrint('PermissionStatus.deniedForever');

        Location().requestPermission().then((value) {
          startLocationServiceOnce();
        }).catchError((error) {
          emit(SetMyLocationError());
        });
      }
    });
  }

  void fireLocationAlreadyHere() {
    debugPrint('fireLocationAlreadyHere');
    emit(SetMyLocationSuccess());
  }

  void setMyLocation() async {
    debugPrint('setMyLocation => $currentPosition');

    if (currentPosition == null) {
      return;
    }

    if (currentPosition != null) {
      initialCameraPosition = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }

    // addSvgMarker(
    //   id: 'myLocation',
    //   latitude: currentPosition!.latitude,
    //   longitude: currentPosition!.longitude,
    // );

    getPlaceNameFromCameraMovingAndDisplayIt(
      latitude: currentPosition!.latitude,
      longitude: currentPosition!.longitude,
      isMyLocation: true,
    );

    moveCameraToPosition(
      latitude: currentPosition!.latitude,
      longitude: currentPosition!.longitude,
    );

    // Location().hasPermission().then((value) async {
    //   if (value == PermissionStatus.granted) {
    //     debugPrint('PermissionStatus.granted');
    //
    //     currentPosition = await Geolocator.getCurrentPosition();
    //
    //
    //
    //     debugPrint('currentPosition=> $currentPosition');
    //
    //     // Location().getLocation().then((LocationData? myLocation) {
    //     //   debugPrint('thenMyLocation=> $myLocation');
    //     //
    //     //   if (myLocation != null) {
    //     //     myLatLong = myLocation;
    //     //
    //     //     emit(SetMyLocationSuccess());
    //     //   }
    //     // }).catchError((error) {
    //     //   debugPrint(error.toString());
    //     //   emit(SetMyLocationError());
    //     // });
    //
    //     debugPrint('PermissionStatus');
    //   } else if (value == PermissionStatus.denied) {
    //     debugPrint('PermissionStatus.denied');
    //
    //     Location().requestPermission().then((value) {
    //       setMyLocation();
    //     }).catchError((error) {
    //       emit(SetMyLocationError());
    //     });
    //   } else if (value == PermissionStatus.deniedForever) {
    //     debugPrint('PermissionStatus.deniedForever');
    //
    //     Location().requestPermission().then((value) {
    //       setMyLocation();
    //     }).catchError((error) {
    //       emit(SetMyLocationError());
    //     });
    //   }
    // });

    // if (myLatLong == null) {
    //   Location().hasPermission().then((value) async {
    //     if (value == PermissionStatus.granted) {
    //       debugPrint('PermissionStatus.granted');
    //
    //       Position position = await Geolocator.getCurrentPosition();
    //
    //       initialCameraPosition = LatLng(position.latitude, position.longitude);
    //
    //       bitmapDescriptor ??=
    //       await _bitmapDescriptorFromSvgAsset(context, 'assets/imgs/location_icon.svg');
    //
    //       markers.add(
    //         Marker(
    //           onTap: () {},
    //           markerId: const MarkerId('selectedLocation'),
    //           position: LatLng(position.latitude, position.longitude),
    //           icon: bitmapDescriptor!,
    //         ),
    //       );
    //
    //       mapController!.animateCamera(
    //         CameraUpdate.newCameraPosition(
    //           CameraPosition(
    //             target: LatLng(position.latitude, position.longitude),
    //             zoom: 14.4746,
    //           ),
    //         ),
    //       );
    //
    //       debugPrint('position=> $position');
    //
    //       // Location().getLocation().then((LocationData? myLocation) {
    //       //   debugPrint('thenMyLocation=> $myLocation');
    //       //
    //       //   if (myLocation != null) {
    //       //     myLatLong = myLocation;
    //       //
    //       //     emit(SetMyLocationSuccess());
    //       //   }
    //       // }).catchError((error) {
    //       //   debugPrint(error.toString());
    //       //   emit(SetMyLocationError());
    //       // });
    //
    //       debugPrint('PermissionStatus');
    //     } else if (value == PermissionStatus.denied) {
    //       debugPrint('PermissionStatus.denied');
    //
    //       Location().requestPermission().then((value) {
    //         setMyLocation(context);
    //       }).catchError((error) {
    //         emit(SetMyLocationError());
    //       });
    //     } else if (value == PermissionStatus.deniedForever) {
    //       debugPrint('PermissionStatus.deniedForever');
    //
    //       Location().requestPermission().then((value) {
    //         setMyLocation(context);
    //       }).catchError((error) {
    //         emit(SetMyLocationError());
    //       });
    //     }
    //   });
    // }
  }

  LatLng? _cameraMovementPosition;

  LatLng? get cameraMovementPosition => _cameraMovementPosition;

  set cameraMovementPosition(LatLng? value) {
    _cameraMovementPosition = value;

    emit(CameraMovementPositionChanged());
  }

  void setLocationFromCameraMoving() {
    if (cameraMovementPosition == null) return;

    // addSvgMarker(
    //   id: 'myLocation',
    //   latitude: cameraMovementPosition!.latitude,
    //   longitude: cameraMovementPosition!.longitude,
    // );

    if (isOrigin) {
      if (originController.text.isEmpty) {
        getPlaceNameFromCameraMovingAndDisplayIt(
          latitude: cameraMovementPosition!.latitude,
          longitude: cameraMovementPosition!.longitude,
        );
      }
    } else {
      if (destinationController.text.isEmpty) {
        getPlaceNameFromCameraMovingAndDisplayIt(
          latitude: cameraMovementPosition!.latitude,
          longitude: cameraMovementPosition!.longitude,
        );
      }
    }

    moveCameraToPosition(
      latitude: cameraMovementPosition!.latitude,
      longitude: cameraMovementPosition!.longitude,
    );
  }

  void addSvgMarker({
    required double latitude,
    required double longitude,
    required String id,
    String? icon,
  }) async {
    bitmapDescriptor ??= await _bitmapDescriptorFromSvgAsset(
      navigatorKey.currentContext!,
      'assets/imgs/location_icon.svg',
    );

    debugPrint('bitmapDescriptor=> $bitmapDescriptor');

    markers = {};

    markers.add(
      Marker(
        onTap: () {},
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        icon: bitmapDescriptor!,
        draggable: false,
      ),
    );

    debugPrint('markers=> ${markers.length}');

    emit(AddMarkerSuccess());
  }

  void addPngMarker({
    required double latitude,
    required double longitude,
    required double heading,
    required String id,
    String? icon,
    bool isWinch = true,
  }) async {
    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/imgs/${icon ?? (Platform.isIOS ? 'tow_truck2' : 'tow_truck')}.png",
    );

    markers.add(
      Marker(
        onTap: () {},
        rotation: icon != null && isWinch ? heading : 0.0,
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        icon: icon != null && isWinch ? markerIcon : BitmapDescriptor.defaultMarker,
        // draggable: id == 'from',
        // onDragEnd: (newPosition) {
        //   debugPrint('newPosition=> $newPosition');
        //   debugPrint(id);
        //
        //   if (id == 'from') {
        //     isOrigin = true;
        //
        //     originLatLng = newPosition;
        //
        //     getPlaceDetailsByCoordinates(
        //       latitude: originLatLng!.latitude,
        //       longitude: originLatLng!.longitude,
        //     );
        //
        //     getMainTripPath();
        //   }
        // },
      ),
    );

    emit(AddMarkerSuccess());
  }

  void getPlaceNameFromCameraMovingAndDisplayIt({
    required double latitude,
    required double longitude,
    bool isMyLocation = false,
  }) {
    debugPrint('getPlaceNameFromCameraMovingAndDisplayIt');
    // if(isOrigin) {
    //   originName = '';
    // } else {
    //   destinationName = '';
    // }

    mapPlaceDetailsCoordinatesModel = null;

    getPlaceDetailsByCoordinates(
      latitude: latitude,
      longitude: longitude,
      isMyLocation: isMyLocation,
    );
  }

  void moveCameraToPosition({
    required double latitude,
    required double longitude,
  }) {
    if (mapController == null) return;

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.4746,
        ),
      ),
    );

    emit(MoveCameraToPositionSuccess());
  }

  // int CURRENT_REQUEST_ID = 0;
  //
  // int? _corporateRequestId;
  //
  // int get CORPORATE_REQUEST_ID => _corporateRequestId!;
  //
  // set CORPORATE_REQUEST_ID(int? value) {
  //   _corporateRequestId = value;
  //   emit(CorporateRequestIdChanged());
  // }

  // bool isClearOnStartLoading = false;
  // bool isClearOnStartLoadingFromTopButton = false;

  void clearOnStart({
    bool isFirst = true,
    // bool isFromTopButton = false,
  }) {
    // if (isFromTopButton) {
    //   isClearOnStartLoadingFromTopButton = true;
    // } else {
    //   isClearOnStartLoading = true;
    // }
    // debugPrint('clearOnStartLoading => $isClearOnStartLoading');
    // emit(ClearOnStartLoading());
    isSlidingUpPanelShow = false;

    setMyLocation();
    // sl<CacheHelper>().clear('CURRENT_REQUEST_ID');
    // sl<CacheHelper>().put('CURRENT_REQUEST_ID',1659);
    // if (CurrentUser.isCorporate && _corporateRequestId != null) {
    //   getCurrentActiveServiceRequest();
    // }

    // sl<CacheHelper>().get('CURRENT_REQUEST_ID').then((value) {
    //   if (value != null) {
    //     debugPrint('CURRENT_REQUEST_ID=> $value');
    //     CURRENT_REQUEST_ID = value;
    //
    //     getCurrentActiveServiceRequest();
    //   }
    // });

    isPaymentSuccess = false;

    isSlidingUpPanelCollapsed = true;
    // isServiceOrdered = false;

    serviceRequestModel = null;

    debugPrint('clearOnStart ==============');
    debugPrint(selectedCarId.toString());

    isGettingPathLoading = false;

    if (isFirst) {
      debugPrint('============= countOpenedBottomSheets ================');
      mapController = null;
      countOpenedBottomSheets = 0;
    }

    mapPlaceModel = null;
    polyLines = {};
    markers.clear();

    isOrigin = true;

    originLatLng = null;
    destinationLatLng = null;

    originController.clear();
    destinationController.clear();
    // isClearOnStartLoading = false;
    emit(ClearOnStart());
  }

  void clearFields({
    bool origin = false,
  }) {
    mapPlaceModel = null;
    polyLines = {};
    markers.clear();

    if (origin) {
      isOrigin = true;
      originLatLng = null;
    } else {
      isOrigin = false;
      destinationLatLng = null;
    }

    emit(ClearFields());
  }

  int _selectedCarId = 0;

  int get selectedCarId => _selectedCarId;

  set selectedCarId(int value) {
    _selectedCarId = value;
    emit(SelectedCarIdChanged());
  }

  Vehicle? _selectedCar;

  Vehicle? get selectedCar => _selectedCar;

  set selectedCar(Vehicle? value) {
    debugPrint('selectedCar');
    _selectedCar = value;
    emit(SelectedCarChanged());
  }

  // bool isDiscountBiggerThanAmount = false;

  //
  // bool _isPayWithPackageDiscount = false;
  //
  // bool get isPayWithPackageDiscount => _isPayWithPackageDiscount;
  //
  // set isPayWithPackageDiscount(bool value) {
  //   _isPayWithPackageDiscount = value;
  //   emit(IsPayWithPackageDiscount());
  // }

  bool _isFeesEqualZero = false;

  bool get isFeesEqualZero => _isFeesEqualZero;

  set isFeesEqualZero(bool value) {
    _isFeesEqualZero = value;
    emit(IsPayWithPackageDiscount());
  }

  Map<PolylineId, Polyline> polyLines = {};

  bool _isCameraIdle = true;

  bool get isCameraIdle => _isCameraIdle;

  set isCameraIdle(bool value) {
    _isCameraIdle = value;
    emit(IsCameraIdle());
  }

  bool _isGettingPathLoading = false;

  bool get isGettingPathLoading => _isGettingPathLoading;

  set isGettingPathLoading(bool value) {
    _isGettingPathLoading = value;
    emit(IsGettingPathLoading());
  }

  PolylineResult? mainTripPolylineResult;

  void getMainTripPath({
    bool isFromCurrentRequest = false,
    bool isRefreshFixedBottomSheet = true,
    bool isDraw = true,
  }) async {
    PolylinePoints polylinePoints = PolylinePoints();

    polylinePoints
        .getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(originLatLng!.latitude, originLatLng!.longitude),
      PointLatLng(destinationLatLng!.latitude, destinationLatLng!.longitude),
      travelMode: TravelMode.driving,
    )
        .then((value) {
      // value.points.forEach((element) {
      //   debugPrint('element=> $element');
      // });

      mainTripPolylineResult = value;

      debugPrint('value.distance=> ${value.distance}');
      debugPrint('value.duration=> ${value.duration}');
      debugPrint('value.durationInTraffic=> ${value.duration_in_traffic}');

      if (!isFromCurrentRequest) {
        getServiceRequestTypes();
        calculateServiceFees();

        if (isDraw) {
          animateCameraToShowPath(
            from: originLatLng!,
            to: destinationLatLng!,
          );

          polyLines = {};

          PolylineId id = PolylineId('');

          Polyline polyline = Polyline(
            polylineId: id,
            color: Theme.of(navigatorKey.currentContext!).primaryColor,
            points: value.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
            width: 4,
          );

          polyLines[id] = polyline;
        }
      } else {
        debugPrint('isFromCurrentRequest');
        debugPrint(isRefreshFixedBottomSheet.toString());
        debugPrint(countOpenedBottomSheets.toString());

        if (isRefreshFixedBottomSheet && countOpenedBottomSheets <= 0) {
          printWarning('isRefreshFixedBottomSheet && countOpenedBottomSheets <= 0 :===>>> ${countOpenedBottomSheets} ');
          getCurrentServiceRequestStatus();
        } else {
          if (serviceRequestModel!.serviceRequestDetails.status != ServiceRequestStatusEnum.confirmed.name) {
            printWarning('==>> closeAllBottomSheets');
            closeAllBottomSheets();
            if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.accepted.name ||
                serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.arrived.name ||
                serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.started.name ||
                serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.destArrived.name) {
              debugPrint('isSlidingUpPanelCollapsed=> $isSlidingUpPanelCollapsed');
              isSlidingUpPanelShow = true;
            }

            isSlidingUpPanelCollapsed = false;
          }
          if (serviceRequestModel!.serviceRequestDetails.status == ServiceRequestStatusEnum.done.name) {
            isSlidingUpPanelShow = false;
          }
          // closeAllBottomSheets();
        }
      }

      emit(GetPathToDrawSuccess());
    }).catchError((error) {
      debugPrint('============== error =============');
      debugPrint(error.toString());
      emit(GetPathToDrawError());
    });
  }

  bool _isSlidingUpPanelShow = false;

  bool get isSlidingUpPanelShow => _isSlidingUpPanelShow;

  set isSlidingUpPanelShow(bool value) {
    _isSlidingUpPanelShow = value;
    emit(IsSlidingUpPanelShow());
  }

  void closeAllBottomSheets() {
    debugPrint('closeAllBottomSheets');

    if (countOpenedBottomSheets == 0) return;

    debugPrint('closeAllBottomSheets');
    debugPrint(countOpenedBottomSheets.toString());

    // for (int i = 0; i < countOpenedBottomSheets; i++) {
    //   // navigatorKey.currentState!.pop();
    //   debugPrint('closeAllBottomSheets');
    // }

    navigatorKey.currentContext!.pop;

    countOpenedBottomSheets = 0;
  }

  PolylineResult? driverPolylineResult;

  void getDriverPath({
    required LatLng from,
    required LatLng to,
    required double heading,
    bool withCreateNewRequest = true,
    bool isLastTripPath = false,
  }) async {
    // emit(GetDriverPathLoading());
    debugPrint('getDriverPath');
    debugPrint('driverModel From Lat=> ${from.latitude}');
    debugPrint('driverModel From Lng=> ${from.longitude}');
    debugPrint('driverModel To lat => ${to.latitude}');
    debugPrint('driverModel To lng=> ${to.longitude}');

    PolylinePoints polylinePoints = PolylinePoints();

    polylinePoints
        .getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(from.latitude, from.longitude),
      PointLatLng(to.latitude, to.longitude),
      travelMode: TravelMode.driving,
    )
        .then((value) {
      // value.points.forEach((element) {
      //   debugPrint('element=> $element');
      // });

      driverPolylineResult = value;

      debugPrint('value.distance=> ${value.distance}');
      debugPrint('value.duration=> ${value.duration}');
      debugPrint('value.durationInTraffic=> ${value.duration_in_traffic}');

      animateCameraToShowPath(
        from: from,
        to: to,
        isDriverPath: !isLastTripPath,
        isLastTripPath: isLastTripPath,
        heading: heading,
      );

      polyLines = {};

      PolylineId id = PolylineId('driverPolyLine');

      Polyline polyline = Polyline(
        polylineId: id,
        color: Theme.of(navigatorKey.currentContext!).primaryColor,
        points: value.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
        width: 4,
      );

      polyLines[id] = polyline;

      if (withCreateNewRequest) {
        createNewRequest();
      }

      emit(GetDriverPathToDrawSuccess());
    }).catchError((error) {
      debugPrint('============== error =============');
      debugPrint(error.toString());
      isTowingSelectingLoading = false;

      emit(GetDriverPathToDrawError());
    });
  }

  double southWestLatitude = 0;
  double southWestLongitude = 0;

  double northEastLatitude = 0;
  double northEastLongitude = 0;

  void animateCameraToShowPath({
    required LatLng from,
    required LatLng to,
    double heading = 0.0,
    bool isDriverPath = false,
    bool isLastTripPath = false,
  }) {
    northEastLatitude = 0;
    northEastLongitude = 0;

    southWestLatitude = 0;
    southWestLongitude = 0;

    double miny = (from.latitude <= to.latitude) ? from.latitude : to.latitude;
    double minx = (from.longitude <= to.longitude) ? from.longitude : to.longitude;
    double maxy = (from.latitude <= to.latitude) ? to.latitude : from.latitude;
    double maxx = (from.longitude <= to.longitude) ? to.longitude : from.longitude;

    southWestLatitude = miny;
    southWestLongitude = minx;

    northEastLatitude = maxy;
    northEastLongitude = maxx;

    markers.clear();

    if (isDriverPath) {
      addPngMarker(
        latitude: from.latitude,
        longitude: from.longitude,
        id: 'driver',
        heading: heading,
        icon: Platform.isIOS ? 'tow_truck2' : 'tow_truck',
      );

      addPngMarker(
        latitude: to.latitude,
        longitude: to.longitude,
        id: 'to',
        icon: Platform.isIOS ? 'car2' : 'car',
        heading: heading,
      );
    } else if (isLastTripPath) {
      debugPrint('isLastTripPath');

      addPngMarker(
        latitude: from.latitude,
        longitude: from.longitude,
        id: 'from',
        icon: Platform.isIOS ? 'towing2' : 'towing',
        heading: heading,
      );

      addPngMarker(
        latitude: to.latitude,
        longitude: to.longitude,
        id: 'to',
        // icon: 'pin_new',
        isWinch: false,
        heading: heading,
      );
    } else {
      addPngMarker(
        latitude: from.latitude,
        longitude: from.longitude,
        id: 'from',
        icon: Platform.isIOS ? 'car2' : 'car',
        heading: heading,
      );

      addPngMarker(
        latitude: to.latitude,
        longitude: to.longitude,
        id: 'to',
        heading: heading,
        icon: Platform.isIOS ? 'tow_truck2' : 'tow_truck',
      );
    }

    debugPrint('animate=>');

    // the bounds you want to set
    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(northEastLatitude, northEastLongitude),
      southwest: LatLng(southWestLatitude, southWestLongitude),
    );
// calculating centre of the bounds
    LatLng centerBounds = LatLng((bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

// setting map position to centre to start with

    mapController!.getVisibleRegion().then((value) {
      debugPrint('getVisibleRegion=> $value');

      debugPrint(fits(bounds, value).toString());
    });

    mapController!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        ),
      ),
    );

    zoomToFit(mapController!, bounds, centerBounds);

    // mapController!.animateCamera(
    //   CameraUpdate.newLatLngBounds(
    //     LatLngBounds(
    //       northeast: LatLng(northEastLatitude - 0.0015, northEastLongitude),
    //       southwest: LatLng(southWestLatitude - 0.0015, southWestLongitude),
    //     ),
    //     80.0,
    //   ),
    // );

    // bearing camera to the direction of the route
    // mapController!.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: LatLng(
    //         from.latitude,
    //         from.longitude,
    //       ),
    //       zoom: 14.0,
    //       // bearing: heading,
    //       // tilt: 0.0,
    //     ),
    //   ),
    // );
  }

  double zoomLevel = 12;

  Future<void> zoomToFit(GoogleMapController controller, LatLngBounds bounds, LatLng centerBounds) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();

      if (fits(bounds, screenBounds)) {
        debugPrint('fits');

        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel();

        controller.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: centerBounds,
              zoom: zoomLevel,
            ),
          ),
        );
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        zoomLevel = await controller.getZoomLevel() - 1.0;

        debugPrint('zoomLevel=> $zoomLevel');

        controller.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: centerBounds,
              zoom: zoomLevel,
            ),
          ),
        );
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  void expandCameraToDisplayAllRoute() {
    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude - 0.0015, northEastLongitude),
          southwest: LatLng(southWestLatitude - 0.0015, southWestLongitude),
        ),
        40.0,
      ),
    );

    emit(ExpandCameraToDisplayAllRouteSuccess());
  }

  bool isSlidingUpPanelCollapsed = false;

  void toggleSlidingUpPanel({
    required bool isCollapsed,
  }) {
    isSlidingUpPanelCollapsed = isCollapsed;
    debugPrint('isSlidingUpPanelCollapsed=> $isSlidingUpPanelCollapsed');
    emit(ToggleSlidingUpPanelSuccess());
  }

  // bool isServiceOrdered = false;
  //
  // void toggleServiceOrdered({required bool isOrdered}) {
  //   isServiceOrdered = isOrdered;
  //   emit(ToggleServiceOrderedSuccess());
  // }

  bool _isOnlinePaymentOnly = false;

  bool get isOnlinePaymentOnly => _isOnlinePaymentOnly;

  set isOnlinePaymentOnly(bool value) {
    _isOnlinePaymentOnly = value;
    emit(IsOnlinePaymentOnlyChangedSuccess());
  }

  ServicePaymentMethods _paymentMethod = ServicePaymentMethods.nothing;

  ServicePaymentMethods get paymentMethod => _paymentMethod;

  set paymentMethod(ServicePaymentMethods value) {
    _paymentMethod = value;

    emit(PaymentMethodChangedSuccess());
  }

  WebViewController _webViewController = WebViewController();

  WebViewController get webViewController => _webViewController;

  set webViewController(WebViewController value) {
    _webViewController = value;
    emit(WebViewControllerChangedSuccess());
  }

  ///*================= Rate Request ============*///

  var rateRequestRateCommentController = TextEditingController();
  int _rateValue = 0;

  set rateValue(int value) {
    _rateValue = value;
    emit(RateRequestRateChangedSuccess());
  }

  int get rateValue => _rateValue;

  Future<void> rateRequest() async {
    emit(RateRequestLoading());
    // debugPrintFullText(
    //     '------------- CURRENT_REQUEST_ID :: ${CURRENT_REQUEST_ID}');

    final result = await _repository.rateRequest(
        // reqID: CURRENT_REQUEST_ID.toString(),
        reqID: serviceRequestModel!.serviceRequestDetails.id.toString(),
        rate: _rateValue.toString(),
        comment: rateRequestRateCommentController.text,
        rated: 'true');

    result.fold(
      (error) {
        debugPrintFullText('------------- ERROR :: ${error}');
        emit(RateRequestError(error: error.toString()));
      },
      (data) {
        emit(RateRequestSuccess());

        // sl<CacheHelper>().clear('CURRENT_REQUEST_ID');

        closeAllBottomSheets();

        clearOnStart(
          isFirst: false,
        );

        setMyLocation();
      },
    );
  }

  ///*================= service request promo code ============*///

  TextEditingController serviceRequestPromoCodeController = TextEditingController();

  VoucherModel? voucherModel;

  bool isApplyPromoCodeLoading = false;

  Future<void> applyVoucherCode() async {
    emit(ApplyVoucherCodeLoading());
    isApplyPromoCodeLoading = true;
    final result = await _repository.addServiceRequestVoucher(
      voucher: serviceRequestPromoCodeController.text,
    );

    result.fold(
      (error) {
        isApplyPromoCodeLoading = false;
        emit(ApplyVoucherCodeError(error: error.toString()));
      },
      (data) {
        voucherModel = data;
        isApplyPromoCodeLoading = false;
        emit(ApplyVoucherCodeSuccess());
      },
    );
  }

  ///****************** Compress ***************************
  int totalFileUploaded = 0;
  int doneFileUploaded = 0;
  int minHeightCompress = 3000;
  int minWidthCompress = 3000;
  int qualityCompress = 75;

  Future<File?> compressFiles({required File file}) async {
    final originalBytes = await file.readAsBytes();
    var compressedBytes = await FlutterImageCompress.compressWithList(
      originalBytes,
      quality: qualityCompress,
      minHeight: minHeightCompress,
      minWidth: minWidthCompress,
    );

    if (!checkCompressedImageSize(compressed: compressedBytes)) {
      minHeightCompress -= 100;
      minWidthCompress -= 100;
      qualityCompress -= 5;

      var compressFile = await compressFiles(file: File(file.path)..writeAsBytesSync(compressedBytes));
      List<int> bytes = await compressFile!.readAsBytes();
      compressedBytes = Uint8List.fromList(bytes);
    }
    return File(file.path)..writeAsBytesSync(compressedBytes);
  }

  // Compress base_64 image
  Future<String?> compressBase64Image({required String base64Image}) async {
    final originalBytes = base64Decode(base64Image);
    var compressedBytes = await FlutterImageCompress.compressWithList(
      originalBytes,
      quality: qualityCompress,
      minHeight: minHeightCompress,
      minWidth: minWidthCompress,
    );

    if (!checkCompressedImageSize(compressed: compressedBytes)) {
      minHeightCompress -= 100;
      minWidthCompress -= 100;
      qualityCompress -= 5;

      var compressFile = await compressFiles(file: File(base64Image)..writeAsBytesSync(compressedBytes));
      List<int> bytes = await compressFile!.readAsBytes();
      compressedBytes = Uint8List.fromList(bytes);
    }
    return base64Encode(compressedBytes);
  }

  //******************************************************************************
  bool checkCompressedImageSize({
    required Uint8List compressed,
  }) {
    debugPrint("compressed image size ::::: ${compressed.lengthInBytes}");
    return compressed.lengthInBytes <= 1000000;
  }

  ///*================= handle arabic numbers input ============*///

  // handle if user input english numbers convert it to arabic

  List<String> arabicNumbers = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  String convertEnglishNumbersToArabic({required String input}) {
    String result = '';
    for (int i = 0; i < input.length; i++) {
      if (input[i].contains(RegExp(r'[0-9]'))) {
        result += arabicNumbers[int.parse(input[i])];
      } else {
        result += input[i];
      }
    }
    return result;
  }

  ///* checkPromoIsPackageOrNormal *///
  bool checkPromoIfPackageOrNormalLoading = false;

  bool isPromoPackage = false;

  Future<void> checkPromoIfPackageOrNormal({
    required String promoCode,
  }) async {
    checkPromoIfPackageOrNormalLoading = true;
    emit(CheckPromoIfPackageOrNormalLoading());

    final result = await _repository.checkPromoIsPackageOrNormal(
      promoValue: promoCode,
    );

    result.fold(
      (error) {
        checkPromoIfPackageOrNormalLoading = false;
        emit(CheckPromoIfPackageOrNormalError(error: error));
      },
      (data) {
        printMeLog('----------->>> ${data.isPromoPackage}');
        isPromoPackage = data.isPromoPackage ?? false;
        checkPromoIfPackageOrNormalLoading = false;
        emit(CheckPromoIfPackageOrNormalSuccess());
      },
    );
  }

  //****************************************************************************
  String _PackagePromoCode = '';

  String get packagePromoCode => _PackagePromoCode;

  set packagePromoCode(String value) {
    _PackagePromoCode = value;
    emit(PackagePromoCodeChanged());
  }

//****************************************************************************
  ///************************* Accident Reports Details *************************//
  GetAccidentDetailsModel? accidentDetailsModel;

  bool isGetAccidentDetailsLoading = false;

  int fnolDetailsLastIndex = 0;

  void getAccidentDetails({
    required accidentId,
    bool forceRefresh = true,
    bool isFirstTime = false,
  }) async {
    isGetAccidentDetailsLoading = true;

    emit(AccidentDetailsLoading());

    final result = await _repository.getAccidentDetails(accidentId: accidentId);

    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isGetAccidentDetailsLoading = false;
        emit(
          AccidentDetailsError(
            error: failure,
          ),
        );
      },
      (data) {
        accidentDetailsModel = data;
        isGetAccidentDetailsLoading = false;
        emit(
          AccidentDetailsSuccess(),
        );
      },
    );
  }

//*************************************************************************************
// sendFnolStepPdf

  bool isSendFnolStepPdfLoading = false;

  void sendFnolStepPdf({
    required String pdfReportId,
    required String accidentId,
    required String pdf,
    required String type,
    required String carId,
  }) async {
    isSendFnolStepPdfLoading = true;

    emit(SendFnolStepPdfLoading());

    final result = await _repository.sendFnolStep(
      pdfReportId: pdfReportId,
      AccidentReportId: accidentId,
      carId: carId,
      pdfReport: pdf,
      Type: type,
    );
    result.fold(
      (failure) {
        debugPrint('-----failure------');
        debugPrint(failure.toString());
        isSendFnolStepPdfLoading = false;
        emit(
          SendFnolStepPdfError(
            error: failure,
          ),
        );
      },
      (data) {
        isSendFnolStepPdfLoading = false;
        emit(
          SendFnolStepPdfSuccess(),
        );
      },
    );
  }
}

enum ServicePaymentMethods { cash, cardToDriver, onlineCard, onlineWallet, deferred, nothing }

enum ServiceRequestStatusEnum {
  open,
  confirmed,
  canceled,
  not_available,
  accepted,
  arrived,
  started,
  done,
  pending,
  paid,
  destArrived,
  cancelWithPayment,
}

extension ServiceRequestStatusExtension on ServiceRequestStatusEnum {
  String get value {
    switch (this) {
      case ServiceRequestStatusEnum.open:
        return 'open';
      case ServiceRequestStatusEnum.confirmed:
        return 'confirmed';
      case ServiceRequestStatusEnum.canceled:
        return 'canceled';
      case ServiceRequestStatusEnum.not_available:
        return 'not_available';
      case ServiceRequestStatusEnum.accepted:
        return 'accepted'.tr;
      case ServiceRequestStatusEnum.arrived:
        return 'arrived'.tr;
      case ServiceRequestStatusEnum.started:
        return 'started'.tr;
      case ServiceRequestStatusEnum.done:
        return 'done'.tr;
      case ServiceRequestStatusEnum.pending:
        return 'pending';
      case ServiceRequestStatusEnum.paid:
        return 'paid'.tr;
      case ServiceRequestStatusEnum.destArrived:
        return 'dest_arrived'.tr;
      case ServiceRequestStatusEnum.cancelWithPayment:
        return 'cancel_with_payment'.tr;
    }
  }
}

extension PaymentMethodsExtension on ServicePaymentMethods {
  String get value {
    switch (this) {
      case ServicePaymentMethods.cash:
        return 'cash';
      case ServicePaymentMethods.cardToDriver:
        return 'card-to-driver';
      case ServicePaymentMethods.onlineCard:
        return 'online-card';
      case ServicePaymentMethods.onlineWallet:
        return 'online-wallet';
      case ServicePaymentMethods.deferred:
        return 'deferred';
      case ServicePaymentMethods.nothing:
        return 'nothing';
    }
  }
}
