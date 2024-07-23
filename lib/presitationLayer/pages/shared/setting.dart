import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpoo/dataLayer/bloc/driver/driver_cubit.dart';
import 'package:helpoo/service_request/core/di/injection.dart';
import 'package:helpoo/service_request/core/network/local/cache_helper.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import '../driverHome.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/models/driver.dart';
import '../../../translateApp/appLanguage.dart';
import '../../widgets/round_button.dart';
import '../welcome.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  final GetStorage prefs = GetStorage();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppBloc>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        body: BlocBuilder<DriverCubit, DriverState>(
  builder: (context, state) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(90),
              child: Image.asset('assets/imgs/settings.png'),
            ),
              if(CurrentUser.isDriver && driverCubit.isDriverHaveActiveRequest)...[
                Container(),
              ]else...[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: RoundButton(
                    onPressed: () async {
                      if (CurrentUser.isDriver) {
                        setState(() {
                          isLogoutLoading = true;
                        });

                        bool success = await Driver.driverLogOut();

                        if (success) {
                          CurrentUser.clearUser();

                          Get.to(() => welcome());
                          setState(() {
                            isLogoutLoading = false;
                          });
                        }
                      }
                      sl<CacheHelper>().clear('isLogin');
                      sl<CacheHelper>().clear('token');

                      CurrentUser.clearUser();
                      await logout();

                      Get.offAll(() => welcome());
                    },
                    padding: false,
                    isLoading: isLogoutLoading,
                    text: 'Logout'.tr,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: RoundButton(
                onPressed: () {
                  Get.bottomSheet(
                    Material(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: Container(
                            padding: EdgeInsets.all(16),
                            color: appWhite,
                            height: Get.height * .3,
                            child: GetBuilder<AppLanguage>(
                                init: AppLanguage(),
                                builder: (controller) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RoundButton(
                                                padding: false,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                text: "English",
                                                onPressed: () {
                                                  // prefs.write("lang", "en");
                                                  cubit.change('en');
                                                  controller.saveLanguage(
                                                      cubit.newLang);
                                                  setState(() {
                                                    CurrentUser.language =
                                                        cubit.newLang;
                                                  });
                                                  Get.updateLocale(Locale(
                                                      CurrentUser.language));

                                                  Get.changeTheme(appThemeData);

                                                  Get.back();
                                                })),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RoundButton(
                                              padding: false,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              text: "العربية",
                                              onPressed: () {
                                                cubit.change('ar');
                                                controller.saveLanguage(
                                                    cubit.newLang);
                                                // Get.updateLocale(
                                                //     Locale(cubit.newLang));

                                                Get.changeTheme(appThemeData);

                                                Get.back();
                                              }),
                                        ),
                                      ]);
                                })),
                      ),
                    ),
                  );
                },
                padding: false,
                text: "change language".tr,
                color: Theme.of(context).primaryColor,
              ),
            ),
            CurrentUser.isDriver
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: RoundButton(
                      onPressed: () async {
                        Get.to(() => DriverHome());
                      },
                      padding: false,
                      text: 'Home'.tr,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Container()
          ],
        );
  },
),
      ),
    );
  }

  bool isLogoutLoading = false;

  Future<void> logout() async {
    setState(() {
      isLogoutLoading = true;
    });
    prefs.write("userName", "");
    prefs.write("pass", "");
    CurrentUser.cars.clear();
    sl<CacheHelper>().clear(
      Keys.availablePaymentMethods,
    );
    setState(() {
      CurrentUser.isLoggedIn = false;
      isLogoutLoading = false;
    });
  }
}
