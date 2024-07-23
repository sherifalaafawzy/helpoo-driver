import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/constants/enum.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewWidget extends StatefulWidget {
  const PaymentWebViewWidget({Key? key}) : super(key: key);

  @override
  State<PaymentWebViewWidget> createState() => _PaymentWebViewWidgetState();
}

class _PaymentWebViewWidgetState extends State<PaymentWebViewWidget> {
  @override
  void initState() {
    super.initState();

    sRBloc.webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            debugPrint('WebView is loading (progress : $progress%)');

            if (progress < 100) {
              sRBloc.isPaymentLoading = true;
            } else {
              sRBloc.isPaymentLoading = false;
            }
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading');
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://$mainBaseUrl.helpooapp.net/api/v2/paymob/callback')) {
              debugPrint('blocking navigation to ${request.url}');

              // return NavigationDecision.prevent;

              sRBloc.onlinePaymentSuccess();
              startTimer();
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(sRBloc.IFrameUrl));
  }

  Timer? timer;
  late int currentTime = 10;

  startTimer() async {
    if (currentTime == 10) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentTime != 1) {
          if (mounted) {
            setState(() {
              currentTime = currentTime - 1;
            });
          }
        } else {
          stopTimer();
          sRBloc.getCurrentActiveServiceRequest(
              fromIframe: true,
              reqID: sRBloc.serviceRequestModel!.serviceRequestDetails.id);

          if (sRBloc.serviceRequestModel != null) {
            // sRBloc.getCurrentServiceRequestStatus();
          }
        }
      });
    }
  }

  stopTimer() {
    currentTime = 10;
    timer!.cancel();
  }

  @override
  void dispose() {
    super.dispose();

    if (timer != null) {
      stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
      listener: (context, state) {
        if (state is GetCurrentActiveServiceRequestSuccessState) {
          if (state.fromIframe) {
            debugPrint('===>> Payment Status');
            debugPrintFullText(
                '${sRBloc.serviceRequestModel?.serviceRequestDetails.paymentStatus}');
            if (sRBloc
                    .serviceRequestModel?.serviceRequestDetails.paymentStatus ==
                PaymentStatus.paid.name) {
              debugPrint('===>> Payment Success');
              context.pushNamedAndRemoveUntil = Routes.serviceRequestMap;
              //TODO flag
              sRBloc.updateServiceRequest();
            } else {
              debugPrint('===>> Payment Failed ==>> getIFrameUrl');
              sRBloc.getIFrameUrl();
              context.pop;
            }
          }
        }
        // if (state is GetIFrameUrlSuccessState) {
        //   context.pop;
        //   // sRBloc.webViewController.clearCache();
        //   // sRBloc.webViewController.loadRequest(Uri.parse(sRBloc.IFrameUrl));
        //   context.pushNamed = Routes.paymentWebView;
        // }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (sRBloc.isPaymentSuccess) space40Vertical(),
            if (sRBloc.isPaymentSuccess)
              PrimaryPadding(
                child: Text(
                  'سيتم تحويلك للتطبيق مرة اخري خلال $currentTime ثانية',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: secondary,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            if (!sRBloc.isPaymentLoading)
              Expanded(
                child: WebViewWidget(
                  controller: sRBloc.webViewController,
                ),
              ),
            if (sRBloc.isPaymentLoading)
              Expanded(
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
