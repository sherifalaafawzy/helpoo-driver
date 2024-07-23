import 'package:flutter/material.dart';

class submittedImageView extends StatelessWidget {
  const submittedImageView({
    Key? key,
    required this.img,
  }) : super(key: key);

  final String? img;

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/imgs/By my car-amico.png');
  }
}