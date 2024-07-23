import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/variables.dart';
import 'directionDetails.dart';

class GoogleMapsModel {
  String? distanceValue;
  String? distenationDistanceValue;
  int? carId;
  int? clientId;
  LatLng? destination;

  var points;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Set<Circle> circle = {};

  clearMapModel() {
    polylines.clear();
    markers.clear();
    circle.clear();
    polylineCoordinates.clear();
  }

  Future<DirectionDetails> getDirectionsDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$MapApiKey';
    http.Response res = await http.get(Uri.parse(url));
    var response = jsonDecode(res.body);

    DirectionDetails directionDetails = DirectionDetails(
      distanceText: response['routes'][0]['legs'][0]['distance']['text'],
      durationValue: response['routes'][0]['legs'][0]['duration']['value'],
      durationText: response['routes'][0]['legs'][0]['duration']['text'],
      distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
      encodingPoints: response['routes'][0]['overview_polyline']['points'],
    );

    return directionDetails;
    // } catch (e) {
    //   debugPrint(e.toString());
    //   return directionDetails;
    // }
  }
}
