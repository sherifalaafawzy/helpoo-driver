import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/main.dart';

const String apiUrl = "https://$mainBaseUrl.helpooapp.net/api/v2/";
const String assetsUrl = "https://$mainBaseUrl.helpooapp.net";
int seconds = 1;

const List<String> colorsList = [
  'White',
  'Black',
  'Gray',
  'Silver',
  'Red',
  'Blue',
  'Brown',
  'Green',
  'Beige',
  'Orange',
  'Gold',
  'Yellow',
  'Purple'
];

ThemeData get appThemeData => ThemeData(
      primarySwatch: mainColor,
      primaryColor: mainColor,
      canvasColor: Colors.transparent,

      // TextFormField Theme
      // inputDecorationTheme: InputDecorationTheme(
      //   border: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: mainColor,
      //       width: 1,
      //     ),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: mainColor,
      //       width: 1,
      //     ),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: mainColor,
      //       width: 1.5,
      //     ),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: appRed,
      //       width: 1,
      //     ),
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: appRed,
      //       width: 1,
      //     ),
      //   ),
      // ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: mainColor,
        // selectionColor: mainColor,
        // selectionHandleColor: mainColor,
      ),

      useMaterial3: true,

      // fontFamily: CurrentUser.isArabic ? 'HelveticaNeue' : 'Montserrat',
      textTheme: TextTheme(
        displayLarge:
            const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.tajawal(
          textStyle: const TextStyle(
            color: mainColor,
          ),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 14.0,
        ),
      ),
      // bottomSheetTheme:
      //     BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
    );

const MaterialColor mainColor = MaterialColor(
  0xff085E25,
  <int, Color>{
    50: Color(0xff085E25),
    100: Color(0xff085E25),
    200: Color(0xff085E25),
    300: Color(0xff085E25),
    400: Color(0xff085E25),
    500: Color(0xff085E25),
    600: Color(0xff085E25),
    700: Color(0xff085E25),
    800: Color(0xff085E25),
    900: Color(0xff085E25),
  },
);
const Color appRed = Color(0xFFEF5350);
const Color appOffWhite = Color(0xfff5f5f5);
const Color appBlack = Color(0xff0a0a0a);
const Color appWhite = Color(0xffFFFFFF);
const Color appGrey = Color(0xFFE0E0E0);
const Color appDarkGrey = Color(0xFF777777);
const Color appLightGrey = Color.fromARGB(97, 239, 239, 239);
const Color iconColor = Color.fromARGB(159, 177, 217, 178);

const Color primary = Color(0xff085E25);
const Color secondary = Color(0xffFD741F);
const Color fontColor = Color(0xff333333);
const Color fontLight = Color(0xff7F848D);

const Color white = Color(0xffF8F9FB);
const Color lightBack = Color(0xffD4D8De);
const Color black = Color(0xff000000);
const Color green = Color(0xff52C462);
const Color pink = Color(0xffFB5568);
const Color yellow = Color(0xffFEA142);
const InputDecoration appInput = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
    borderSide: BorderSide(
      color: mainColor,
      width: 1,
    ),
  ),
  contentPadding: EdgeInsets.all(8),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
    borderSide: BorderSide(
      color: mainColor,
      width: 1,
    ),
  ),
);

List<String> characterSelectionItems = [
  'ا',
  'ب',
  'ت',
  'ث',
  'ج',
  'ح',
  'خ',
  'د',
  'ذ',
  'ر',
  'ز',
  'س',
  'ش',
  'ص',
  'ض',
  'ط',
  'ظ',
  'ع',
  'غ',
  'ف',
  'ق',
  'ك',
  'ل',
  'م',
  'ن',
  'ه',
  'و',
  'ى'
];

// String MapApiKey = 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc'; //prod key
// String MapApiKey = Platform.isIOS ? 'AIzaSyAnS2tif6wljUW4Lfkd5qw1PZQjAi3xeGo' : 'AIzaSyCvr7kBlfR4JwB_sOInk0UFXUGRAf9Jxio'; //test key
// String MapApiKey = Platform.isIOS ? 'AIzaSyBH1gGrzF9RxnjNlo9KwzGuv4UAA1twDug' : 'AIzaSyBH1gGrzF9RxnjNlo9KwzGuv4UAA1twDug'; //test key
String MapApiKey = Platform.isIOS ? 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc' : 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc'; //test key
