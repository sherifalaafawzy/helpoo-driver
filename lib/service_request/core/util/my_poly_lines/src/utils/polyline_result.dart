import 'package:helpoo/service_request/core/util/my_poly_lines/src/PointLatLng.dart';

class PolylineResult {

  /// the api status retuned from google api
  ///
  /// returns OK if the api call is successful
  String? status;

  /// list of decoded points
  List<PointLatLng> points;

  String pointsString = '';

  String distance = '';

  num distanceInKm = 0;

  String duration = '';

  num durationInSec = 0;

  String duration_in_traffic = '';

  /// the error message returned from google, if none, the result will be empty
  String? errorMessage;

  PolylineResult({this.status, this.points = const [], this.errorMessage = ""});
}