import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class imageView extends StatefulWidget {
  const imageView({
    Key? key,
    required this.img,
  }) : super(key: key);

  final String img;

  @override
  State<imageView> createState() => imageViewState();
}

class imageViewState extends State<imageView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //  Image.asset('assets/img/user.png')
          Image.network(widget.img),
    );
  }
}
