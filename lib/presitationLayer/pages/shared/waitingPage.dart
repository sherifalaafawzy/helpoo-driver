import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../dataLayer/constants/variables.dart';

class waitingWidget extends StatelessWidget {
  const waitingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appWhite,
      child: const Center(
        child: SpinKitChasingDots(
          color: mainColor,
          size: 50.0,
        ),
      ),
    );
  }
}
