import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../dataLayer/models/driver.dart';

import '../../dataLayer/constants/variables.dart';

class driverRating extends StatelessWidget {
  final Driver? driver;
  const driverRating(this.driver, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return driver != null
        ? AbsorbPointer(
            child: RatingBar.builder(
              initialRating: double.parse(driver!.averageRating ?? "0"),
              itemSize: 13,
              minRating: 0,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              // itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: mainColor,
              ),
              onRatingUpdate: (rating) {},
            ),
          )
        : const SizedBox(
            height: 0,
            width: 0,
          );
  }
}
