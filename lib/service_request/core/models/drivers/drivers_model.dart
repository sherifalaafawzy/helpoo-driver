class DriversModel {
  final String status;
  List<DriverDetailsModel> drivers = [];

  DriversModel({
    required this.status,
    required this.drivers,
  });

  factory DriversModel.fromJson(Map<String, dynamic> json) {
    return DriversModel(
      status: json['status'] ?? '',
      drivers: (json['drivers'] as List).map((e) => DriverDetailsModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'drivers': drivers.map((e) => e.toJson()).toList(),
    };
  }
}

class DriverDetailsModel {
  final int id;
  final bool offline;
  final bool available;
  final num latitude;
  final num longitude;
  final String heading;
  final String fcmtoken;

  DriverDetailsModel({
    required this.id,
    required this.offline,
    required this.available,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.fcmtoken,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'] ?? 0,
      offline: json['offline'] ?? false,
      available: json['available'] ?? false,
      latitude: json['lat'] ?? 0.0,
      longitude: json['lng'] ?? 0.0,
      heading: json['heading'] ?? '',
      fcmtoken: json['fcmtoken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offline': offline,
      'available': available,
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
    };
  }
}