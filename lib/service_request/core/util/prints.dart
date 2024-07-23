import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:helpoo/service_request/core/util/bloc_observer.dart';

///* Print shortcuts `print()`
void printMe(dynamic data) {
  if (kDebugMode) {
    print(data);
  }
}

///* Print in log shortcuts `log()`
void printWarning(dynamic data) {
  if (kDebugMode) {
    logger.warning(data);
  }
}

void printMeLog(dynamic data) {
  if (kDebugMode) {
    log(data, time: DateTime.now(), name: 'LOG =>> ');
  }
}
