import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:http/http.dart' as http;
import '../constants/variables.dart';
import 'carPackages.dart';
import 'clientPackage.dart';
import 'currentUser.dart';
import 'insuranceCompany.dart';
import 'manufactur.dart';
import 'model.dart';
import 'package.dart';

class Vehicle {
  Vehicle();

  int? id;
  bool? active;
  Manufacture? manufacture;
  Model? model;
  InsuranceCompany? insuranceCompany;
  String? color;
  int? year;
  String? plateNo;
  String? chassisNo;
  Package? package;
  List<CarPackages>? carPackages;
  ClientPackage? clientPackage;
  String policyEnd = "";
  String? frontLicense;
  String? backLicense;
  static Vehicle updatedCar = Vehicle();
  static bool anotherVehicle = false;
  static bool addVehicle = false;
  static List<Model> modelList = [];
  static Manufacture? selectedManufacturer;
  static Model? selectedModel;
  static bool returnedSelectedModel = false;
  static String? selectedName;
  static String? phone;
  static String? firstCharacter;
  static String? secondCharacter;
  static String? thirdCharacter;
  static String? selectedColor;
  static int? selectedYear;
  static List<DropdownMenuItem<int>> years = [];
  static TextEditingController plateNumberC = TextEditingController();
  static TextEditingController chassisCtrl = TextEditingController();

  static List<DropdownMenuItem<String>> get colors => List.from(colorsList.map<DropdownMenuItem<String>>((c) => DropdownMenuItem(
        value: c,
        child: Text(c.tr),
      )));

  static String get plateNumber => plateNumberC.text + "-" + (firstCharacter ?? "") + "-" + (secondCharacter ?? "") + "-" + (thirdCharacter ?? "");

  static clearVehicle() {
    Vehicle.selectedManufacturer = null;
    Vehicle.selectedModel = null;
    Vehicle.selectedYear = null;
    Vehicle.selectedColor = null;
    Vehicle.firstCharacter = "";
    Vehicle.secondCharacter = "";
    Vehicle.thirdCharacter = "";
    Vehicle.updatedCar = Vehicle();
    Vehicle.chassisCtrl = TextEditingController();
    Vehicle.plateNumberC = TextEditingController();
  }

  static clearVehiclePlate() {
    Vehicle.firstCharacter = null;
    Vehicle.secondCharacter = null;
    Vehicle.thirdCharacter = null;
   // Vehicle.plateNumberC = TextEditingController();
  }

  Vehicle.fromJson(Map json) {
    id = json['id'];
    if (json['Manufacturer'] != null) {
      manufacture = Manufacture.fromJson(json['Manufacturer']);
    }
    if (json['CarModel'] != null) {
      model = Model.fromJson(json['CarModel']);
    }
    if (json['insuranceCompany'] != null) {
      insuranceCompany = InsuranceCompany.fromJson(json['insuranceCompany']);
      policyEnd = json['policyEnds'] ?? "";
    }
    if (json['CarPackages'] != null) {
      Iterable I = json['CarPackages'];
      carPackages = List<CarPackages>.from(I.map((e) => CarPackages.fromjson(e)));
      // clientPackage =
      //     ClientPackage.fromJson(json['CarPackage']['ClientPackage']);
      // package = Package.fromJson(json['CarPackage']['Package']);
    }
    active = json['active'];
    color = json['color'];
    year = json['year'];
    chassisNo = json['vin_number'];
    plateNo = json['plateNumber'];
  }

