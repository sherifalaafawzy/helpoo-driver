import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:helpoo/dataLayer/constants/enum.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:http/http.dart' as http;
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/models/serviceReqest.dart';

class DriverRequests {
  Future<List<dynamic>> getDriverRequestsList() async {
    List<ServiceRequest> driverRequests = [];
    List<ServiceRequest> toRemove = [];
    // try {
    printWarning('Get Driver Request (Current User ID) ==>> ${CurrentUser.id}');
    var url = "${apiUrl}serviceRequest/driver/${CurrentUser.id}";
    debugPrint('Get Driver Request URL ==>> ${url}');
    var res = await http.get(Uri.parse(url), headers: {
      "authentication": "Bearer " + CurrentUser.token!,
      "accept-language": CurrentUser.language
    });
    printWarning('Get Driver Request res ${res.body}');
    var resbody;
    if (res.body.isNotEmpty) {
      resbody = json.decode(res.body);
      Iterable l = resbody['requests'];
      driverRequests = List<ServiceRequest>.from(
          l.map((model) => ServiceRequest.fromJson1(model)));

      printWarning('DriverRequests Before ==>> ${driverRequests.length}');
      driverRequests.forEach(
        (element) {
          if (element.paymentMethod == "online-card" &&
              element.paymentStatus == PaymentStatus.notPaid) {
            toRemove.add(element);
            // driverRequests.remove(element);
          }
        },
      );
      driverRequests.removeWhere((e) => toRemove.contains(e));

      printWarning('DriverRequests After ==>> ${driverRequests.length}');
      return driverRequests.toList();
    }
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
    return driverRequests.toList();
  }
}
