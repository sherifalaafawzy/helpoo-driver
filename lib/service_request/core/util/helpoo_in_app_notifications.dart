import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/widgets/main_scaffold.dart';

class HelpooInAppNotification {
  /// Shows a general [message] with the given [iconPath] next to it.
  static showMessage({
    required String message,
    String? title,
    IconData? iconPath,
    Color? color,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 5),
  }) {
    BotToast.showCustomNotification(
        duration: duration,
        onClose: onClose,
        backButtonBehavior: BackButtonBehavior.close,
        toastBuilder: (_) {
          return Container(
            width: 600,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3.0,
                  // has the effect of softening the shadow
                  spreadRadius: 2.0,
                  // has the effect of extending the shadow
                  offset: const Offset(
                    0.0, // horizontal, move right
                    4.0, // vertical, move down
                  ),
                ),
              ],
              color: color ?? mainColorHex,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            margin: const EdgeInsets.all(16),
            height: title != null ? 56 + 40 : 56,
            child: MainScaffold(
              scaffold: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: 16,
                  ),
                  if (iconPath != null)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: whiteColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Icon(
                        iconPath,
                        color: whiteColor,
                        size: 16.0,
                      ),
                    ),
                  if (iconPath != null)
                    const SizedBox(
                      width: 16,
                    ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (title != null)
                          const SizedBox(
                            height: 8,
                          ),
                        Text(
                          message,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  buildCloseButton(),
                ],
              ),
            ),
          );
        });
  }

  static Widget buildCloseButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          BotToast.cleanAll();
        },
        child: Container(
          height: 56,
          width: 44,
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(
            'assets/imgs/ic_close.svg',
            width: 16,
            height: 16,
            color: whiteColor,
          ),
        ),
      ),
    );
  }

  /// Shows the given [message] with an [Resources.images.ic_check] icon next
  /// to it. Indicates operation has succeeded.
  static void showSuccessMessage({
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    showMessage(
      message: message,
      iconPath: Icons.check_rounded,
      duration: duration,
    );
  }

  /// Shows the given [message] with an [Icons.error] next to it in
  /// [Colors.red]. Indicates operation has failed.
  static void showErrorMessage({
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    BotToast.showCustomNotification(
        duration: duration,
        toastBuilder: (_) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3.0,
                    // has the effect of softening the shadow
                    spreadRadius: 2.0,
                    // has the effect of extending the shadow
                    offset: const Offset(
                      0.0, // horizontal, move right
                      4.0, // vertical, move down
                    ))
              ],
              color: Colors.red,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            margin: const EdgeInsets.all(16),
            height: 56,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                buildCloseButton(),
              ],
            ),
          );
        });
  }
}
