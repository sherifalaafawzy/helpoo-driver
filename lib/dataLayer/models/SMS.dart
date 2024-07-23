import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/variables.dart';
import 'currentUser.dart';

class SMS {
  static Future<bool> sendSingleSMS(String mobile, String message) async {
    try {
      var url = "${apiUrl}sms/sendSms";

      var data = {
        "mobileNumber": mobile,
        "message": message,
      };

      var res = await http.post(Uri.parse(url), body: data, headers: {
        "authentication": "Bearer " + CurrentUser.token!,
      });

      var resbody;
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        return true;
      }

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
