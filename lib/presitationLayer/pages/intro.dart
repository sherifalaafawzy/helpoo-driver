import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../dataLayer/constants/variables.dart';
import 'shared/permissonNotice.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  IntroState createState() => IntroState();
}

class IntroState extends State<Intro> {
  List<ContentConfig> slides = [];
  bool seen = false;
  late Function goToTab;
  @override
  void initState() {
    super.initState();
    // checkSelectedLanguage();
    slides.add(
      ContentConfig(
        title: "intro1_title".tr,
        styleTitle: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 26.0,
          ),
        ),
        description: "intro1_desc".tr,
        styleDescription: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 18.0,
          ),
        ),
        pathImage: "assets/imgs/intro1.png",
      ),
    );
    slides.add(
      ContentConfig(
        title: "intro2_title".tr,
        styleTitle: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 26.0,
          ),
        ),
        description: "intro2_desc".tr,
        styleDescription: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 18.0,
          ),
        ),
        pathImage: "assets/imgs/intro2.png",
      ),
    );
    slides.add(
      ContentConfig(
        title: "intro3_title".tr,
        styleTitle: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 26.0,
          ),
        ),
        description: "intro3_desc".tr,
        styleDescription: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
        ),
        pathImage: "assets/imgs/intro3.png",
      ),
    );
    slides.add(
      ContentConfig(
        title: "intro4_title".tr,
        styleTitle: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 26.0,
          ),
        ),
        description: "intro4_desc".tr,
        styleDescription: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
        ),
        pathImage: "assets/imgs/intro4.png",
      ),
    );
    slides.add(
      ContentConfig(
        title: "intro5_title".tr,
        styleTitle: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 26.0,
          ),
        ),
        description: "intro5_desc".tr,
        styleDescription: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: appBlack,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 18.0,
          ),
        ),
        pathImage: "assets/imgs/intro5.png",
      ),
    );
  }

  void onDonePress() async {
    GetStorage prefs = GetStorage();
    prefs.write("seen", "1");
    Get.to(() => PermissionsNoticePage());
  }

  void onTabChangeCompleted(index) async {}

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: appWhite,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: appWhite,
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: appWhite,
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff085E25)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0xff085E25)),
    );
  }

  List<Widget> renderListCustomTabs() {
    return List.generate(
      slides.length,
      (index) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: Column(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                child: Image.asset(
                  slides[index].pathImage!,
                  width: Get.width,
                  fit: BoxFit.contain,
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  slides[index].title!,
                  style: slides[index].styleTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 56.0),
                padding: EdgeInsets.all(16),
                child: Text(
                  slides[index].description ?? '',
                  style: slides[index].styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (seen == false) {
    //   return LanguageSelectionPage();
    // }
    return Material(
      color: Colors.white,
      child: IntroSlider(
        // Skip button
        renderSkipBtn: renderSkipBtn(),
        skipButtonStyle: myButtonStyle(),

        // Next button
        renderNextBtn: renderNextBtn(),
        nextButtonStyle: myButtonStyle(),

        // Done button
        renderDoneBtn: renderDoneBtn(),
        onDonePress: onDonePress,
        doneButtonStyle: myButtonStyle(),

        // Dot indicator
        // colorDot: const Color(0xff085E25),
        // sizeDot: 13.0,
        // typeDotAnimation: DotContentConfigrAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: renderListCustomTabs(),
        backgroundColorAllTabs: Colors.white,
        refFuncGoToTab: (refFunc) {
          goToTab = refFunc;
        },

        // Behavior
        scrollPhysics: const BouncingScrollPhysics(),

        // Show or hide status bar
        // hideStatusBar: true,

        // On tab change completed
        onTabChangeCompleted: onTabChangeCompleted,
      ),
    );
  }
}
