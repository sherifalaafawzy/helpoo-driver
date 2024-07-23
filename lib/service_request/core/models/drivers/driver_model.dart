import 'package:helpoo/service_request/core/models/drivers/drivers_model.dart';

class DriverModel {
  final String status;
  final DriverDetailsModel driver;

  DriverModel({
    required this.status,
    required this.driver,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      status: json['status'] ?? '',
      driver: DriverDetailsModel.fromJson(json['driver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'driver': driver.toJson(),
    };
  }
}