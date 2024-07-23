import 'package:get/get.dart';

class DistanceDuration {
  num distanceNumber = 0;
  String distanceUnit = "meter";
  num durationNumber = 0;
  String durationUnit = "sec";
  String get distance => distanceNumber.toString() + " " + distanceUnit.tr;
  String get Duration => durationNumber.toString() + " " + durationUnit.tr;
  setunits() {
    distanceNumber /= 1000;
    distanceUnit = "km";
    if (durationNumber > 60) {
      durationNumber /= 60;
      durationUnit = "min";
     
    }
    try {
      distanceNumber = double.parse(distanceNumber.toStringAsFixed(2));
      durationNumber = durationNumber.toInt();
    } catch (_) {}
  }
}
