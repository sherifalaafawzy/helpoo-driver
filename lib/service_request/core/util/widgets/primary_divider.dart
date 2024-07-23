import 'package:flutter/material.dart';

class PrimaryDivider extends StatelessWidget {
  const PrimaryDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.5,
      height: 0.5,
      color: Colors.grey[300],
    );
  }
}
