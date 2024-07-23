// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../dataLayer/models/serviceReqest.dart';
import 'changStatusWidget.dart';

class driverRequestCard extends StatefulWidget {
  ServiceRequest c;
  driverRequestCard(
    this.c, {
    Key? key,
  }) : super(key: key);

  @override
  State<driverRequestCard> createState() => _driverRequestCardState();
}

class _driverRequestCardState extends State<driverRequestCard> {
  checkConfirm() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.c.confirmed) {
        AudioPlayer().play(AssetSource('audio/Notification.mp3'));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeStatusWidget(
      c: widget.c,
    );
  }
}
