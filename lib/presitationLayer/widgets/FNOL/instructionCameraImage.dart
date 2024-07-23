import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class instructionsCameraImage extends StatelessWidget {
  const instructionsCameraImage({Key? key, required this.requiredImage})
      : super(key: key);
  final String requiredImage;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 8.0,
              left: 12,
            ),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: appWhite,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: requiredImage.contains('id')
                ? Image.asset(
                    'assets/report/' + requiredImage + '.png',
                    height: Get.height * .2,
                  )
                : Image.asset(
                    'assets/report/' + requiredImage + '.gif',
                    height: Get.height * .2,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 8.0,
              bottom: 8.0,
            ),
            child: Text(
              bloc.fnol.getImageDescription(requiredImage),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
