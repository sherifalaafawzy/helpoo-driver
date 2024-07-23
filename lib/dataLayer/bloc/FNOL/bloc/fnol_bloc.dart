// ignore_for_file: invalid_use_of_visible_for_testing_member, unused_local_variable

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:http/http.dart' as http;
import '../../../constants/variables.dart';
import '../../../models/FNOL.dart';
import '../../../models/FNOLType.dart';
import '../../../models/currentUser.dart';
import '../../../models/googleMapModel.dart';
import '../../../pluginsController/camera.dart';
import 'package:intl/intl.dart' as intl;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:google_maps_webservice/places.dart' as googlemapswebservice;

part 'fnol_event.dart';

part 'fnol_state.dart';

extension LocationExtension on gm.LatLng {
  googlemapswebservice.Location get toGoogleLocation =>
      googlemapswebservice.Location(lat: latitude, lng: longitude);
}

class FnolBloc extends Bloc<FnolEvent, FnolState> {
  FnolBloc() : super(FnolInitial()) {
    on<FnolEvent>((event, emit) {
      if (event is EmptyEvent) {
        debugPrint("EmptyEvent ================");
        emit(billLocationAdded(isSelectFromPopUp: true));
      }
    });
  }

  FNOL fnol = FNOL();

  // var appBloc;

  // void setAppBloc(context) {
  //   appBloc = BlocProvider.of<AppBloc>(context);
  // }

  void changeStateTo(FnolState value) {
    emit(value);
  }

  FNOLType fnolType = FNOLType();
  String address = "";
  LatLng? addressLatLng;
  Camera camera = Camera();
  GoogleMapsModel googleMapsModel = GoogleMapsModel();
  var x;
  bool ableToUsePicker = true;
  bool working = true;
  Position? position;
  GoogleMapController? mapController;
  CameraUpdate? cameraUpdate;
  CameraPosition? cameraPosition;
  var dir;
  bool selected = false;

  getAllAccidentTypes() async {
    FNOLType.types = await fnolType.getAllAccidentTypes();
    working = false;
    emit(GetTypes());
  }

  void CheckBox() {
    if (selected) {
      selected = false;
    } else {
      selected = true;
    }
    emit(selectedBox());
  }

