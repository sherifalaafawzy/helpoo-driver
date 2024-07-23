import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../dataLayer/models/currentUser.dart';

class AppLanguage extends GetxController {
  var appLocale = "ar";
   GetStorage prefs = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // getLanguage();
  }

   getLanguage() async {
    appLocale = await prefs.read("lang") ?? CurrentUser.language;
    Get.updateLocale(Locale(appLocale));
    update();
  }

  saveLanguage(String val) {
    appLocale = val;
    CurrentUser.language = val;
    prefs.write("lang", val);
    Get.updateLocale(Locale(appLocale));
  }
}
