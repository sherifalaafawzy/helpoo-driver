
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/network/remote/api_endpoints.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_button.dart';
import 'package:helpoo/service_request/core/util/widgets/shared_widgets/error_imge_holder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

bool isEnglish = true;

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: borderGrey,
    );
  }
}

class MyNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const MyNetworkImage({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$imagesBaseUrl$imageUrl',
      fit: fit,
      placeholder: (context, url) => Shimmer(
        gradient: _shimmerGradient,
        period: const Duration(milliseconds: 1000),
        child: Container(
          decoration: const BoxDecoration(
            gradient: _shimmerGradient,
          ),
        ),
      ),
      errorWidget: (context, url, error) => const ErrorImageHolder(),
    );
  }
}

void launchMap({required double latitude, required double longitude}) async {
  String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  if (!await launchUrl(
    Uri.parse(googleMapsUrl),
  )) {
    throw Exception(
      'Could not launch $googleMapsUrl',
    );
  }
}

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.mirror,
);
String token = '';
int userId = 0;
int currentId = 0;
String userRoleName = '';
String userName = '';
int currentCompanyId = 0;
int inspectorId = 0;
Map<String, bool> availablePayments = {};

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

double getYPosition(GlobalKey key) {
  RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);

  return position.dy;
}

double getXPosition(GlobalKey key) {
  RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);

  return position.dx;
}

const carColors = [
  'red',
  'Orange',
  'Black',
  'White',
  'Silver',
  'Brown',
  'Green',
  'Yellow',
  'Purple',
  'Gold',
  'Beige',
  'Blue',
];

// arabic letters list

const List<String> arabicLetters = [
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
  'ي',
  'ء',
];

class Keys {
  static const token = 'token';
  static const userRoleName = 'userRoleName';
  static const userName = 'userName';
  static const currentCompanyId = 'currentInsuranceCompanyId';
  static const inspectorId = 'inspectorId';
  static const availablePaymentMethods = 'availablePaymentMethods';
  static const isLogin = 'isLogin';
  static const firstTime = 'firstTime';
}

Color popUpShadow = const Color(0xff000000).withOpacity(0.36);

Color mainColorHex = HexColor(mainColor);
const String mainColor = '53A948';
const String mainColor2 = '04101B';
const Color secondary = Color.fromRGBO(5, 16, 39, 1.0);
const Color secondaryVariant = Color.fromRGBO(5, 16, 39, 0.6);
const Color secondaryGrey = Color.fromRGBO(5, 16, 39, 0.4);
const Color borderGrey = Color.fromRGBO(45, 45, 45, 0.13);

const String darkerGreyColor = '989898';
const String darkGreyColor = '67718A';
const String regularGrey = 'E9E8E7';
const String liteGreyColor = 'F9F8F7';
const Color regularBlack = Color.fromRGBO(45, 49, 66, 1.0);
const Color backgroundColor = Color(0xfff7f7f9);
const Color textColor = Color(0xff636578);
const Color textGrayColor = Color(0xffa9a1a4);
const String greenColor = '07B055';
const String blueColor = '0E72ED';
const String transparentBg = 'F2F4F7';
const Color whiteColor = Colors.white;

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

Future<void> showDeleteDialog({
  required Function function,
}) async {
  return showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    builder: (context) => Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          color: whiteColor,
        ),
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure'.tr,
              style: GoogleFonts.tajawal(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'No'.tr,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: PrimaryButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      function();
                      Navigator.pop(context);
                    },
                    text: 'Yes'.tr,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void debugPrintFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

// TranslationModel appTranslation(context) =>
//     AppBloc.get(context).translationModel;

enum TOAST { success, error, info, warning }

String appVersion = '';
String appBuildNumber = '';

