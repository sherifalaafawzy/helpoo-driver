import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:helpoo/dataLayer/models/accident_report_details_model.dart';
import 'package:helpoo/service_request/core/error/exceptions.dart';
import 'package:helpoo/service_request/core/models/check_promo_res.dart';
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
import 'package:helpoo/service_request/core/network/local/cache_helper.dart';
import 'package:helpoo/service_request/core/network/remote/api_endpoints.dart';
import 'package:helpoo/service_request/core/network/remote/dio_helper.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

abstract class Repository {
//******************************************************************************
  ///*************************** Service Request *********************************

  Future<Either<String, String>> getPaymentToken({
    required int serviceRequestId,
    required String amount,
  });

  Future<Either<String, String>> cancelServiceRequest({
    required int serviceRequestId,
  });

  Future<Either<String, ServiceRequestModel>> updateOneServiceRequest({
    required int serviceRequestId,
    required String status,
    required String paymentMethod,
    String? paymentStatus,
  });

  Future<Either<String, ServiceRequestModel>> getOneServiceRequest({
    required int serviceRequestId,
  });

  Future<Either<String, CheckServiceRequestModel>> checkServiceRequest({
    required int userId,
  });

  Future<Either<String, ServiceRequestModel>> createNewServiceRequest({
    required CreateServiceDto createServiceDto,
  });

  Future<Either<String, GetServiceReqTypes>> getServiceReqTypes();

  Future<Either<String, DriverModel>> getDriverDetails({
    required String carServiceTypeId,
    required String location,
  });

  Future<Either<String, MapPlaceModel>> searchPlace({
    required String input,
  });

  Future<Either<String, MapPlaceDetailsModel>> getPlaceDetails({
    required String placeId,
  });

  Future<Either<String, MapPlaceDetailsCoordinatesModel>> getPlaceDetailsByCoordinates({
    required String latLng,
  });

  Future<Either<String, CalculateFeesModel>> calculateServiceFees({
    required int userId,
    required int carId,
    required String destinationDistance,
    required String distance,
  });

  Future<Either<String, void>> rateRequest({
    required String reqID,
    required String rate,
    required String comment,
    required String rated,
  });

  Future<Either<String, void>> assignDriver({
    required String driverId,
    required String requestId,
  });

  Future<Either<String, void>> unAssignDriver({
    required String requestId,
  });

  Future<Either<String, VoucherModel>> addServiceRequestVoucher({
    required String voucher,
  });

  Future<Either<String, GetConfigModel>> getConfig();

  Future<Either<String, CheckPromoPackageOrNormalResponse>> checkPromoIsPackageOrNormal({
    required String promoValue,
  });

  Future<Either<String, GetAccidentDetailsModel>> getAccidentDetails({required int accidentId});

  Future<Either<String, void>> sendFnolStep({
    required String pdfReportId,
    required String AccidentReportId,
    required String carId,
    required String Type,
    required String pdfReport,
  });
}

///*****************************************************************************
class RepoImplementation extends Repository {
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  RepoImplementation({
    required this.dioHelper,
    required this.cacheHelper,
  });

