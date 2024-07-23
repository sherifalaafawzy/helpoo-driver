import 'dart:async';
import 'dart:convert';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../constants/variables.dart';
import 'currentUser.dart';

class FCM {
  static Future<bool> sendMessage(
      String token, String title, String body, String id, String type,
      {retryCount = 5}) async {
    if (retryCount < 0) {
      HelpooInAppNotification.showErrorMessage(
          message: "failed to send notification after 5 retries".tr);
      // Get.snackbar("Error", "failed to send notification after 5 retries");
      return false;
    }
    try {
      printWarning('SEND MESSAGE 1');
      var url = "${apiUrl}fcm/notifyMessage";

      var data = {
        "token": token,
        "title": title,
        "body": body,
        "type": type,
        "id": id
      };

      var res = await http.post(Uri.parse(url),
          body: data,
          headers: {"authentication": "Bearer " + CurrentUser.token!});
      var resbody;
      resbody = json.decode(res.body);
      printWarning('SEND MESSAGE FCM Body ==>> ${resbody}');
      printWarning('SEND MESSAGE 2');
      if (resbody['status'] == "success") {
        printWarning('SEND MESSAGE success');
        // sendMessage(token, title, body, id, type, retryCount: retryCount - 1);
        return true;
      } else {
        await Future.delayed(Duration(seconds: 5));
        sendMessage(token, title, body, id, type, retryCount: retryCount - 1);
      }
    } catch (e) {
      printWarning('SEND MESSAGE ERROR ${e}');
      debugPrint(e.toString());
      HelpooInAppNotification.showErrorMessage(message: e.toString());
      // Get.snackbar("Error", e.toString());
      await Future.delayed(Duration(seconds: 5));
      sendMessage(token, title, body, id, type, retryCount: retryCount - 1);
    }
    return false;
  }
}
