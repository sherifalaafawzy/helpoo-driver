import 'dart:convert';
import 'dart:core';

import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:http/http.dart' as http;

import '../constants/variables.dart';
import 'currentUser.dart';

class Manufacture {
  int? id;
  String? enName;
  String? arName;

  Manufacture.fromJson(Map json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
  }

  String get name => (CurrentUser.isArabic ? arName : enName) ?? "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['en_name'] = this.enName ?? '';
    data['ar_name'] = this.arName ?? '';
    return data;
  }

  static Future<List<Manufacture>> getAll() async {
    List<Manufacture> manufacturs = [];
    var url = "${apiUrl}manufacturers";

    var res = await http.get(Uri.parse(url), headers: {"accept-language": CurrentUser.language});
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      if (resbody['status'] == "success") {
        Iterable I = resbody["manufacturers"];
        manufacturs = List<Manufacture>.from(I.map((manufactur) => Manufacture.fromJson(manufactur)));
      }
      return manufacturs;
    } else {
      HelpooInAppNotification.showErrorMessage(message: resbody['msg']);
      // Get.snackbar("Error".tr, resbody['msg']);
      return manufacturs;
    }
  }
}
