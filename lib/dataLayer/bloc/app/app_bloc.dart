// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import '../../models/manufactur.dart';
import '../../models/model.dart';
import '../../models/packageBenefitsModel.dart';
import '../../models/vehicle.dart';
import '../../constants/variables.dart';
import '../../models/carServiceType.dart';
import '../../models/currentUser.dart';
import '../../models/insuranceCompany.dart';
import '../../models/package.dart';
import 'package:http/http.dart' as http;

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  StreamSubscription? subscription;

  AppBloc() : super(AppBlocInitial(lang: 'ar')) {
    on<onConnected>(((event, emit) => emit(NetworkSuccess(connected: true))));
    on<onNotConnected>(((event, emit) {
      emit(NetworkFailure(connected: false));
      emit(FetchItems(items: []));
    }));

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        add(onConnected());
      } else {
        add(onNotConnected());
      }
    });
  }

  @override
  Future<void> close() {
    subscription!.cancel();
    return super.close();
  }

  String? paymentMethod;

  String newLang = 'ar';
  bool selected = false;
  List<InsuranceCompany> insuranceCompany = [];
  List<Manufacture> allManufactur = [];
  List<Model> allModels = [];
  List<Vehicle> allVehicles = [];

  Future<List<Manufacture>> getAllManufacture() async {
    allManufactur = await Manufacture.getAll();
    emit(ManufactorLoaded(allManufactur: allManufactur));
    return allManufactur;
  }

  Future<List<Model>> getAllModels(Manufacture selectedManufactur) async {
    allModels = await Model.getAll(selectedManufactur);
    Vehicle.returnedSelectedModel = true;
    emit(ManufactorLoaded(allManufactur: allManufactur));
    return allModels;
  }

  Future<bool> addVehicle() async {
    bool success = await Vehicle.addCar(false);

    emit(AddingVehicle(allVehicles: allVehicles));
    return success;
  }

  void change(String language) {
    newLang = language;
    emit(ChangeLanguage(lang: newLang));
  }

  List<PackageBenefitsModel> packageBenefitsList = [];

  void changePackageBenefits(packageBenefits) {
    packageBenefitsList = [];
    packageBenefitsList = packageBenefits;
    emit(ChangePackageBenefits());
  }

  void CheckBox() {
    if (selected) {
      selected = false;
      emit(UnSelected());
    } else {
      selected = true;
      emit(selectedBox());
    }
  }

  Future<List<Package>> getAllPackages() async {
    List<Package> packages = [];

    debugPrint('token ==> ${CurrentUser.token}');

    try {
      var url = "${apiUrl}packages/getAll?isPublic=true";
      var res = await http.get(Uri.parse(url),
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["packages"];

          debugPrint('packages ==> $I');

          packages = List<Package>.from(I.map((type) => Package.fromJson(type)));
        }

        return packages;
      } else {
        // Get.snackbar("Error", resbody['msg']);
        return packages;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return packages;
  }

  Future<bool> subscribePackage(package, bloc) async {
    try {
      var url = "${apiUrl}packages/subscribe";
      var data = {
        "PackageId": package.id,
        "paymentMethod": bloc.paymentMethod,
        "ClientId": CurrentUser.id.toString(),
      };
      var res = await http.post(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody['package'];

          CurrentUser.packages = List<Package>.from(I.map((package) => Package.fromJson(package)));
          return true;
        } else {
          return false;
        }
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> subscribeCar(packageId, carId) async {
    try {
      var url = "${apiUrl}packages/subscribeCar";
      var data = {"packageId": packageId, "clientId": CurrentUser.id.toString(), "carId": carId.toString()};
      var res = await http.post(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          debugPrint('car subscribed ');

          return true;
        } else {
          HelpooInAppNotification.showMessage(message: resbody['msg']);
          // Get.snackbar("Helpoo", resbody['msg']);

          return false;
        }
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

  Future<bool> getMyCars() async {
    try {
      var url = "${apiUrl}cars/myCars";
      var res = await http.get(Uri.parse(url),
          // body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["cars"];
          CurrentUser.cars = List<Vehicle>.from(I.map((car) => Vehicle.fromJson(car)));
          return true;
        } else {
          return false;
        }
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future insurancePackage(insuranceCompanyId, VINNo) async {
    Vehicle? car;
    try {
      var url = "${apiUrl}cars/getCarByVINNumber";
      var data = {
        "insuranceCompanyId": insuranceCompanyId.toString(),
        "vinNo": VINNo,
        "clientId": CurrentUser.id.toString()
      };
      var res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language},
      );
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          // Iterable I = resbody["car"];
          car = Vehicle.fromJson(resbody["car"]);

          return car;
        } else {
          HelpooInAppNotification.showMessage(message: resbody['msg']);
          // Get.snackbar("Helpoo", resbody['msg']);
          // return car!;
        }
      } else {
        return car!;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // return car!;
  }

  int promoPackagePercentage = 0;
  int promoPackageID = 0;
  String PromoPackageImage = "";
  bool isPromoPackageActive = false;
  bool isPromoPackageLoading = false;

  clearPromoPackage() {
    isPromoPackageActive = false;
    promoPackagePercentage = 0;
    promoPackageID = 0;
    emit(changePromoPackage());
  }

  Future validatePromoPackage(promo) async {
    try {
      var url = "${apiUrl}packagepromo/promoWithFilter?value=$promo";

      var res = await http.get(Uri.parse(url),
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      isPromoPackageLoading = true;
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          List promoes = resbody["promoes"] as List;
          if (promoes.isNotEmpty) {
            promoPackagePercentage = promoes[0]["percentage"];
            promoPackageID = promoes[0]["id"];
            if (promoes[0]["CorporateCompany"] != null) {
              PromoPackageImage = promoes[0]["CorporateCompany"]["photo"];
            }
            isPromoPackageActive = true;
          } else {
            isPromoPackageActive = false;
            emit(updatePromoPackage());
            HelpooInAppNotification.showMessage(message: "This PromoCode is Not Valid");
          }
          emit(updatePromoPackage());
        } else {
          HelpooInAppNotification.showMessage(message: resbody['msg']);
        }
      }
      isPromoPackageLoading = false;
    } catch (e) {
      debugPrint(e.toString());
      isPromoPackageLoading = false;
    }
  }

  Future<int> usePromoPackage() async {
    int newFees = 0;
    try {
      var url = "${apiUrl}packagepromo/useOnPackage";
      var data = {
        "packageId": CurrentUser.selectedPackage.id,
        "userId": CurrentUser.userId.toString(),
        "promoId": promoPackageID.toString()
      };
      var res = await http.post(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          newFees = resbody["promo"]["fees"];
          // debugPrint("newFeeees    $newFees.  ");
        } else {
          HelpooInAppNotification.showMessage(message: resbody['msg']);
        }
        return newFees;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return newFees;
  }

  Future<List<CarServiceType>> getAllTypes() async {
    List<CarServiceType> types = [];
    try {
      var url = "${apiUrl}serviceRequest/types";
      var res = await http.get(Uri.parse(url),
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["serviceRequestsTypes"];
          types = List<CarServiceType>.from(I.map((type) => CarServiceType.fromJson(type)));
        }
        return types;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return types;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return types;
  }

  Future<bool> getInsuranceCompany() async {
    var url = "${apiUrl}insuranceCompanies";
    try {
      var res = await http.get(Uri.parse(url),
          headers: {"authentication": " Bearer ${CurrentUser.token!}", "accept-language": CurrentUser.language});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["insuranceCompanies"];
          insuranceCompany = List<InsuranceCompany>.from(I.map((request) => InsuranceCompany.fromJson(request)));
          return true;
        } else {
          HelpooInAppNotification.showMessage(message: resbody['msg']);
          // Get.snackbar("Error", resbody['msg']);
          return false;
        }
      } else {}
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return false;
  }

  Future<String> getPaymentTokenPackage() async {
    var url = "${apiUrl}paymob/getIframe";
    try {
      var data = {"packageId": CurrentUser.selectedPackage.id, "amount": CurrentUser.selectedPackage.fees.toString()};

      var res = await http.post(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});

      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          return resbody['iframe_url'];
        } else {
          HelpooInAppNotification.showMessage(message: resbody['msg']);
          return "";
        }
      } else {}
    } catch (e) {
      debugPrint('${e.toString()}');
    }
    return "";
  }

  Future<List<Package>> getActivePackages() async {
    List<Package> packages = [];
    try {
      var url = "${apiUrl}packages/clientPackages";
      var res = await http.get(Uri.parse(url),
          headers: {"authentication": "Bearer " + CurrentUser.token!, "accept-language": CurrentUser.language});
      var resbody;
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          Iterable I = resbody["clientPackages"];
          packages = List<Package>.from(I.map((package) => Package.fromJson(package)));
        }
        return packages;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return packages;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return packages;
  }

  ///* get Company Logo For Package
  ///* Priority :
  //* 1- corporate
  //* 2- insurance
  //* 3- broker
  //* 4- UsedPromosPackages => package promo code => corporate
  String getCompanyLogoForPackage({
    required Package package,
  }) {
    printWarning('getCompanyLogoForPackage');
    String logo = '';
    if (package.corporateCompany != null) {
      printWarning('photo CorporateCompany ');
      logo = package.corporateCompany!.photo ?? '';
    } else if (package.insuranceCompany != null) {
      printWarning('photo insuranceCompany ');
      logo = package.insuranceCompany?.photo ?? '';
    } else if (package.broker != null) {
      printWarning('photo broker ');
      logo = package.broker!.user?.photo ?? '';
    } else if (package.usedPromosPackages != null) {
      printWarning('photo UsedPromosPackages ');
      logo = package.usedPromosPackages!.isNotEmpty
          ? package.usedPromosPackages![0].packagePromoCode?.corporateCompany?.photo ?? ''
          : '';
    }

    return logo.isEmpty ? '' : '$assetsUrl$logo';
  }
}
