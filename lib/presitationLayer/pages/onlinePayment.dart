// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/presitationLayer/pages/shared/waitingPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../dataLayer/bloc/app/app_bloc.dart';
import '../../dataLayer/constants/enum.dart';
import '../widgets/willPopScopeWidget.dart';
import 'user_home_content/service_request/sRMapPicker.dart';
import '../../dataLayer/constants/variables.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../dataLayer/models/currentUser.dart';

class onlinePayment extends StatefulWidget {
  final String url;
  final String type;
  var cubit;

  onlinePayment({super.key, required this.url, required this.type, this.cubit});

  @override
  State<onlinePayment> createState() => onlinePaymentState();
}

class onlinePaymentState extends State<onlinePayment> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    var bloc = BlocProvider.of<AppBloc>(context);

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            waitingWidget();
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            } else if (request.url.startsWith(
                'https://$mainBaseUrl.helpooapp.net/api/v2/paymob/callback')) {
              Timer.periodic(Duration(seconds: 5), (Timer timer) async {
                debugPrint("will back soon");
                if (widget.type == "SR") {
                  if (widget.cubit != null) {
                    await widget.cubit.getCurrentRequest(widget.cubit);
                    if (widget.cubit.request.paymentStatus ==
                        PaymentStatus.notPaid) {
                      setState(() {
                        widget.cubit.request.isWorking = false;
                      });
                      Get.back();
                      timer.cancel();
                    } else if (widget.cubit.request.paymentStatus ==
                        PaymentStatus.paid) {
                      await widget.cubit.drawLinesFromDriverToClient();
                      setState(() {
                        widget.cubit.request.isWorking = false;
                      });
                      Get.to(() => serviceRMapPicker());
                      timer.cancel();
                    }
                  } else {
                    Get.back();
                    timer.cancel();
                  }
                } else {
                  bloc.clearPromoPackage();
                  CurrentUser.packages = await bloc.getActivePackages();
                  Get.offAll(() => homeScreen(
                        index: 2,
                      ));
                  timer.cancel();
                }
              });

              return NavigationDecision.navigate;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AppBloc>(context);
    return willPopScopeWidget(
      onWillPop: () async {
        if (widget.type == "SR") {
          if (widget.cubit != null) {
            await widget.cubit.getCurrentRequest(widget.cubit);
            if (widget.cubit.request.paymentStatus == PaymentStatus.notPaid) {
              setState(() {
                widget.cubit.request.isWorking = false;
              });
              Get.back();
            } else if (widget.cubit.request.paymentStatus ==
                PaymentStatus.paid) {
              await widget.cubit.drawLinesFromDriverToClient();

              setState(() {
                widget.cubit.request.isWorking = false;
              });
              Get.to(() => serviceRMapPicker());
            }
          } else {
            Get.back();
          }
        } else {
          CurrentUser.packages = await bloc.getActivePackages();
          Get.offAll(() => homeScreen(
                index: 2,
              ));
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          leading: Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () async {
                  if (widget.type == "SR") {
                    if (widget.cubit != null) {
                      await widget.cubit.getCurrentRequest(widget.cubit);
                      if (widget.cubit.request.paymentStatus ==
                          PaymentStatus.notPaid) {
                        setState(() {
                          widget.cubit.request.isWorking = false;
                        });
                        Get.back();
                      } else if (widget.cubit.request.paymentStatus ==
                          PaymentStatus.paid) {
                        await widget.cubit.drawLinesFromDriverToClient();

                        setState(() {
                          widget.cubit.request.isWorking = false;
                        });
                        Get.to(() => serviceRMapPicker());
                      }
                    } else {
                      Get.back();
                    }
                  } else {
                    CurrentUser.packages = await bloc.getActivePackages();
                    Get.offAll(() => homeScreen(
                          index: 2,
                        ));
                  }
                },
                icon: Icon(
                  CurrentUser.isArabic
                      ? MdiIcons.arrowRightThin
                      : MdiIcons.arrowLeftThin,
                  color: appBlack,
                ),
              ),
            ),
          ),
          title: Text('Payment Process'.tr),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => _controller.reload(),
            ),
          ],
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
