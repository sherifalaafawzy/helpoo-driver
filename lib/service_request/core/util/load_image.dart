import 'package:flutter/material.dart';

class LoadImage extends StatelessWidget {
  final String image;

  const LoadImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
        image,
      ),
    );
  }
}