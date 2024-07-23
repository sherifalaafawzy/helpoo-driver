import 'package:flutter/material.dart';

class willPopScopeWidget extends StatelessWidget {
  final Widget child;
  final Future<bool> Function()  onWillPop;
  const willPopScopeWidget(
      {super.key, required this.child, required this.onWillPop});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: child,
    );
  }
}
