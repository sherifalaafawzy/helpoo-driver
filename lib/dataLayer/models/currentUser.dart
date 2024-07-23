import 'dart:convert';
import 'dart:core';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpoo/service_request/core/di/injection.dart';
import 'package:helpoo/service_request/core/network/local/cache_helper.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';

import '../constants/enum.dart';
import 'package.dart';
import 'promoCode.dart';
import 'vehicle.dart';
import '../constants/variables.dart';
import 'corporate.dart';
import 'role.dart';

class CurrentUser {
  // CurrentUser(this.SRBloc, this.fnolBloc,this.appBloc);

  // final ServiceRequestBloc SRBloc;
  // final FnolBloc fnolBloc;
  // final AppBloc appBloc;
  static bool isLoggedIn = false;
  static bool working = false;
  static bool? promoVisibility = false;
  static int? id;
  static int? userId;
  static Package selectedPackage = Package();
  static String? phoneNumber;
  static String? countryCode;
  static String? userName;
  static String email = "";
  static String? password;
  static String? name;
  static bool? blocked;
  static bool? offline;
  static bool? available;
  static String? createdAt;
  static String? updatedAt;
  static String? token;
  static Corporate? corporateCompany;
  static String? iv;
  static String fcmToken = "";
  static String? otp;
  static PromoCode promoCode = PromoCode();
  static String? encryptedData;
  static String language = "ar";
  static int? roleId;
  static String? average_rating;
  static int? rating_count;
  static Role? role;
  static List<Vehicle> cars = [];
  static List<Package> packages = [];

  static bool get isArabic => CurrentUser.language == "ar";

  static bool get isEnglish => CurrentUser.language == "en";

  static bool get isClient => role == Role.client;

  static bool get isInspector => role == Role.inspector;

  static bool get isDriver => role == Role.driver;

  static bool get isCorporate => role == Role.corporate;

