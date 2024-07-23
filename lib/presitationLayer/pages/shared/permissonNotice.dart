import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpoo/service_request/core/util/utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../dataLayer/constants/variables.dart';
import '../../widgets/round_button.dart';
import '../welcome.dart';

class PermissionsNoticePage extends StatelessWidget {
  build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: appWhite,
          appBar: AppBar(
            backgroundColor: appWhite,
            actionsIconTheme: IconThemeData(
              color: appBlack,
            ),
            elevation: 1,
            centerTitle: true,
            leading: SizedBox(),
            title: Text(
              'Permissions'.tr,
              style: TextStyle(
                color: mainColor,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        //                     child: Text(
                        //                       '''
                        // تقوم هلبو بجمع بيانات الموقع لتتمكن من العثور على أقرب وحدة انقاذ لتقديم خدمة المساعدة على الطريق ويتم جمع بيانات الموقع أثناء استخدام التطبيق أو اذا كان التطبيق يعمل في الخلفية
            
                        // helpoo collects location data to enable finding the nearest RSA unit. the location data is collected while the app is in use or the app is in the background.
                        // ''',
                        //                       textAlign: TextAlign.center,
                        //                     ),
                        child: Text(
                          "helpoo collects location data to enable finding the nearest RSA unit. the location data is collected while the app is in use or the app is in the background"
                              .tr,
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .08,
                      ),
                      RoundButton(
                          color: mainColor,
                          padding: true,
                          text: "confirm".tr,
                          onPressed: () async {
                            Utils.closeKeyboard(context);
                            if (!await Permission.location.isGranted) {
                              await Permission.location.request();
                            }
                            Get.offAll(() => welcome());
                          })
                    ]),
              ),
            ),
          )),
    );
  }
}