IconData chooseIcon(TOAST toast) {
  late IconData iconData;

  switch (toast) {
    case TOAST.success:
      iconData = FontAwesomeIcons.check;
      break;
    case TOAST.error:
      iconData = FontAwesomeIcons.exclamation;
      break;
    case TOAST.info:
      iconData = FontAwesomeIcons.info;
      break;
    case TOAST.warning:
      iconData = FontAwesomeIcons.exclamation;
      break;
  }

  return iconData;
}

final successColor = HexColor(mainColor);
const errorColor = Colors.red;
const infoColor = Colors.blue;
const warningColor = Colors.amber;

Color chooseColor(TOAST toast) {
  late Color color;

  switch (toast) {
    case TOAST.success:
      color = successColor;
      break;
    case TOAST.error:
      color = errorColor;
      break;
    case TOAST.info:
      color = infoColor;
      break;
    case TOAST.warning:
      color = warningColor;
      break;
  }

  return color;
}

space3Vertical() => const SizedBox(
      height: 3.0,
    );

space5Vertical() => const SizedBox(
      height: 5.0,
    );

space10Vertical() => const SizedBox(
      height: 10.0,
    );

space15Vertical() => const SizedBox(
      height: 15.0,
    );

space20Vertical() => const SizedBox(
      height: 20.0,
    );

space24Vertical() => const SizedBox(
      height: 24.0,
    );

space25Vertical() => const SizedBox(
      height: 25.0,
    );

space30Vertical() => const SizedBox(
      height: 30.0,
    );

space35Vertical() => const SizedBox(
      height: 35.0,
    );

space40Vertical() => const SizedBox(
      height: 40.0,
    );

space45Vertical() => const SizedBox(
      height: 45.0,
    );

space50Vertical() => const SizedBox(
      height: 50.0,
    );

space55Vertical() => const SizedBox(
      height: 55.0,
    );

space60Vertical() => const SizedBox(
      height: 60.0,
    );

space65Vertical() => const SizedBox(
      height: 65.0,
    );

space70Vertical() => const SizedBox(
      height: 70.0,
    );

space75Vertical() => const SizedBox(
      height: 75.0,
    );

space80Vertical() => const SizedBox(
      height: 80.0,
    );

space85Vertical() => const SizedBox(
      height: 85.0,
    );

space90Vertical() => const SizedBox(
      height: 90.0,
    );

space95Vertical() => const SizedBox(
      height: 95.0,
    );

space100Vertical() => const SizedBox(
      height: 100.0,
    );

space3Horizontal() => const SizedBox(
      width: 3.0,
    );

space5Horizontal() => const SizedBox(
      width: 5.0,
    );

space10Horizontal() => const SizedBox(
      width: 10.0,
    );

space15Horizontal() => const SizedBox(
      width: 15.0,
    );

space20Horizontal() => const SizedBox(
      width: 20.0,
    );

space25Horizontal() => const SizedBox(
      width: 25.0,
    );

space30Horizontal() => const SizedBox(
      width: 30.0,
    );

space35Horizontal() => const SizedBox(
      width: 35.0,
    );

space40Horizontal() => const SizedBox(
      width: 40.0,
    );

space45Horizontal() => const SizedBox(
      width: 45.0,
    );

space50Horizontal() => const SizedBox(
      width: 50.0,
    );

space55Horizontal() => const SizedBox(
      width: 55.0,
    );

space60Horizontal() => const SizedBox(
      width: 60.0,
    );

space65Horizontal() => const SizedBox(
      width: 65.0,
    );

space70Horizontal() => const SizedBox(
      width: 70.0,
    );

space75Horizontal() => const SizedBox(
      width: 75.0,
    );

space80Horizontal() => const SizedBox(
      width: 80.0,
    );

space85Horizontal() => const SizedBox(
      width: 85.0,
    );

space90Horizontal() => const SizedBox(
      width: 90.0,
    );

space95Horizontal() => const SizedBox(
      width: 95.0,
    );

space100Horizontal() => const SizedBox(
      width: 100.0,
    );

