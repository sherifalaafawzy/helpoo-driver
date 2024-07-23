class MapPlaceModel {
  final String status;
  final List<MapPlaceDataModel> predictions;

  MapPlaceModel({
    required this.status,
    required this.predictions,
  });

  factory MapPlaceModel.fromJson(Map<String, dynamic> json) {
    return MapPlaceModel(
      status: json['status'] ?? '',
      predictions: List.from(json['predictions']).map((e) => MapPlaceDataModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'predictions': predictions.map((e) => e.toJson()).toList(),
    };
  }
}

class MapPlaceDataModel {
  final String mainText;
  final String secondaryText;
  final String placeId;

  MapPlaceDataModel({
    required this.mainText,
    required this.secondaryText,
    required this.placeId,
  });

  factory MapPlaceDataModel.fromJson(Map<String, dynamic> json) {
    return MapPlaceDataModel(
      mainText: json['structured_formatting']['main_text'] ?? '',
      secondaryText: json['structured_formatting']['secondary_text'] ?? '',
      placeId: json['place_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainText': mainText,
      'secondaryText': secondaryText,
      'place_id': placeId,
    };
  }
}