  static Map toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'name': name,
        'blocked': blocked,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'roleId': roleId,
      };

  static String checkPhoneNumber(phoneNum) {
    String phone = phoneNum;
    if (phone.startsWith('0')) {
      phone = phone.replaceFirst('0', '+20');
    } else if (phone.startsWith('2')) {
      phone = '+$phone';
    } else if (phone.startsWith('+')) {
      phone = phone;
    } else if (!phone.isPhoneNumber) {
      phone = phone;
    } else {
      phone = '+20$phone';
    }
    return phone;
  }

  // static String checkPhoneNumber(String val) {
  //   bool success = val.startsWith("00", 2) || val.startsWith("0", 2);
  //   if (success) {
  //     val = val!.replaceFirst("00", "0");
  //   }
  //   return val;
  // }

  static Future<bool> applyPromoCode(String code) async {
    // List<Vehicle> vehicles = [];
    var url = "${apiUrl}promoCode/assignPromo";

    var data = {
      "promoCode": code,
    };

    var res = await http.post(Uri.parse(url),
        body: data,
        headers: {"authentication": "Bearer " + CurrentUser.token!});
    var resbody;
    debugPrint('applyPromoCode res :: ${res.body}');
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      if (resbody['status'] == "success") {
        promoCode = PromoCode.fromJson(resbody['user']['promo']);
        CurrentUser.promoVisibility = true;
        return true;
      } else {
        // Get.snackbar("Error".tr, "promoCodeError".tr);
        if (resbody['msg'] == 'You are using this promo') {
          printWarning('===>>> You are using this promo');
          HelpooInAppNotification.showErrorMessage(
              message: (resbody['msg'] as String).tr);
          // Get.snackbar("Error".tr, (resbody['msg'] as String).tr);
        } else {
          CurrentUser.promoVisibility = false;
          printWarning('===>>> promoCodeError 22');
          HelpooInAppNotification.showErrorMessage(
              message: "promoCodeError".tr);
          // Get.snackbar("Error".tr, "promoCodeError".tr);
        }
        return false;
      }
    }
    return false;
  }

  CurrentUser.fromJson(Map json) {
    CurrentUser.id = json['id'];
    CurrentUser.userId = json['UserId'];
    CurrentUser.phoneNumber = json['PhoneNumber'];
    CurrentUser.email = json['email'] ?? "";
    CurrentUser.name = json['name'];
    CurrentUser.userName = json['username'];
    CurrentUser.blocked = json['blocked'];
    CurrentUser.roleId = json['roleId'];
    if (json['package'] != []) {
      Iterable I = json['packages'];
      CurrentUser.packages =
          List<Package>.from(I.map((package) => Package.fromJson(package)));
      // debugPrintFullText(
      //     'packages ::======>>>>>>> ${CurrentUser.packages[0].toJson()}');
    }
    CurrentUser.role = parseRole(json['RoleName']);
    if (json['activePromoCode'] != null)
      CurrentUser.promoCode = PromoCode.fromJson(json['activePromoCode']);
  }

  CurrentUser.fromJson1(Map json) {
    CurrentUser.iv = json['iv'] ?? '';
    CurrentUser.encryptedData = json['encryptedData'] ?? '';
  }

  CurrentUser.fromJson2(Map json) {
    CurrentUser.id = json['id'] ?? 0;
    CurrentUser.userId = json['userId'] ?? 0;
    CurrentUser.userName = json['username'] ?? '';
    CurrentUser.phoneNumber = json['PhoneNumber'] ?? '';
    CurrentUser.email = json['email'] ?? "";
    CurrentUser.name = json['name'] ?? '';
    CurrentUser.blocked = json['blocked'];
    CurrentUser.roleId = json['roleId'];
    CurrentUser.average_rating = json['average_rating'];
    CurrentUser.offline = json['offline'];
    CurrentUser.available = json['available'];
    CurrentUser.rating_count = json['rating_count'];
    CurrentUser.available = json['available'];
    CurrentUser.role = parseRole(json['RoleName'] ?? '');
    // CurrentUser.promoCode = PromoCode.fromJson(json['activePromoCode']);
    printWarning('===>>> CurrentUser.fromJson2 ${CurrentUser.id}');
  }

  CurrentUser.fromJson3(Map json) {
    CurrentUser.id = json['id'];
    CurrentUser.userName = json['username'] ?? '';
    CurrentUser.userId = json['UserId'] ?? '';
    CurrentUser.name = json['name'] ?? '';
    CurrentUser.corporateCompany = Corporate.fromJson(json['CorporateCompany']);
    CurrentUser.phoneNumber = json['PhoneNumber'] ?? "";
    CurrentUser.email = json['email'] ?? "";
    CurrentUser.blocked = json['blocked'];
    CurrentUser.roleId = json['RoleId'];
    CurrentUser.role = parseRole(json['RoleName']);
  }

  CurrentUser.fromJson4(Map json) {
    CurrentUser.name = json['name'] ?? '';
    CurrentUser.email = json['email'] ?? '';
  }

  CurrentUser.fromJson5(Map json) {
    CurrentUser.id = json['id'];
    CurrentUser.userId = json['UserId'];
    CurrentUser.phoneNumber = json['PhoneNumber'];
    CurrentUser.email = json['email'] ?? "";
    CurrentUser.name = json['name'] ?? '';
    CurrentUser.userName = json['username'];
    CurrentUser.blocked = json['blocked'];
    CurrentUser.roleId = json['roleId'];
    CurrentUser.role = parseRole(json['RoleName']);
    // if (json['activePromoCode'] != null)
    //   CurrentUser.promoCode = PromoCode.fromJson(json['activePromoCode']);
  }

  static clearUser() {
    CurrentUser.id = 0;
    CurrentUser.phoneNumber = '';
    CurrentUser.email = '';
    CurrentUser.password = '';
    CurrentUser.name;
    CurrentUser.blocked = false;
    CurrentUser.createdAt = '';
    CurrentUser.updatedAt = '';
    CurrentUser.roleId = 0;
    CurrentUser.promoCode = PromoCode();
    CurrentUser.isLoggedIn = false;
  }

  static Future<bool> userSignUp() async {
    var url = "${apiUrl}users/signup";
    var data = {
      'identifier': CurrentUser.userName,
      'password': CurrentUser.password,
      'name': CurrentUser.name,
      // 'promoCode': CurrentUser.promoCode.value,
    };

    var res = await http.post(Uri.parse(url), body: data);
    var resbody;

    debugPrint('body :: ${res.body}');
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      debugPrintFullText('Register Body :: ${resbody}');
    }
    if (resbody['status'] == "success") {
      CurrentUser.fromJson5(resbody['user']);
      sl<CacheHelper>().put(Keys.isLogin, true);
      sl<CacheHelper>().put(Keys.token, resbody['token']);
      CurrentUser.token = resbody['token'];
      // printWarning('===>>> promoCode ${resbody['user']['activePromoCode']}');
      // printWarning(
      //     '===>>> promoCode 22 ${CurrentUser.promoCode.id ?? '------'}');
      // if (CurrentUser.promoCode.id == null) {
      //   printWarning('===>>> promoCodeError 11');
      //   HelpooInAppNotification.showErrorMessage(message: "promoCodeError".tr);
      // }

      // if (CurrentUser.promoCode.id == null) {
      //   HelpooInAppNotification.showErrorMessage(message: "promoCodeError".tr);
      // }
      // Get.snackbar("Success", "User Created".tr);
      if (CurrentUser.blocked == false) {
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: "You are Blocked".tr);
        // Get.snackbar("Error", "You are Blocked".tr);
        return false;
      }
    } else if (resbody['status'] == 2) {
      HelpooInAppNotification.showErrorMessage(message: "Something Wrong".tr);
      return false;
    }
    return false;
  }

  static Future<String> userSignIn() async {
    CurrentUser.fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

    debugPrint('CurrentUser.fcmToken :: ${CurrentUser.fcmToken}');

    var url = "${apiUrl}users/login";

    debugPrint('login url :: ${url}');
    String? IMEI;
    if (GetPlatform.isAndroid) {
      // IMEI = await UniqueIdentifier.serial;
      // IMEI = androidDeviceInfo.id;
      IMEI = await PlatformDeviceId.getDeviceId;
    }
    debugPrint('IMEI :: ${IMEI}');
    debugPrint('CurrentUser.phoneNumber 1:: ${CurrentUser.userName}');
    CurrentUser.userName = checkPhoneNumber(CurrentUser.userName);
    debugPrint('CurrentUser.phoneNumber 2:: ${CurrentUser.userName}');

    var data = {
      "identifier": CurrentUser.userName,
      "password": CurrentUser.password,
      "fcmtoken": CurrentUser.fcmToken,
      "IMEI": IMEI ?? "",
      // "IMEI": '123456789',
    };
    debugPrint('data :: ${data}');
    try {
      var res = await http.post(Uri.parse(url),
          body: data, headers: {"accept-language": CurrentUser.language});
      var resbody;
      debugPrintFullText('body userSignIn ::>>> ${res.body}');
      if (res.body.isNotEmpty) {
        resbody = json.decode(res.body);
        if (resbody['status'] == "success") {
          CurrentUser.token = resbody['token'];
          sl<CacheHelper>().put(Keys.token, resbody['token']);
          sl<CacheHelper>().put(Keys.isLogin, true);
          // FirebaseMessaging.instance
          //     .getToken()
          //     .then((value) => {CurrentUser.fcmToken = value ?? ''});
          if (resbody['user']["RoleName"] == "Driver") {
            debugPrintFullText('Driver *************');
            CurrentUser.fromJson2(resbody['user']);
          } else if (resbody['user']["RoleName"] == "Corporate") {
            CurrentUser.fromJson3(resbody['user']);

            ///********** Available Payment Methods For Corporate *************///
            availablePayments = {
              'cash': resbody['user']["CorporateCompany"]["cash"],
              'deferredPayment': resbody['user']["CorporateCompany"]
                  ["deferredPayment"],
              'cardToDriver': resbody['user']["CorporateCompany"]
                  ["cardToDriver"],
              'online': resbody['user']["CorporateCompany"]["online"],
            };
            sl<CacheHelper>()
                .put(Keys.availablePaymentMethods, availablePayments);

            debugPrintFullText('availablePayments ===>> ${availablePayments}');
          } else {
            CurrentUser.fromJson(resbody['user']);

            Iterable I = resbody["cars"];
            CurrentUser.cars =
                List<Vehicle>.from(I.map((car) => Vehicle.fromJson(car)));
          }
          if (CurrentUser.blocked == false) {
            return "Done";
          } else {
            return "Blocked";
          }
        } else {
          HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
          return "error";
        }
      } else {
        HelpooInAppNotification.showErrorMessage(message: "Something Wrong".tr);
        return "3";
      }
    } catch (e) {
      HelpooInAppNotification.showErrorMessage(message: "Something Wrong".tr);
      debugPrint('error :: ${e}');
    }
    return '3';
  }

  static Future<String> checkExist() async {
    var url = "${apiUrl}users/checkExist";

    CurrentUser.phoneNumber = checkPhoneNumber(CurrentUser.phoneNumber);
    // CurrentUser.phoneNumber =
    //     CurrentUser.phoneNumber!.replaceAll(CurrentUser.countryCode!, "0");
    debugPrint(CurrentUser.phoneNumber);

    var data = {
      "PhoneNumber": checkPhoneNumber(CurrentUser.phoneNumber),
      "countryCode": CurrentUser.countryCode,
    };

    var res = await http.post(Uri.parse(url), body: data);
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);

      debugPrint('resbody :: ${resbody}');

      if (resbody["status"] == 1) {
        // normal client
        // Get.snackbar("Helpoo", 'welcome to helpoo');
        return "1";
      } else if (resbody["status"] == 2) {
        // corporate client active = true
        // Get.snackbar("Error".tr, 'User already exist');
        return "2";
      } else if (resbody["status"] == 3) {
        // insurance client active =false
        // Get.snackbar("Error".tr, 'Your account isn\'t activated yet');
        return "3";
      }
    }
    return "";
  }

  static Future<bool> sendOTP() async {
    var url = "${apiUrl}sms/sendOTP";
    CurrentUser.phoneNumber = checkPhoneNumber(CurrentUser.phoneNumber);
    debugPrint(CurrentUser.phoneNumber);

    var data = {
      "mobileNumber": CurrentUser.phoneNumber,
    };

    var res = await http.post(Uri.parse(url),
        body: data, headers: {"accept-language": CurrentUser.language});
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (res.statusCode == 200) {
        CurrentUser.fromJson1(resbody['message']);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> updateUser() async {
    var url = "${apiUrl}users/updateMe";
    var data = {
      "name": CurrentUser.name,
      "email": CurrentUser.email,
      "password": CurrentUser.password,
    };

    var res = await http.patch(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });

    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (res.statusCode == 200) {
        // CurrentUser.fromJson1(resbody['message']);
        HelpooInAppNotification.showSuccessMessage(
          message: 'Profile Updated Successfully'.tr,
        );

        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> getUser() async {
    var url = "${apiUrl}users/me";

    var res = await http.get(Uri.parse(url), headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        CurrentUser.fromJson4(resbody['user']);
        // CurrentUser.fromJson1(resbody['message']);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> resetPass() async {
    var url = "${apiUrl}users/forgotPassword";
    debugPrint("1111     " + CurrentUser.phoneNumber!);
    CurrentUser.phoneNumber = checkPhoneNumber(CurrentUser.phoneNumber);
    debugPrint("22222    " + CurrentUser.phoneNumber!);
    // CurrentUser.phoneNumber =
    //     CurrentUser.phoneNumber!.replaceAll(CurrentUser.countryCode!, "0");
    debugPrint("CurrentUser.phoneNumber" + CurrentUser.phoneNumber!);
    var data = {
      "identifier": checkPhoneNumber(CurrentUser.phoneNumber),
      // "countryCode": CurrentUser.countryCode,
    };
    var res = await http.post(Uri.parse(url),
        body: data, headers: {"accept-language": CurrentUser.language});
    var resbody;
    debugPrint('body :: ' + res.body);
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        CurrentUser.fromJson1(resbody['message']);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> verifyOTP() async {
    debugPrintFullText('======= verifyOTP ============');
    var url = "${apiUrl}sms/verifyOTP";
    CurrentUser.phoneNumber = checkPhoneNumber(CurrentUser.phoneNumber);
    debugPrint(CurrentUser.phoneNumber);

    var data = {
      "message": json.encode(
          {"iv": CurrentUser.iv, "encryptedData": CurrentUser.encryptedData}),
      "otp": CurrentUser.otp,
      "mobileNumber": CurrentUser.phoneNumber
    };

    var res = await http.post(Uri.parse(url),
        body: data, headers: {"accept-language": CurrentUser.language});
    var resbody;
    debugPrintFullText('OTP Response Body ==>> ${json.decode(res.body)}');
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (res.statusCode == 200) {
        CurrentUser.fromJson1(resbody['message']);
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> newPass() async {
    var url = "${apiUrl}users/resetPassword";
    CurrentUser.phoneNumber = checkPhoneNumber(CurrentUser.phoneNumber);
    CurrentUser.userName = checkPhoneNumber(CurrentUser.phoneNumber);
    debugPrint(CurrentUser.phoneNumber);

    var data = {
      "identifier": CurrentUser.phoneNumber,
      "newPassword": CurrentUser.password
    };

    var res = await http.post(Uri.parse(url),
        body: data, headers: {"accept-language": CurrentUser.language});
    var resbody;
    debugPrint('body newPass:: ' + res.body);
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (res.statusCode == 200) {
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }
}