  @override
  Future<Either<String, GetConfigModel>> getConfig() {
    return _basicErrorHandling<GetConfigModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          url: '$getConfigEndPoint',
        );
        // debugPrintFullText('${f.data} *******');
        return GetConfigModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  ///*************** Rate Request ***************
  @override
  Future<Either<String, String>> rateRequest({
    required String reqID,
    required String rate,
    required String comment,
    required String rated,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: '$rateRequestEndPoint',
          data: {"ServiceRequestId": "$reqID", "rating": "$rate", "comment": "$comment", "rated": "$rated"},
        );
        // debugPrintFullText('${f.data} *******');
        return f.data['status'];
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  ///*************** Assign Driver ***************
  @override
  Future<Either<String, String>> assignDriver({
    required String driverId,
    required String requestId,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: '$assignDriverEndPoint',
          data: {
            "driverId": "$driverId",
            "requestId": "$requestId",
          },
        );
        // debugPrintFullText('${f.data} *******');
        return f.data['status'];
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  ///*************** Un Assign Driver ***************
  @override
  Future<Either<String, void>> unAssignDriver({
    required String requestId,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: '$unAssignDriverEndPoint',
          data: {
            "requestId": "$requestId",
          },
        );
        // debugPrintFullText('${f.data} *******');
        return f.data['status'];
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

//******************************************************************************
  @override
  Future<Either<String, ServiceRequestModel>> updateOneServiceRequest({
    required int serviceRequestId,
    required String status,
    required String paymentMethod,
    String? paymentStatus,
  }) {
    return _basicErrorHandling<ServiceRequestModel>(
      onSuccess: () async {
        final Response f = await dioHelper.patch(
          token: token,
          url: '$updateOneServiceRequestUrl/$serviceRequestId',
          data: paymentStatus != null
              ? {
                  'status': status,
                  'paymentMethod': paymentMethod,
                  'paymentStatus': paymentStatus,
                }
              : {
                  'status': status,
                  'paymentMethod': paymentMethod,
                },
        );
        // debugPrintFullText('${f.data} *******');
        return ServiceRequestModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, String>> getPaymentToken({
    required int serviceRequestId,
    required String amount,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: getIframeUrl,
          data: {
            'serviceRequestId': serviceRequestId,
            'amount': amount,
          },
        );
        // debugPrintFullText('${f.data} *******');
        return f.data['iframe_url'];
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, ServiceRequestModel>> getOneServiceRequest({
    required int serviceRequestId,
  }) {
    return _basicErrorHandling<ServiceRequestModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          token: token,
          url: '$getOneServiceRequestUrl/$serviceRequestId',
        );
        // debugPrintFullText('${f.data} *******');
        return ServiceRequestModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, CheckServiceRequestModel>> checkServiceRequest({
    required int userId,
  }) {
    return _basicErrorHandling<CheckServiceRequestModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          token: token,
          url: '$checkServiceRequestUrl/$userId',
        );
        // debugPrintFullText('${f.data} *******');
        return CheckServiceRequestModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, String>> cancelServiceRequest({
    required int serviceRequestId,
  }) {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: '$cancelServiceRequestUrl/$serviceRequestId',
        );
        // debugPrintFullText('${f.data} *******');
        return f.data['status'];
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, ServiceRequestModel>> createNewServiceRequest({
    required CreateServiceDto createServiceDto,
  }) {
    return _basicErrorHandling<ServiceRequestModel>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: createNewServiceRequestUrl,
          data: createServiceDto.toJson(),
        );
        // debugPrintFullText('${f.data} *******');
        return ServiceRequestModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, DriverModel>> getDriverDetails({
    required String carServiceTypeId,
    required String location,
  }) {
    return _basicErrorHandling<DriverModel>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: getDriverUrl,
          data: {
            'carServiceTypeId': carServiceTypeId,
            'location': location,
          },
        );
        // debugPrintFullText('${f.data} *******');
        return DriverModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, CalculateFeesModel>> calculateServiceFees({
    required int userId,
    required int carId,
    required String destinationDistance,
    required String distance,
  }) {
    return _basicErrorHandling<CalculateFeesModel>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: calculateFeesUrl,
          data: {
            'userId': userId,
            'carId': carId,
            'destinationDistance': destinationDistance,
            'distance': distance,
          },
        );
        debugPrintFullText('${f.data} *******');
        return CalculateFeesModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

//******************************************************************************
  ///************************ Service Request *****************************

  @override
  Future<Either<String, MapPlaceModel>> searchPlace({
    required String input,
  }) async {
    return _basicErrorHandling<MapPlaceModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          base: mapUrl,
          url: getPlacesUrl,
          query: {
            'input': input,
            'key': apiKey,
            'language': isEnglish ? 'en' : 'ar',
            // 'types': 'establishment',
            // 'location': '29.994723, 31.325046',
            'components': 'country:eg',
            // 'radius': 100000,
          },
        );

        return MapPlaceModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, MapPlaceDetailsModel>> getPlaceDetails({
    required String placeId,
  }) async {
    return _basicErrorHandling<MapPlaceDetailsModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          base: mapUrl,
          url: getPlacesDetailsUrl,
          query: {
            'place_id': placeId,
            'key': apiKey,
          },
        );

        return MapPlaceDetailsModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, MapPlaceDetailsCoordinatesModel>> getPlaceDetailsByCoordinates({
    required String latLng,
  }) async {
    return _basicErrorHandling<MapPlaceDetailsCoordinatesModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          base: mapUrl,
          url: getPlacesDetailsByCoordinatesUrl,
          query: {
            'latlng': latLng,
            'key': apiKey,
          },
        );

        return MapPlaceDetailsCoordinatesModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        // debugPrint(exception.error);
        return exception.message;
      },
      onOtherError: (exception) async {
        debugPrint(exception.token);
        debugPrint(exception.title.toString());
        debugPrint(exception.error);
        return exception.token;
      },
    );
  }

  @override
  Future<Either<String, GetServiceReqTypes>> getServiceReqTypes() {
    return _basicErrorHandling<GetServiceReqTypes>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          token: token,
          url: getServiceRequestTypes,
        );
        // debugPrintFullText('${f.data} *******');
        return GetServiceReqTypes.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, VoucherModel>> addServiceRequestVoucher({required String voucher}) {
    return _basicErrorHandling<VoucherModel>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: addVoucherUrl,
          data: {
            'voucher': voucher,
          },
        );
        // debugPrintFullText('${f.data} *******');
        return VoucherModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, CheckPromoPackageOrNormalResponse>> checkPromoIsPackageOrNormal({
    required String promoValue,
  }) {
    return _basicErrorHandling<CheckPromoPackageOrNormalResponse>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          url: checkPromoPackageOrNormalEndPoint,
          data: {
            'value': promoValue,
          },
        );
        return CheckPromoPackageOrNormalResponse.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }

  @override
  Future<Either<String, GetAccidentDetailsModel>> getAccidentDetails({required int accidentId}) async {
    return _basicErrorHandling<GetAccidentDetailsModel>(
      onSuccess: () async {
        final Response f = await dioHelper.get(
          token: token,
          url: '$accidentReportsDetailsPoint/$accidentId',
        );
        debugPrintFullText('******* ::: >>> ${f.data}');
        return GetAccidentDetailsModel.fromJson(f.data);
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }
  @override
  Future<Either<String, void>> sendFnolStep({
    required String pdfReportId,
    required String AccidentReportId,
    required String carId,
    required String Type,
    required String pdfReport,
  }){
    return _basicErrorHandling<void>(
      onSuccess: () async {
        final Response f = await dioHelper.post(
          token: token,
          url: createPdfReportCombineEndPoint,
          data: {
            'pdfReportId': pdfReportId,
            'AccidentReportId': AccidentReportId,
            'carId': carId,
            'Type': Type,
            'pdfReport': pdfReport,
          },
        );
        debugPrintFullText('******* ::: >>> ${f.data}');
        return;
      },
      onServerError: (exception) async {
        debugPrint('********** onServerError **********');
        debugPrint(exception.message);
        debugPrint(exception.code.toString());
        return exception.message;
      },
    );
  }
}

extension on Repository {
  Future<Either<String, T>> _basicErrorHandling<T>({
    required Future<T> Function() onSuccess,
    Future<String> Function(ServerException exception)? onServerError,
    Future<String> Function(CacheException exception)? onCacheError,
    Future<String> Function(dynamic exception)? onOtherError,
  }) async {
    try {
      final f = await onSuccess();
      return Right(f);
    } on ServerException catch (e, s) {
      // recordError(e, s);
      debugPrint(s.toString());
      if (onServerError != null) {
        final f = await onServerError(e);
        return Left(f);
      }
      return const Left('Server Error');
    } on CacheException catch (e) {
      debugPrint(e.toString());
      if (onCacheError != null) {
        final f = await onCacheError(e);
        return Left(f);
      }
      return const Left('Cache Error');
    } catch (e, s) {
      // recordError(e, s);
      debugPrint(s.toString());
      if (onOtherError != null) {
        final f = await onOtherError(e);
        return Left(f);
      }
      return Left(e.toString());
    }
  }
}
