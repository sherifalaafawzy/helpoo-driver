import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/widgets/main_scaffold.dart';
import 'package:helpoo/service_request/features/payment_web_view/widgets/payment_web_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({Key? key}) : super(key: key);

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  @override
  void initState() {
    super.initState();

    sRBloc.assignDriver(
      isWithTimer: false,
    );

    sRBloc.webViewController = WebViewController();
    sRBloc.isPaymentSuccess = false;
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () async {
                  sRBloc.unAssignDriver();

                  context.pop;
                },
                icon: Icon(
                  CurrentUser.isArabic
                      ? MdiIcons.arrowRightThin
                      : MdiIcons.arrowLeftThin,
                  color: whiteColor,
                ),
              ),
            ),
          ),
          title: Text(
            "Payment Process".tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.replay,
                color: whiteColor,
              ),
              onPressed: () {
                sRBloc.webViewController.reload();
              },
            ),
          ],
        ),
        body: PaymentWebViewWidget(),
      ),
    );
  }
}
