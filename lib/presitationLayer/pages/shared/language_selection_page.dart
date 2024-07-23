import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import '../../widgets/round_button.dart';
import '../../../translateApp/appLanguage.dart';

import '../../../dataLayer/constants/variables.dart';
import '../intro.dart';

class languageSelection extends StatelessWidget {
  const languageSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetStorage prefs = GetStorage();
    var cubit = BlocProvider.of<AppBloc>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appOffWhite,
        appBar: AppBar(
          backgroundColor: appOffWhite,
          actionsIconTheme: const IconThemeData(
            color: appBlack,
          ),
          elevation: 0,
          centerTitle: true,
          leading: Container(),
          title: Text(
           'choose language'.tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46.0),
                    child: SizedBox(
                      height: 84,
                      child: Image.asset('assets/imgs/newLogo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    'معاك في الطريق',
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.normal,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<AppLanguage>(
                init: AppLanguage(),
                builder: (controller) {
                  return RoundButton(
                      padding: true,
                      color: mainColor,
                      text: "English",
                      onPressed: () {
                        prefs.write("lang", "en");
                        cubit.change('en');
                        controller.saveLanguage(cubit.newLang);
                        Get.updateLocale(Locale(cubit.newLang));
                        Get.to(() => Intro());
                      });
                }),
            SizedBox(
              height: 24,
            ),
            GetBuilder<AppLanguage>(
                init: AppLanguage(),
                builder: (controller) {
                  return RoundButton(
                    padding: true,
                    color: mainColor,
                    text: "العربية",
                    onPressed: () {
                      prefs.write("lang", "ar");
                      cubit.change('ar');
                      controller.saveLanguage(cubit.newLang);
                      Get.updateLocale(Locale(cubit.newLang));
                      Get.to(() => Intro());
                    },
                  );
                }),
            SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
