import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpoo/dataLayer/constants/enum.dart';
import 'package:helpoo/dataLayer/models/vehicle.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../../presitationLayer/widgets/driver_widgits/driverRequests.dart';
import '../../constants/variables.dart';
import '../../models/currentUser.dart';
import '../../models/serviceReqest.dart';
import 'package:location/location.dart' as loc;

part 'driver_state.dart';

DriverCubit get driverCubit => DriverCubit.get(navigatorKey.currentContext!);

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());

  static DriverCubit get(context) => BlocProvider.of(context);

  List<dynamic> driverRequests = [];
  bool success = false;
  bool showStartShoot = true;
  String currentAddress = "";
  LatLng? currentAddressLatLng;
  double? heading;
  DriverRequests driver = DriverRequests();
  ServiceRequest? req;

  bool get isDriverHaveActiveRequest {
    if (driverRequests.isNotEmpty) {
      return driverRequests.any((element) =>
          element.status != ServiceRequestStatus.done &&
          element.status != ServiceRequestStatus.canceled);
    }
    return false;
  }

  getRequests() async {
    emit(DriverGetDriverRequestsLoading());
    driverRequests = await DriverRequests().getDriverRequestsList();
    printWarning('driverRequests: ${driverRequests.length}');

    // print all requests ids and status
    driverRequests.forEach((element) {
      printWarning('request id: ${element.id} status: ${element.status}');
    });

    emit(DriverGetDriverRequests(driverRequests: driverRequests));
  }

  Future<List<dynamic>> getDriverRequestsList() async {
    List<ServiceRequest> driverRequests = [];
    List<ServiceRequest> toRemove = [];
    // try {
    var url = "${apiUrl}serviceRequest/driver/${CurrentUser.id}";
    var res = await http.get(Uri.parse(url), headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });

    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      Iterable l = resbody['requests'];
      driverRequests = List<ServiceRequest>.from(
          l.map((model) => ServiceRequest.fromJson1(model)));
      driverRequests.forEach((element) {
        if (element.paymentMethod == "online-card" &&
            element.paymentStatus == PaymentStatus.notPaid) {
          toRemove.add(element);
          // driverRequests.remove(element);
        }
      });
      driverRequests.removeWhere((e) => toRemove.contains(e));

      return driverRequests.toList();
    }
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
    return driverRequests.toList();
  }

  loc.Location location = loc.Location();

  void getLocation() async {
    // location.changeSettings(
    //   accuracy: loc.LocationAccuracy.high,
    //   interval: 1000,
    //   distanceFilter: 0,
    // );

    location.isBackgroundModeEnabled().then((value) {
      if (value == false) {
        location.enableBackgroundMode(enable: true);
      }
      debugPrint("--- background mode enabled " + value.toString());
    });

    debugPrint("--- background mode enabled " +
        location.isBackgroundModeEnabled().toString());

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('خدمات الموقع معطله');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('تم رفض صلاحيات الموقع بشكل دائم');
    }

    if (CurrentUser.isDriver) {
      if (permission == LocationPermission.always) {
        HelpooInAppNotification.showMessage(
          message: 'تفعيل الموقع الدائم',
        );
      }

      if (permission == LocationPermission.whileInUse) {
        var status = await Permission.locationAlways.request();

        if (status.isGranted) {
          //Do some stuff
          HelpooInAppNotification.showMessage(
            message: 'تفعيل الموقع الدائم',
          );
        } else {
          await Permission.locationAlways.request();

          HelpooInAppNotification.showMessage(
            message: 'برجاء تفعيل صلاحيات الموقع في الخلفية',
          );
          // Get.snackbar(
          //     "Helpoo", "please unable background location permission");
          return Future.error(
              'صلاحيات الموقع فقط أثناء الاستخدام ، ولا يمكننا طلب صلاحيات في الخلفية.');
        }
      }
    }

    // loc.LocationData locationData = await loc.Location().getLocation();

    debugPrint("--- start background mode enabled ");

    await location.onLocationChanged.listen((loc.LocationData currentLocation) {
      heading = currentLocation.heading;
      debugPrint('--- new location');
      debugPrint("driver latitude  " + currentLocation.latitude.toString());
      debugPrint("driver longitude  " + currentLocation.longitude.toString());
      debugPrint("driver heading  " + currentLocation.heading.toString());
      debugPrint("driver headingAccuracy  " +
          currentLocation.headingAccuracy.toString());

      currentAddressLatLng = LatLng(
        currentLocation.latitude ?? 0.0,
        currentLocation.longitude ?? 0.0,
      );

      // updateLocation();
      emit(UpdateLocation(success: success));
    });

    // Position position = await Geolocator.getCurrentPosition();
    // heading = position.heading;

    // var res2 = await GoogleMapsGeocoding(apiKey: MapApiKey).searchByLocation(
    //     Location(lat: position.latitude, lng: position.longitude));
    // currentAddress = res2.results[0].formattedAddress!;
  }

  Future<bool> updateLocation() async {
    try {
      var url = "${apiUrl}drivers/updateLocation/${CurrentUser.id}";

      var data = {
        "location": json.encode({
          "longitude": currentAddressLatLng!.longitude,
          "latitude": currentAddressLatLng!.latitude,
          "heading": heading.toString(),
        })
      };

      var res = await http.patch(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });

      var resbody;

      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          debugPrint('------ location updated');
          return true;
        }
      } else {
        // updateLocation();
        return false;
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      updateLocation();
    }
    return false;
  }

  Future<bool> finishRequest(request) async {
    emit(UpdateRequestLoadingStatus());
    var url = "${apiUrl}serviceRequest/finish";

    var data = {
      "driverId": CurrentUser.id.toString(),
      "requestId": request.id.toString(),
    };

    try {
      var res = await http.patch(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });

      var resbody;

      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);

        if (resbody['status'] == "success") {
          // resbody['request']['status'];
          emit(UpdateRequestSuccessStatus());

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      emit(UpdateRequestFailedStatus());
    }
    return false;
  }

  Future<bool> updateRequestStatus(request, status) async {
    if(status=="started"){
      Vehicle.plateNumberC = TextEditingController();

    }
    emit(UpdateRequestLoadingStatus());
    var url = "${apiUrl}serviceRequest/update/${request}";

    var data = {
      "status": status,
    };
    var data2 = {
      "paymentStatus": status,
    };
    try {
      var res = await http.patch(
        Uri.parse(url),
        body: (status == 'paid') ? data2 : data,
        headers: {
          "authentication": "Bearer " + CurrentUser.token!,
          "accept-language": CurrentUser.language
        },
      );

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);

        if (resbody['status'] == "success") {
          resbody['request']['status'];
          emit(UpdateRequestSuccessStatus());
          return true;
        }
      } else {
        emit(UpdateRequestFailedStatus());
        return false;
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      emit(UpdateRequestFailedStatus());
    }
    return false;
  }

  Future<bool> unAssinDriver(requestId) async {
    emit(UpdateRequestLoadingStatus());
    var url = "${apiUrl}drivers/unassignDriver";

    var data = {
      "requestId": requestId.toString(),
    };
    // try {
    var res = await http.post(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });

    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        emit(UnAssinDriver());

        return true;
      }
    } else {
      return false;
    }

    emit(UpdateRequestSuccessStatus());
    // } catch (e) {
    //   debugPrint('${e.toString()}');
    //   emit(UpdateRequestFailedStatus());
    // }
    return false;
  }

  Future<bool> driverImages(request, List<String> imgs) async {
    List<String> imgLast = [];

    var url = "${apiUrl}serviceRequest/driverImages";
    imgLast.add(imgs.last);
    var data = {
      "requestId": request.toString(),
      "images": json.encode(imgLast)
    };
    print('${apiUrl}serviceRequest/driverImages');
    print(request.toString());
    print(imgLast.toString());
    var res = await http.post(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language,
    });

    var resbody;
    if (res.body.isNotEmpty) {
      print('res.body');
      print(res.body);
      resbody = json.decode(res.body);
      debugPrintFullText('resbody');
      debugPrintFullText(resbody);
      if (resbody['status'] == "success") {
        return true;
      }
    } else {
      return false;
    }
    /* try {

    } catch (e) {
      debugPrint('${e.toString()}');
    }*/
    return false;
  }

  // check plate number validation

  bool checkPlateValidation() {
    return (Vehicle.firstCharacter != null ||
            Vehicle.secondCharacter != null ||
            Vehicle.thirdCharacter != null) &&
        Vehicle.plateNumberC.text.isNotEmpty;
  }

  Future<bool> validatePlate(request, plate) async {
    var url = "${apiUrl}serviceRequest/checkPlate";

    var data = {"requestId": request.toString(), "plateNumber": plate};
    try {
      var res = await http.post(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return false;
  }
}
