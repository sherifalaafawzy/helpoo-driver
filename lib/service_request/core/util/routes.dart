import 'package:flutter/material.dart';
import 'package:helpoo/service_request/features/payment_web_view/payment_web_view_page.dart';
import 'package:helpoo/service_request/features/service_request_map/service_request_map_page.dart';

class Routes {
  static const String serviceRequestMap = '/serviceRequestMap';
  static const String paymentWebView = '/paymentWebView';

  static Map<String, WidgetBuilder> get routes {
    return {
      serviceRequestMap: (context) => const ServiceRequestMapPage(),
      paymentWebView: (context) => const PaymentWebViewPage(),
    };
  }
}
