import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/app/app_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../homeScreen.dart';

class fNOLSuccess extends StatefulWidget {
  const fNOLSuccess({Key? key}) : super(key: key);

  @override
  State<fNOLSuccess> createState() => fNOLSuccessState();
}

class fNOLSuccessState extends State<fNOLSuccess> {
  bool isError = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {
        if (state is counterUpdate) {
          setState(() {
            bloc.fnol.imageCounter = bloc.fnol.imageCounter;
          });
        }
      },
      builder: (context, state) {
        if (state is imageTake ||
            state is GetCurrentPosition ||
            state is GetTypes ||
            state is counterUpdate) {
          return willPopScopeWidget(
            onWillPop: () async {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              Get.back();

              return true;
            },
            child: Scaffold(
              backgroundColor: appWhite,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: appWhite),
                backgroundColor: mainColor,
                centerTitle: true,
                title: Text(
                  "FNOL Save".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appWhite,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                leading: Container(
                  height: 48,
                  width: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        CurrentUser.isArabic
                            ? MdiIcons.arrowRightThin
                            : MdiIcons.arrowLeftThin,
                        color: appWhite,
                      ),
                    ),
                  ),
                ),
              ),
              body: SizedBox(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * .1,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        height: Get.height * .25,
                        child: Image.asset(
                          "assets/imgs/report.png",
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .06,
                      ),
                      Text(
                        "FNOL Done Successfully Uploading in Proccess".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearPercentIndicator(
                            width: Get.width * .8,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent:
                                //  0.9,
                                bloc.fnol.imageCounter >
                                        bloc.fnol.allImagesCounter
                                    ? 1
                                    : double.parse(((bloc.fnol.imageCounter /
                                                bloc.fnol.allImagesCounter *
                                                100) /
                                            100)
                                        .toString()),
                            center: Text(
                              '${(bloc.fnol.imageCounter / bloc.fnol.allImagesCounter * 100).round()}%',
                              style: TextStyle(color: Colors.white),
                            ),
                            barRadius: Radius.circular(7),
                            progressColor: mainColor,
                          ),
                        ],
                      ),
                      Text(
                          '${bloc.fnol.imageCounter}/${bloc.fnol.allImagesCounter}'),
                      Text(
                        "Uploading Percentage".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Text(
                        "FNOL #".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Text(
                        bloc.fnol.id.toString(),
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RoundButton(
                          padding: false,
                          color: Get.theme.primaryColor,
                          text: 'Done'.tr,
                          onPressed: () async {
                            setState(() {
                              bloc = FnolBloc();
                            });
                             await BlocProvider.of<AppBloc>(context).getMyCars();
                            Get.to(() => homeScreen(
                                  index: 0,
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
