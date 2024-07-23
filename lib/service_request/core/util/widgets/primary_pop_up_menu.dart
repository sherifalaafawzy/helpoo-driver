import 'package:flutter/material.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

void showPrimaryMenu({
  required BuildContext context,
  required GlobalKey key,
  required List<PopupMenuEntry> items,
  bool isBottom = true,
  double height = 0.0,
  double isBottomHeight = 45.0,
}) {
  showMenu(
    context: context,
    useRootNavigator: true,
    position: RelativeRect.fromLTRB(
      getXPosition(key),
      isBottom
          ? getYPosition(key) + isBottomHeight
          : getYPosition(key) - height,
      getXPosition(key),
      getYPosition(key),
    ),
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(
        30.0,
      ),
    ),
    items: items,
  );
}