import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:helpoo/service_request/core/util/my_poly_lines/src/PointLatLng.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/src/utils/polyline_result.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/src/utils/polyline_waypoint.dart';
import 'package:helpoo/service_request/core/util/my_poly_lines/src/utils/request_enums.dart';


class NetworkUtil {
  static const String STATUS_OK = "ok";

  ///Get the encoded string from google directions api
  ///
  Future<PolylineResult> getRouteBetweenCoordinates(
      String googleApiKey,
      PointLatLng origin,
      PointLatLng destination,
      TravelMode travelMode,
      List<PolylineWayPoint> wayPoints,
      bool avoidHighways,
      bool avoidTolls,
      bool avoidFerries,
      bool optimizeWaypoints) async {
    String mode = travelMode.toString().replaceAll('TravelMode.', '');
    PolylineResult result = PolylineResult();
    var params = {
      "origin": "${origin.latitude},${origin.longitude}",
      "destination": "${destination.latitude},${destination.longitude}",
      // "destination": "side_of_road:${destination.latitude},${destination.longitude}",
      "mode": mode,
      "avoidHighways": "$avoidHighways",
      "avoidFerries": "$avoidFerries",
      "avoidTolls": "$avoidTolls",
      "key": googleApiKey,
      "departure_time": "now",
      // "region": "kw",
    };
    if (wayPoints.isNotEmpty) {
      List wayPointsArray = [];
      wayPoints.forEach((point) => wayPointsArray.add(point.location));
      String wayPointsString = wayPointsArray.join('|');
      if (optimizeWaypoints) {
        wayPointsString = 'optimize:true|$wayPointsString';
      }
      params.addAll({"waypoints": wayPointsString});
    }
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/directions/json", params);

    //String url = uri.toString();
    // print('GOOGLE MAPS URL: ' + url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      result.status = parsedJson["status"];
      if (parsedJson["status"]?.toLowerCase() == STATUS_OK &&
          parsedJson["routes"] != null &&
          parsedJson["routes"].isNotEmpty) {
        print('RESULT FROM PACKAGE');
        print(parsedJson["routes"][0]["legs"]);
        result.distance = parsedJson["routes"][0]["legs"][0]["distance"]["text"];
        result.distanceInKm = parsedJson["routes"][0]["legs"][0]["distance"]["value"];
        // from meter to km
        result.distanceInKm = result.distanceInKm / 1000;
        result.distanceInKm = result.distanceInKm.ceil();

        result.duration = parsedJson["routes"][0]["legs"][0]["duration"]["text"];
        result.durationInSec = parsedJson["routes"][0]["legs"][0]["duration"]["value"];

        // from sec to min
        result.durationInSec = result.durationInSec / 60;
        result.durationInSec = result.durationInSec.ceil();

        result.duration_in_traffic = parsedJson["routes"][0]["legs"][0]["duration_in_traffic"]["text"];

        result.pointsString = parsedJson["routes"][0]["overview_polyline"]["points"];

        result.points = decodeEncodedPolyline(
            parsedJson["routes"][0]["overview_polyline"]["points"]);
      } else {
        result.errorMessage = parsedJson["error_message"];
      }
    }
    return result;
  }

  ///decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  ///return [List]
  List<PointLatLng> decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      PointLatLng p = PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
