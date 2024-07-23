// ignore_for_file: invalid_use_of_visible_for_testing_member, unused_local_variable
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/places.dart' as googlemapswebservice;
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:http/http.dart' as http;
import '../../../../presitationLayer/widgets/serviceRequest/selectTowingSheet.dart';
import '../../../constants/enum.dart';
import '../../../constants/variables.dart';
import '../../../models/currentUser.dart';
import '../../../models/driver.dart';
import '../../../models/googleMapModel.dart';
import '../../../models/promoCode.dart';
import '../../../models/serviceReqest.dart';
import '../../../models/vehicle.dart';

part 'service_request_event.dart';

part 'service_request_state.dart';

extension LocationExtension on gm.LatLng {
  googlemapswebservice.Location get toGoogleLocation =>
      googlemapswebservice.Location(lat: latitude, lng: longitude);
}

class ServiceRequestBloc
    extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  ServiceRequestBloc() : super(ServiceRequestInitial()) {
    on<ServiceRequestEvent>((event, emit) {
      on<ServiceRequestObserve>(observe);
      on<StatusNotify>(_notifyStatus);
    });
  }

  void _notifyStatus(StatusNotify event, emit) {
    emit(StatusChanged());
  }

  void observe(event, emit) {
    ServiceRequestBloc().add(StatusNotify());
  }

  void changeStateTo(ServiceRequestState value) {
    emit(value);
  }

  var x;
  bool isWorking = false;
  int seconds = 5;
  String address = "";
  LatLng? destinationLatLang;
  double clientRotaion = 0;
  double driverRotaion = 0;
  bool ableToUsePicker = true;
  GoogleMapsModel googleMapsModel = GoogleMapsModel();

  pickerUsability() {
    emit(changePickerUsability());
  }

  int selectedTowingService = 1;
  var dir;

  void changeCar() {
    if (state is changeCarState) {
      emit(changeCarTwiceState());
    } else {
      emit(changeCarState());
    }
  }

  ServiceRequest request = ServiceRequest();
  PromoCode? promoCode;
  Position? position;
  GoogleMapController? mapController;
  CameraUpdate? cameraUpdate;
  CameraPosition? cameraPosition;

  var selectedPickupPlaceName = "";
  var selectedDestinationPlaceName = "";

  set selectedPlaceName(val) {
    if (request.fieldPin == MapPickerStatus.pickup) {
      selectedPickupPlaceName = val;
    } else {
      selectedDestinationPlaceName = val;
    }
  }

  get selectedPlaceName {
    return request.fieldPin == MapPickerStatus.pickup
        ? selectedPickupPlaceName
        : selectedDestinationPlaceName;
  }

  Future<Position> getLocation() async {
    debugPrint("getting current location");
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
    // rotationValue = position!.heading;
    request.clientLatitude = position!.latitude.toString();
    request.clientLongitude = position!.longitude.toString();
    cameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude), zoom: 15);
    var res2 = await GoogleMapsGeocoding(apiKey: MapApiKey).searchByLocation(
        Location(lat: position!.latitude, lng: position!.longitude));
    address = res2.results[0].formattedAddress!;
    request.clientAddress = address;
    cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition!);
    mapController?.animateCamera(cameraUpdate!);

    emit(GetMap());
    ServiceRequestBloc().add(GetLocation(position: position!));
    return position!;
  }

  Future getLocationUsingButton() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    cameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude), zoom: 15);
    cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition!);
    mapController?.animateCamera(cameraUpdate!);
  }

  Future<List<ServiceRequest>> getLatestClient() async {
    List<ServiceRequest> requests = [];
    try {
      var url = "${apiUrl}serviceRequest/latestRequests/${CurrentUser.id}";
      var res = await http.get(Uri.parse(url), headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["requests"];
          requests = List<ServiceRequest>.from(
              I.map((request) => ServiceRequest.fromJson1(request)));
        }
        return requests;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return requests;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return requests;
  }

  Future<List<ServiceRequest>> getLatestCorporate() async {
    List<ServiceRequest> requests = [];
    try {
      var url =
          "${apiUrl}serviceRequest/latestCorpRequests/${CurrentUser.userId}";
      var res = await http.get(Uri.parse(url), headers: {
        "authentication": "Bearer " + CurrentUser.token!,
        "accept-language": CurrentUser.language
      });
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["requests"];
          requests = List<ServiceRequest>.from(
              I.map((request) => ServiceRequest.fromJson1(request)));
        }
        return requests;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return requests;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return requests;
  }

  Future<void> getDirections(cubit) async {
    var pickup = position!;
    request.pickup = (request.pickup == null)
        ? LatLng(pickup.latitude, pickup.longitude)
        : request.pickup;
    request.destination = request.towingDestination;
    request.destinationDistance = await googleMapsModel.getDirectionsDetails(
        request.pickup!, request.destination);

    request.clientLatitude = request.pickup!.latitude.toString();
    request.clientLongitude = request.pickup!.longitude.toString();
    request.isWorking = false;
    await calculateTowingPrices();
    Get.bottomSheet(selectTowingSheet());
    // CarServiceType.showSelectTowingServiceDialog(cubit);
    request.isClickAble = true;
  }

  Future<LatLng> getLatLang(String address) async {
    try {
      dir =
          await GoogleMapsGeocoding(apiKey: MapApiKey).searchByAddress(address);
      googleMapsModel.destination = LatLng(dir.results[0].geometry.location.lat,
          dir.results[0].geometry.location.lng);
      cameraPosition = CameraPosition(
          target: LatLng(dir.results[0].geometry.location.lat,
              dir.results[0].geometry.location.lng),
          zoom: 15);
      cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition!);
      mapController!.animateCamera(cameraUpdate!);

      ServiceRequestBloc().add(GetLocation(position: position!));
      return googleMapsModel.destination!;
    } catch (e) {
      debugPrint(e.toString());
      return googleMapsModel.destination!;
    }
  }

  Future<PlacesAutocompleteResponse> searchPlace(String placeName) async {
    var res = await GoogleMapsPlaces(
      apiKey: MapApiKey,
    ).autocomplete(placeName,
        radius: 1000,
        components: [Component(Component.country, 'eg')],
        origin: Location(lat: position!.latitude, lng: position!.longitude),
        location: Location(lat: position!.latitude, lng: position!.longitude));

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
      debugPrint("sort predictions by distance in meters");
    }
    ServiceRequestBloc().add(GetLocation(position: position!));
    return res;
  }

  Future<String> getDriver() async {
    debugPrint('getting driver');
    var url = "${apiUrl}drivers/getDriver";
    var data = {
      "location": json.encode({
        "clientLatitude": request.pickup!.latitude,
        "clientLongitude": request.pickup!.longitude
      }),
      "carServiceTypeId": json.encode([request.selectedTowingService])
    };
    try {
      var res = await http.post(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer ${CurrentUser.token}",
        "accept-language": CurrentUser.language
      });
      debugPrint('driver is get');

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          debugPrint('driver is get');
          request.driver = Driver.fromJson(resbody['driver']);
          request.distance = resbody['distance'];

          request.distance = json.encode(resbody['distance']);
          request.distanceValue =
              json.encode(resbody['distance']['distance']['value']);
          request.distanceText =
              json.encode(resbody['distance']['distance']['text']);
          HelpooInAppNotification.showSuccessMessage(
              message: "Get Driver success".tr);
          // Get.snackbar("Success".tr, "Get Driver success".tr);
          return "Done";
        } else {
          if (resbody['msg'] == "call callcenter") {
            return "Distance";
          } else {
            HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
            // Get.snackbar("Error".tr, resbody['msg']);
          }
          return "Error";
        }
      } else {}
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return "Error";
  }

  Future<bool> driverUpdateLocation() async {
    debugPrint('getting driver');
    var url = "${apiUrl}drivers/getOne/${request.driver.id}";
    try {
      var res = await http.get(Uri.parse(url), headers: {
        "authentication": " Bearer ${CurrentUser.token!}",
        "accept-language": CurrentUser.language
      });
      debugPrint('driver is get update');

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          debugPrint('driver is get updated');

          request.driver = Driver.fromJson(resbody['driver']);
          debugPrint("kaaaaaaa   " + request.driver.heading.toString());
          return true;
        } else {
          HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
          // Get.snackbar("Error", resbody['msg']);
          return false;
        }
      } else {}
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return false;
  }

  Future<ServiceRequest> createRequest(cubit) async {
    List<ServiceRequest> requests = [];
    var url = "${apiUrl}serviceRequest/create";
    var data = {
      // "paymentMethod": request.paymentMethod,
      // "paymentStatus":
      //     request.paymentMethod == "online-card" ? "not-paid" : "pending",
      "carId": request.selectedCar!.id.toString(),
      // car id that i created
      "clientId": CurrentUser.isCorporate
          ? request.clientId.toString()
          : CurrentUser.id.toString(),
      // client id that i created
      "corporateId": CurrentUser.isCorporate ? CurrentUser.id.toString() : "",
      // my id
      "createdByUser": CurrentUser.userId.toString(),
      // my id [user id]
      'driverId': request.driver.id.toString(),
      // driver id
      "carServiceTypeId": json.encode([request.selectedTowingService]),
      // car service type id
      "distance": json.encode({
        "distance": {
          "value": request.distanceValue,
          "text": request.distanceText
        }
      }),
      // between driver and client
      "destinationDistance": json.encode({
        "distance": {"value": request.destinationDistance.distanceValue}
      }),
      // between origin and destination
      "destinationAddress": request.destinationAddress,
      // destination address [destination]
      "clientAddress": request.clientAddress,
      // client address [origin]
      "clientLatitude": request.pickup!.latitude.toString(),
      "clientLongitude": request.pickup!.longitude.toString(),
      "destinationLat": request.towingDestination!.latitude.toString(),
      "destinationLng": request.towingDestination!.longitude.toString(),
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
          request.corporateName = resbody["corporate"];
          Iterable I = resbody["request"];
          requests = List<ServiceRequest>.from(
              I.map((request) => ServiceRequest.fromJson(request, cubit)));

          HelpooInAppNotification.showSuccessMessage(message: "Created".tr);
          // Get.snackbar("Success".tr, "Created".tr);
          ableToUsePicker = false;
          request.isWorking = false;
          return requests[0];
        } else {
          HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
          // Get.snackbar("Helpoo", resbody['msg']);
        }
      } else {
        return requests[0];
      }
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return requests[0];
  }

  Future<bool> assignDrivertoRequest() async {
    var url = "${apiUrl}drivers/assignDriver";

    var data = {
      "driverId": request.driver.id.toString(),
      "requestId": request.id.toString()
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
          if (resbody['driver'] != null) {
            request.driver = Driver.fromJson(resbody['driver']);
          }
          request.vehiclePhoneNumber = resbody["vehiclePhoneNumber"];

          debugPrint('get one request status');

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

  Future<bool> changePaymentMethod() async {
    var url = "${apiUrl}serviceRequest/updatePayment";

    var data = {
      "id": request.id.toString(),
      "status": "confirmed",
      "paymentMethod": request.paymentMethod,
      "paymentStatus":
          request.paymentMethod == "online-card" ? "not-paid" : "pending",
    };
    // try {
    var res = await http.patch(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });

    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        request.status = ServiceRequestStatus.confirmed;
        ServiceRequestBloc().add(StatusNotify(status: request.status));
        emit(StatusChanged());
        return true;
      }
    } else {
      HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
      // Get.snackbar('error'.tr, resbody['msg']);
      return false;
    }
    // } catch (e) {
    //   debugPrint('${e.toString()}');
    // }
    return false;
  }

  Future<bool> confirmRequest() async {
    var url = "${apiUrl}serviceRequest/update/${request.id}";

    var data = {
      "status": "confirmed",
      "paymentMethod": request.paymentMethod,
      "paymentStatus": request.paymentMethod == "online-card"
          ? "not-paid"
          // ? request.parsePaymentStatusToString(request.paymentStatus)
          : "pending",
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
          request.status = ServiceRequestStatus.confirmed;
          ServiceRequestBloc().add(StatusNotify(status: request.status));
          emit(StatusChanged());
          return true;
        }
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar('error'.tr, resbody['msg']);
        return false;
      }
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return false;
  }

  Future<bool> calculateTowingPrices() async {
    try {
      var url = "${apiUrl}serviceRequest/calculateFees";
      var data = {
        "carId": request.selectedCar!.id.toString(),
        "distance": "",
        "userId": CurrentUser.isCorporate
            ? request.userId.toString()
            : CurrentUser.userId.toString(),
        "destinationDistance": json.encode({
          "distance": {
            "value": request.destinationDistance.distanceValue.toString(),
          }
        }),
      };
      var res = await http.post(Uri.parse(url),
          headers: {
            "authentication": "Bearer " + CurrentUser.token!,
            "accept-language": CurrentUser.language
          },
          body: data);
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          debugPrint('calculate towing prices');
          request.euroOriginalFees = resbody['EuroOriginalFees'].toString();
          request.euroFees = resbody['EuroFees'].toString();
          request.euroPercent = resbody['EuroPercent'].toString();
          request.normOriginalFees = resbody['NormOriginalFees'].toString();
          request.normFees = resbody['NormFees'].toString();
          request.normPercent = resbody['NormPercent'].toString();
        }
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Helpoo", resbody['msg']);
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> getRequest(cubit) async {
    List<ServiceRequest> requests = [];

    if (request.id != null) {
      var url = "${apiUrl}serviceRequest/getOne/${request.id}";
      try {
        var res = await http.get(Uri.parse(url), headers: {
          "authentication": "Bearer " + CurrentUser.token!,
          "accept-language": CurrentUser.language
        });
        var resbody;
        if (res.body.isNotEmpty) {
          resbody = json.decode(res.body);

          if (resbody['status'] == "success") {
            Iterable I = resbody["request"];
            requests = List<ServiceRequest>.from(
                I.map((request) => ServiceRequest.fromJson(request, cubit)));
            ServiceRequestBloc().add(StatusNotify(status: request.status));
            emit(StatusChanged());
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
    return false;
  }

  Future<bool> getActiveRequest(cubit) async {
    List<ServiceRequest> requests = [];

    var url = "${apiUrl}serviceRequest/check/${CurrentUser.id}";
    // try {
    var res = await http.get(Uri.parse(url), headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        // Iterable I = resbody["request"];
        // requests = List<ServiceRequest>.from(
        //     I.map((request) =>
        ServiceRequest.fromJson(resbody["request"], cubit);
        //  )
        //  );
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
    // } catch (e) {
    //   debugPrint('${e.toString()}');
    // }
  }

  Future<bool> rateRequest() async {
    var url = "${apiUrl}serviceRequest/commentAndRate/create";
    var data = {
      "ServiceRequestId": request.id.toString(),
      "rating": request.rating.toString(),
      "comment": request.comment ?? "",
      "rated": "true"
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
        return true;
      }
    } else {
      return false;
    }
    // } catch (e) {
    //   debugPrint('${e.toString()}');
    // }

    return false;
  }

  Future<bool> cancelRequest(request) async {
    var url = "${apiUrl}serviceRequest/cancel/${request.id}";

    // try {
    var res = await http.post(Uri.parse(url), headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });

    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Helpoo", resbody['msg']);
        return false;
      }
    } else {
      return false;
    }
    // } catch (e) {
    //   debugPrint('${e.toString()}');
    // }
  }

  Future<bool> createCorporateCar() async {
    // List<Vehicle> vehicles = [];
    var url = "${apiUrl}cars/addCar";

    var data = {
      "phoneNumber": Vehicle.phone,
      "name": Vehicle.selectedName,
      "Car": json.encode({
        "ManufacturerId": Vehicle.selectedManufacturer!.id.toString(),
        "CarModelId": Vehicle.selectedModel!.id.toString(),
        "year": Vehicle.selectedYear.toString(),
        "color": Vehicle.selectedColor,
        "plateNumber":
            Vehicle.plateNumber == "_-_-_-" ? null : Vehicle.plateNumber,
        "vin_number": Vehicle.chassisCtrl.text,
      })
    };

    var res = await http.post(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;

    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        request.selectedCar = Vehicle.fromJson(resbody['car']);
        request.clientName = resbody['user']['name'];
        request.clientPhone = resbody['user']['PhoneNumber'];
        request.clientId = resbody['user']['id'];
        request.userId = resbody['user']['userId'];
        debugPrint("Corporate Car ID ====>> ${request.selectedCar!.id!}");
        sRBloc.selectedCarId = request.selectedCar!.id!;
        sRBloc.selectedCar = request.selectedCar;
        debugPrint("Corporate Client ID ====>> ${request.clientId!}");
        sRBloc.corporateClientId = request.clientId!;
        // Get.snackbar("Done", "Create Car");
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
      // return vehicles;
    }
    return false;

    // return vehicles;
  }

  Future<void> drawLinesFromDriverToClient() async {
    BitmapDescriptor driverMarkerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        GetPlatform.isIOS
            ? "assets/imgs/tow_truck2.png"
            : "assets/imgs/tow_truck.png");
    BitmapDescriptor clientMarkerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        GetPlatform.isIOS ? "assets/imgs/car2.png" : "assets/imgs/car.png");
    var driverLatLng = LatLng(request.driver.lat!, request.driver.lng!);
    double driverHeading = request.driver.heading ?? 0.0;
    if (request.pickup == null) {
      request.pickup = LatLng(double.parse(request.clientLatitude ?? "0"),
          request.clientLongitude ?? "0");
    }

    var thisDetails = await googleMapsModel.getDirectionsDetails(
        driverLatLng, request.pickup!);
    request.driverDirectionDetails = thisDetails;
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodingPoints);
    googleMapsModel.polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng points) {
        googleMapsModel.polylineCoordinates
            .add(LatLng(points.latitude, points.longitude));
      });
    }
    googleMapsModel.polylines.clear();
    Polyline polyline = Polyline(
        polylineId: PolylineId('polylineId'),
        color: mainColor,
        points: googleMapsModel.polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true);

    googleMapsModel.polylines.add(polyline);
    LatLngBounds bounds;
    bounds = getBounds(
        LatLng(request.pickup!.latitude, request.pickup!.longitude),
        driverLatLng);

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 120));
      debugPrint("fire auto zoom");
    }
    driverRotaion = Geolocator.bearingBetween(
        driverLatLng.latitude,
        driverLatLng.longitude,
        // GoogleMapsModel.polylineCoordinates.first.latitude,
        // GoogleMapsModel.polylineCoordinates.first.longitude,
        request.pickup!.latitude,
        request.pickup!.longitude);
    clientRotaion = Geolocator.bearingBetween(
        request.pickup!.latitude,
        request.pickup!.longitude,
        // GoogleMapsModel.polylineCoordinates.last.latitude,
        // GoogleMapsModel.polylineCoordinates.last.longitude,
        driverLatLng.latitude,
        driverLatLng.longitude);
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: request.pickup!,
      icon: clientMarkerbitmap,
      rotation: clientRotaion,
      anchor: Offset(0.5, 0.5),
      infoWindow:
          InfoWindow(title: request.clientAddress, snippet: 'My Location'),
    );
    // debugPrint("heaaading     " + driverHeading.toString());
    // debugPrint("lat     " + request.driver.lat.toString());
    // debugPrint("lng     " + request.driver.lng.toString());
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: driverLatLng,
      icon: driverMarkerbitmap,
      // rotation: driverHeading,
      rotation: driverRotaion,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: 'pickup.placeName', snippet: 'Destination'),
    );
    // double rotation = _calculateRotation(request.pickup!, driverLatLng);
    // rotationValue = rotation;

    googleMapsModel.markers.add(pickupMarker);
    googleMapsModel.markers.add(destinationMarker);

    request.isWorking = false;

    ServiceRequestBloc().add(StatusNotify(status: request.status));
    if (state is StatusChanged) {
      emit(GetMap());
    } else {
      emit(StatusChanged());
    }

    // emit(GetMap());
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (x1 == null || latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (y1 == null || latLng.longitude > y1) y1 = latLng.longitude;
        if (y0 == null || latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<void> drawLinesFromDriverToDestination(cubit) async {
    BitmapDescriptor pickupMarkerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      GetPlatform.isIOS ? "assets/imgs/towing2.png" : "assets/imgs/towing.png",
    );
    BitmapDescriptor destinationMarkerbitmap =
        await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      GetPlatform.isIOS ? "assets/imgs/garage2.png" : "assets/imgs/garage.png",
    );

    double cLat = request.driver.lat!;
    double cLng = request.driver.lng!;
    double dLat;
    double dLng;
    if (request.towingDestination == null) {
      dLat = double.parse(cubit.request.destinationLatitude);
      dLng = double.parse(cubit.request.destinationLongitude);
    } else {
      dLat = request.towingDestination!.latitude;
      dLng = request.towingDestination!.longitude;
    }
    // if (  request.towingDestination == null) {
    //   dLat = double.parse(  request.destinationLatitude);
    //   dLng = double.parse(  request.destinationLongitude);
    // } else {
    //   dLat =   request.towingDestination!.latitude;
    //   dLng =   request.towingDestination!.longitude;
    // }

    var thisDetails = await googleMapsModel.getDirectionsDetails(
        LatLng(cLat, cLng), LatLng(dLat, dLng));
    request.driverDirectionDetails = thisDetails;
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodingPoints);

    googleMapsModel.polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        googleMapsModel.polylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      });
    }
    googleMapsModel.polylines.clear();
    Polyline polyLine = Polyline(
      polylineId: PolylineId('polyid'),
      color: mainColor,
      points: googleMapsModel.polylineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    googleMapsModel.polylines.add(polyLine);
    LatLngBounds bounds;

    bounds = getBounds(LatLng(cLat, cLng), LatLng(dLat, dLng));
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 120));
      debugPrint("fire auto zoom2");
    }
    driverRotaion = Geolocator.bearingBetween(cLat, cLng, dLat, dLng);

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: LatLng(cLat, cLng),
      icon: pickupMarkerbitmap,
      anchor: Offset(0.5, 0.5),
      // rotation: request.driver.heading ?? 0,
      rotation: driverRotaion,
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: LatLng(dLat, dLng),
      icon: destinationMarkerbitmap,
      anchor: Offset(0.5, 0.5),
    );

    googleMapsModel.markers.add(pickupMarker);
    googleMapsModel.markers.add(destinationMarker);

    ServiceRequestBloc().add(StatusNotify(status: request.status));
    emit(StatusChanged());
    emit(GetMap());
  }

  LatLngBounds getBounds(LatLng point1, LatLng point2) {
    double north =
        point1.latitude > point2.latitude ? point1.latitude : point2.latitude;
    double south =
        point1.latitude < point2.latitude ? point1.latitude : point2.latitude;
    double east = point1.longitude > point2.longitude
        ? point1.longitude
        : point2.longitude;
    double west = point1.longitude < point2.longitude
        ? point1.longitude
        : point2.longitude;

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(north, east),
      southwest: LatLng(south, west),
    );

    return bounds;
  }

  Future<bool> applyPromoCode(String code) async {
    var url = "${apiUrl}promoCode/assignPromo";

    var data = {
      "promoCode": code,
    };

    var res = await http.post(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;

    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        promoCode = PromoCode.fromJson(resbody['user']['promo']);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  Future<String> getPaymentTokenRequest(bloc) async {
    var url = "${apiUrl}paymob/getIframe";
    try {
      var data = {
        "serviceRequestId": bloc.request.id.toString(),
        "amount": bloc.request.fees.toString()
      };
      var res = await http.post(Uri.parse(url), body: data, headers: {
        "authentication": " Bearer ${CurrentUser.token!}",
        "accept-language": CurrentUser.language
      });

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          return resbody['iframe_url'];
        } else {
          HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
          // Get.snackbar("Error", resbody['msg']);
          return "";
        }
      } else {}
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return "";
  }

  Future<ServiceRequest> getCurrentRequest(cubit) async {
    List<ServiceRequest> requests = [];

    if (request.id != null) {
      var url = "${apiUrl}serviceRequest/getOne/${request.id}";

      try {
        var res = await http.get(Uri.parse(url), headers: {
          "authentication": "Bearer " + CurrentUser.token!,
          "accept-language": CurrentUser.language
        });

        var resbody;
        if (res.body.isNotEmpty) {
          resbody = json.decode(res.body);

          if (resbody['status'] == "success") {
            Iterable I = resbody["request"];
            requests = List<ServiceRequest>.from(
                I.map((request) => ServiceRequest.fromJson(request, cubit)));
            return requests[0];
          }
        } else {
          return requests[0];
        }
      } catch (e) {
        debugPrint('${e.toString()}');
      }
      return requests[0];
    }
    return requests[0];
  }
}