  static Future<bool> addCar(bool vehicleRegister) async {
    var url = "${apiUrl}cars/addCar";
    var data = {
      "ManufacturerId": Vehicle.selectedManufacturer!.id.toString(),
      "CarModelId": Vehicle.selectedModel!.id.toString(),
      "year": Vehicle.selectedYear.toString(),
      "plateNumber": Vehicle.plateNumber == "---" ? "" : Vehicle.plateNumber,
      "color": Vehicle.selectedColor,
      "vin_number": Vehicle.chassisCtrl.text,
      "ClientId": CurrentUser.id.toString()
    };

    var res = await http
        .post(Uri.parse(url), body: data, headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
    var resbody;

    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        HelpooInAppNotification.showSuccessMessage(message: "Car Added Successfully".tr);
        // Get.snackbar("Done".tr, "Car Added Successfully".tr);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> updateCar(active) async {
    Vehicle.updatedCar.plateNo = Vehicle.plateNumber;
    int carId = Vehicle.updatedCar.id!;
    var url = "${apiUrl}cars/updateCar/$carId";
    var data = {
      "ManufacturerId": Vehicle.updatedCar.manufacture!.id.toString(),
      "CarModelId": Vehicle.updatedCar.model!.id.toString(),
      "year": Vehicle.updatedCar.year.toString(),
      "plateNumber": Vehicle.updatedCar.plateNo != "---" ? Vehicle.updatedCar.plateNo.toString() : "",
      "color": Vehicle.updatedCar.color.toString(),
      "vin_number": Vehicle.updatedCar.chassisNo != null ? Vehicle.updatedCar.chassisNo.toString() : "",
      "ClientId": CurrentUser.id.toString(),
      "active": active.toString(),
      "fl": Vehicle.updatedCar.frontLicense ?? "",
      "bl": Vehicle.updatedCar.backLicense ?? ""
    };

    var res = await http
        .patch(Uri.parse(url), body: data, headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        Vehicle.updatedCar.frontLicense = resbody['frontLicense'];
        Vehicle.updatedCar.backLicense = resbody['backLicense'];

        HelpooInAppNotification.showSuccessMessage(message: "Car updated Successfully".tr);
        // Get.snackbar("Helpoo".tr, "Car updated Successfully".tr);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Helpoo", resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> updateCarVinNumber({required int carId, required String vinNumber}) async {
    printWarning('updateCarVinNumber -- $carId -- $vinNumber');
    var url = "${apiUrl}cars/updateCar/$carId";
    var data = {
      "vin_number": vinNumber.toString(),
      "ClientId": CurrentUser.id.toString(),
    };

    var res = await http.patch(
      Uri.parse(url),
      body: data,
      headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language},
    );
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        HelpooInAppNotification.showSuccessMessage(message: "Car updated Successfully".tr);

        return true;
      } else {
        printWarning('updateCarVinNumber Error -- ${resbody['msg']}');
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> activateCar(active) async {
    debugPrint("active Car Start 111111111111111");

    Vehicle.updatedCar.plateNo = Vehicle.plateNumber;
    int carId = Vehicle.updatedCar.id!;

    String? fl;
    String? bl;

    if (Vehicle.updatedCar.frontLicense != null && Vehicle.updatedCar.frontLicense!.isNotEmpty) {
      fl = await sRBloc.compressBase64Image(base64Image: Vehicle.updatedCar.frontLicense ?? "");
    }

    if (Vehicle.updatedCar.backLicense != null && Vehicle.updatedCar.backLicense!.isNotEmpty) {
      bl = await sRBloc.compressBase64Image(base64Image: Vehicle.updatedCar.backLicense ?? "");
    }

    debugPrint("active Car Before Call 000000");

    var url = "${apiUrl}cars/confirmAndActivate/$carId";

    var data = {
      "ManufacturerId": Vehicle.updatedCar.manufacture!.id.toString(),
      "insuranceCompanyId": Vehicle.updatedCar.insuranceCompany != null ? Vehicle.updatedCar.insuranceCompany!.id.toString() : "",
      "CarModelId": Vehicle.updatedCar.model!.id.toString(),
      "year": Vehicle.updatedCar.year.toString(),
      "plateNumber": Vehicle.updatedCar.plateNo.toString(),
      "color": Vehicle.updatedCar.color.toString(),
      "vin_number": Vehicle.updatedCar.chassisNo.toString(),
      "clientId": CurrentUser.id.toString(),
      "active": active.toString(),
      "fl": fl ?? "",
      "bl": bl ?? "",
    };

    debugPrint("active Car Before Call 111111111111111");

    try {
      var res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "authentication": "Bearer " + CurrentUser.token!,
          // 'connection': 'keep-alive',
          "accept-language": CurrentUser.language
        },
      );

      debugPrint("active Car After Call 111111111111111");
      var resbody;

      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        debugPrint(':::::>>>>>> ${resbody['status']}');
        if (resbody['status'] == "success") {
          HelpooInAppNotification.showSuccessMessage(message: "Car updated Successfully".tr);
          // Get.snackbar("Done".tr, "Car updated Successfully".tr);
        } else {
          HelpooInAppNotification.showErrorMessage(message: "Car Not updated".tr);
          // Get.snackbar("Error".tr, "Car Not updated".tr);
        }

        return true;
      }
    } catch (e) {
      debugPrint("active Car Error 111111111111111");
      debugPrint(e.toString());

      return false;
    }

    return false;
  }
}