  Future<Position> getLocation(type, {bool isFirstTime = true}) async {
    emit(EmptyState());
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'
              .tr);
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    cameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude), zoom: 14);
    var res2 = await GoogleMapsGeocoding(apiKey: MapApiKey).searchByLocation(
      Location(
        lat: position!.latitude,
        lng: position!.longitude,
      ),
    );
    debugPrint("res2 ================ ${MapApiKey}");
    debugPrint("res2 ================ ${res2.status}");
    debugPrint("res2 ================ ${res2.isDenied}");
    debugPrint("res2 ================ ${res2.errorMessage}");
    address = res2.results[0].formattedAddress!;

    fnol.currentAddress = address;
    // fnol.billingAddress = address;
    fnol.currentLocation = LatLng(position!.latitude, position!.longitude);

    if (type == "bill") {
      fnol.billingAddress = address;
      fnol.billingAddressLatLng =
          LatLng(position!.latitude, position!.longitude);
      emit(billLocationAdded());
    } else {
      emit(GetCurrentPosition(isFirstTime: isFirstTime));
    }

    FnolBloc().add(GetLocation(position: position!));

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<LatLng> getLatLang(String address) async {
    try {
      dir =
          await GoogleMapsGeocoding(apiKey: MapApiKey).searchByAddress(address);
      googleMapsModel.destination = LatLng(dir.results[0].geometry.location.lat,
          dir.results[0].geometry.location.lng);
      return googleMapsModel.destination!;
    } catch (e) {
      print(e.toString());
      return googleMapsModel.destination!;
    }
  }

  Future<PlacesAutocompleteResponse> searchPlace(String placeName) async {
    // printWarning('==================================');
    var res = await GoogleMapsPlaces(
      apiKey: MapApiKey,
    ).autocomplete(placeName,
        radius: 1000,
        components: [Component(Component.country, 'eg')],
        origin: Location(lat: position!.latitude, lng: position!.longitude),
        location: Location(lat: position!.latitude, lng: position!.longitude));

    // printWarning('===================${res.isDenied}');
    // printWarning('===================${res.status}');
    // printWarning('===================${res.errorMessage}');

    try {
      res.predictions.sort((a, b) => a.distanceMeters == null
          ? -1
          : b.distanceMeters == null
              ? 1
              : a.distanceMeters!.compareTo(b.distanceMeters!));
      for (var item in res.predictions) {
        // debugPrint(item.description! +
        //     " distance:" +
        //     item.distanceMeters.toString() +
        //     " meters");
        x = res.predictions;
      }
    } catch (e) {
      // debugPrint("sort predictions by distance in meters");
    }
    return res;
  }

  Future<String> convertImageToFile({
    required String image,
  }) async {
    Uint8List imageBytes = base64.decode(image);

    Uint8List compressedImage = await compressImage(
      bytes: imageBytes,
    );

    debugPrint("compressed image size: ${compressedImage.lengthInBytes}");

    return base64.encode(compressedImage);
  }

  int minHeightCompress = 1000;
  int minWidthCompress = 1000;
  int qualityCompress = 75;

  Future<Uint8List> compressImage({
    required Uint8List bytes,
  }) async {
    var compressedImageBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: minHeightCompress,
      minWidth: minWidthCompress,
      quality: qualityCompress,
    );

    if (!checkCompressedImageSize(compressed: compressedImageBytes)) {
      minHeightCompress -= 100;
      minWidthCompress -= 100;
      qualityCompress -= 5;

      compressedImageBytes = await compressImage(bytes: compressedImageBytes);
    }

    return compressedImageBytes;
  }

  bool checkCompressedImageSize({
    required Uint8List compressed,
  }) {
    return compressed.lengthInBytes <= 1000000;
  }

  uploadImageFNOL(key, path, id, extra) async {
    path = await convertImageToFile(image: path);

    var url = "${apiUrl}accidentReports/uploadImages/${id}";

    var data = {
      "images": json.encode([
        {
          "additional": extra,
          "imageName": key,
          "image": path,
        }
      ]),
    };

    try {
      var res = await http.post(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          fnol.imageCounter++;
          HelpooInAppNotification.showSuccessMessage(
              message: "Image Uploaded Successfully".tr);
          // Get.snackbar("Success".tr, "Image Uploaded Successfully".tr);
          emit(counterUpdate());
          emit(imageTake());
          getLocation('');

          return true;
        }
      } else {
        uploadImageFNOL(key, path, id, extra);
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      uploadImageFNOL(key, path, id, extra);
    }
  }

  Future<List<FNOL>> getLatest(bloc) async {
    List<FNOL> fNOLList = [];
    debugPrint("token ===>>> ${CurrentUser.token}");
    try {
      var url = "${apiUrl}accidentReports/latestReports/${CurrentUser.id}";
      var res = await http.get(Uri.parse(url), headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["reports"];
          fNOLList =
              List<FNOL>.from(I.map((fnol) => FNOL.fromJson1(fnol, bloc)));
        }
        return fNOLList;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return fNOLList;
      }
    } catch (e) {
      debugPrint(e.toString());
      return fNOLList;
    }
  }

  Future<bool> updateStatus(status, id) async {
    try {
      var url = "${apiUrl}accidentReports/updateStatus/$id";
      var data = {"status": status};

      var res = await http.patch(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          return true;
        } else {
          return false;
        }
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createFNOL(bloc) async {
    List listSelectedTypesIds = [];
    List fnols = [];

    for (var selectedType in fnol.selectedTypes) {
      listSelectedTypesIds.add(selectedType.id.toString());
    }
    var url = "${apiUrl}accidentReports";
    printWarning('accidentReports -----------------');
    printWarning('accidentReports -----------------${fnol.selectedCar!.insuranceCompany!.id}');
    // printWarning('accidentReports${json.encode(listSelectedTypesIds)}');
    var data = {
      "createdByUser": CurrentUser.userId.toString(),
      "phoneNumber": CurrentUser.phoneNumber,
      "carId": fnol.selectedCar!.id.toString(),
      "insuranceCompanyId": fnol.selectedCar!.insuranceCompany!.id.toString(),
      "accidentTypeId": json.encode(listSelectedTypesIds),
      "location": json.encode({
        "address": fnol.currentAddress,
        "lat": fnol.currentLocation!.latitude,
        "lng": fnol.currentLocation!.longitude,
      }),
    };
    try {
      var res = await http.post(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["accidentReport"];
          fnols = I.map((index) => FNOL.fromJson(index, bloc)).toList();
          HelpooInAppNotification.showSuccessMessage(
              message: "Created Successfully".tr);
          // Get.snackbar("Success".tr, "Created Successfully".tr);

          return true;
        } else {
          printWarning('accidentReports Error ===>>> ${resbody['msg']}');
        }
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return false;
  }

  Future<bool> submitBill() async {
    var url = "${apiUrl}accidentReports/submitBill/${fnol.id}";
    printWarning("fnol.billDeliveryNotes ===>>> ${fnol.billDeliveryNotes}");
    var data = {
      'billDeliveryDate':
          intl.DateFormat('yyyy/MM/dd').format(fnol.billDeliveryDate!),
      'billDeliveryTimeRange': fnol.billDeliveryTimeRange,
      'billDeliveryNotes': fnol.billDeliveryNotes,
      "billDeliveryLocation": json.encode({
        "address": fnol.billingAddress,
        "lat": fnol.billingAddressLatLng!.latitude,
        "lng": fnol.billingAddressLatLng!.longitude,
      }),
      'status': 'billing'
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
          HelpooInAppNotification.showSuccessMessage(message: "done".tr);
          // Get.snackbar("Success".tr, "done".tr);

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

  Future<bool> requestBeforeRepair() async {
    var url = "${apiUrl}accidentReports/requestBeforeRepair/${fnol.id}";

    var data = {
      "beforeRepairLocation": json.encode({
        "address": fnol.beforeRepairAddress,
        "lat": fnol.beforeRepairAddressLatLng!.latitude,
        "lng": fnol.beforeRepairAddressLatLng!.longitude,
      }),
      'status': 'bRepair',
      'bRepairName': fnol.bRepairLocation
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
          HelpooInAppNotification.showSuccessMessage(
              message: "before repair updated");
          // Get.snackbar("Success", "before repair updated");

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

  Future<bool> requestSupplement() async {
    var url = "${apiUrl}accidentReports/requestSupplement/${fnol.id}";

    var data = {
      "supplementLocation": json.encode({
        "address": fnol.supplementAddress,
        "lat": fnol.supplementAddressLatLng!.latitude,
        "lng": fnol.supplementAddressLatLng!.longitude,
        "name": fnol.supplementLocation,
      }),
      'status': 'supplement',
      // 'bRepairName': bloc.fnol.bRepairLocation
    };
    try {
      var res = await http.patch(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          HelpooInAppNotification.showSuccessMessage(
              message: "Supplement updated");
          // Get.snackbar("Success", "Supplement updated");

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

  Future<bool> requestresurvey() async {
    var url = "${apiUrl}accidentReports/requestResurvey/${fnol.id}";

    var data = {
      "resurveyLocation": json.encode({
        "address": fnol.resurveyAddress,
        "lat": fnol.resurveyAddressLatLng!.latitude,
        "lng": fnol.resurveyAddressLatLng!.longitude,
        "name": fnol.resurveyLocation,
      }),
      'status': 'resurvey',
    };
    try {
      var res = await http.patch(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          HelpooInAppNotification.showSuccessMessage(
              message: "Reinspection updated");
          // Get.snackbar("Success", "Reinspection updated");

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

  Future<bool> requestARepair() async {
    var url = "${apiUrl}accidentReports/requestAfterRepair/${fnol.id}";

    var data = {
      "afterRepairLocation": json.encode({
        "address": fnol.aRepairAddress,
        "lat": fnol.aRepairAddressLatLng!.latitude,
        "lng": fnol.aRepairAddressLatLng!.longitude,
        "name": fnol.aRepairLocation,
      }),
      'status': 'aRepair',
    };
    try {
      var res = await http.patch(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          HelpooInAppNotification.showSuccessMessage(
              message: "After Repair updated");
          // Get.snackbar("Success", "After Repair updated");

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

  Future<bool> requestRightSave() async {
    var url = "${apiUrl}accidentReports/requestRightSave/${fnol.id}";

    var data = {
      "rightSaveLocation": json.encode({
        "address": fnol.rightSaveAddress,
        "lat": fnol.rightSaveAddressLatLng!.latitude,
        "lng": fnol.rightSaveAddressLatLng!.longitude,
        "name": fnol.rightSaveLocation,
      }),
      'status': 'rightSave',
    };
    try {
      var res = await http.patch(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          HelpooInAppNotification.showSuccessMessage(
              message: "rightSave updated");
          // Get.snackbar("Success", "rightSave updated");

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

  Future<bool> requestAfterRepair() async {
    var url = "${apiUrl}accidentReports/requestAfterRepair/${fnol.id}";

    var data = {
      "afterRepairLocation": json.encode({
        "address": fnol.beforeRepairAddress ?? "",
        "lat": fnol.beforeRepairAddressLatLng!.latitude,
        "lng": fnol.beforeRepairAddressLatLng!.longitude,
      }),
      'status': 'aRepair'
    };
    try {
      var res = await http.patch(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          debugPrint('after repair done');
          HelpooInAppNotification.showSuccessMessage(
              message: "after repair updated");
          // Get.snackbar("Success", "after repair updated");

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

  updateCommentVoiceFNOL(id) async {
    var url = "${apiUrl}accidentReports/updateReport/$id";
    var data = {
      "comment": fnol.comment,
      "commentUser": fnol.mediaController.audio64 ?? "",
      "status": "created"
    };
    try {
      var res = await http.patch(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          HelpooInAppNotification.showSuccessMessage(
              message: "Comment updated");
          // Get.snackbar("Success".tr, "Done".tr);
          return true;
        }
      } else {
        updateCommentVoiceFNOL(id);
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      updateCommentVoiceFNOL(id);
    }
  }

  void sendFcm({
    required deviceToken,
  }) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'key=AAAAp3yIa4U:APA91bFTZOttVX1yxI_XIr2AWhIIdz7kEr6BgNua2XPhp9qcFXihAtE5nPxBDzHbQIYvT5bjyNPBtRtT-8ZXVa_62oTYXA0yHoArCpZFL09BpwSEIgeaplkDjNKwHvcOvssqGgmcF53s',
        },
      ),
    );

    Map<String, dynamic> body = {
      "to": deviceToken,
      "content_available": true,
      "notification": {"title": '', "body": '', "sound": "default"},
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {
        "type": "FNOL_DETAILS",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    dio
        .post(
      'fcm/send',
      data: body,
    )
        .then((value) {
      // debugPrint('fcm rest api: ${value.data}');

      emit(FcmRestApiSuccess());
    }).catchError((e) {
      debugPrint('fcm rest api error: $e');
      emit(FcmRestApiError(
        error: e,
      ));
    });
  }
}
