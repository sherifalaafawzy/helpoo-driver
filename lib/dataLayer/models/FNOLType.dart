import 'dart:convert';

import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:http/http.dart' as http;

import '../constants/variables.dart';
import 'currentUser.dart';

class FNOLType {
  FNOLType();
  String? enName;
  String? arName;
  int? id;
  List<String> requiredImages = [];
  static List<FNOLType> types = [];
  String get name => (CurrentUser.language == "ar" ? arName : enName) ?? "";

  FNOLType.fromJson(data) {
    id = data['id'];
    enName = data['en_name'];
    arName = data['ar_name'];
    // requiredImages = (data['required_images'] ?? 'empty').split(',');
    requiredImages = data['requiredImages'].split(',');
  }

  Future<List<FNOLType>> getAllAccidentTypes() async {
    var url = "${apiUrl}accidentTypes";
    var res = await http.get(Uri.parse(url), headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        Iterable I = resbody["types"];
        types = List<FNOLType>.from(I.map((type) => FNOLType.fromJson(type)));
      }
      return types;
    } else {
      HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
      // Get.snackbar("Error".tr, resbody['msg']);
      return types;
    }
  }
}
