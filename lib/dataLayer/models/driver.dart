import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';

import '../constants/variables.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'currentUser.dart';

class Driver {
  Driver();
  int? id;
  String? name;
  String? phoneNumber;
  String? averageRating;
  String? fcmToken;
  int? ratingCount;
  double? lat;
  double? lng;
  String? photo;
  double? heading;

  int? fees;
  String? destinationAddress;

  Driver.fromJson(Map json) {
    id = json['id'];
    name = json['name'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    averageRating = json['averageRating'] ?? '';
    ratingCount = json['ratingCount'] ?? '';
    fcmToken = json['fcmtoken'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    photo = json['photo'] ?? '';
    if (json['heading'] != null) {
      heading = double.parse(json['heading'] ?? "");
    }
  }
  Driver.fromJson3(Map json) {
    id = json['id'];
    name = json['User']['name'] ?? 'name';
    phoneNumber = json['User']['PhoneNumber'] ?? '123456789';
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];
    fcmToken = json['fcmtoken'] ?? '12346';
    lat = json['location']['latitude'] ?? 0.0;
    lng = json['location']['longitude'] ?? 0.0;
    photo = json['User']['photo'] ??
        "https://pixinvent.com/demo/materialize-mui-react-nextjs-admin-template/demo-1/images/avatars/1.png";
  }

  static Future<bool> toggleActiveDriver(active) async {
    var url = "${apiUrl}drivers/updateStatus";
    var data = {
      "driverId": CurrentUser.id.toString(),
      "available": active ? "false" : "true"
    };

    var res = await http.patch(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;
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

  static Future<bool> setIMEIFcm(IMEI) async {
    var url = "${apiUrl}drivers/assignVehicle";
    var data = {
      "driverId": CurrentUser.id.toString(),
      "IMEI": IMEI,
      "fcmtoken": CurrentUser.fcmToken
    };

    var res = await http.post(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (res.statusCode == 200) {
        CurrentUser.phoneNumber = resbody['vehicle']['PhoneNumber'];
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error".tr, resbody['msg']);
        return false;
      }
    }
    return false;
  }

  static Future<bool> driverLogOut() async {
    var url = "${apiUrl}drivers/logOut";
    var data = {
      "driverId": CurrentUser.id.toString(),
    };

    var res = await http.post(Uri.parse(url), body: data, headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (res.statusCode == 200) {
        return true;
      } else {
        HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
        // Get.snackbar("Error", resbody['msg']);
        return false;
      }
    }
    return false;
  }
}
