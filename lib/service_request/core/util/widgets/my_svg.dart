import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySvg extends StatelessWidget {
  final String image;
  Color? color;
  bool rotate;
  int rotationValue;
  double? width;

  MySvg({
    Key? key,
    required this.image,
    this.color,
    this.rotate = false,
    this.rotationValue = 2,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate ? Directionality.of(context) == TextDirection.rtl ? rotationValue : 0 : 0,
      child: SvgPicture.asset(
        'assets/images/$image.svg',
        width: width,
        color: color,
      ),
    );
  }
}
