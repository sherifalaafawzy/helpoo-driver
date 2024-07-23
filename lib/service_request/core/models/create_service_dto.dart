class CreateServiceDto {
  final String carId;
  final String clientId;
  final String corporateId;
  final String createdByUser;
  final String driverId;
  final String carServiceTypeId;
  final String distance;
  final String destinationDistance;
  final String destinationAddress;
  final String clientAddress;
  final String clientLatitude;
  final String clientLongitude;
  final String destinationLat;
  final String destinationLng;

  CreateServiceDto({
    required this.carId,
    required this.clientId,
    required this.corporateId,
    required this.createdByUser,
    required this.driverId,
    required this.carServiceTypeId,
    required this.distance,
    required this.destinationDistance,
    required this.destinationAddress,
    required this.clientAddress,
    required this.clientLatitude,
    required this.clientLongitude,
    required this.destinationLat,
    required this.destinationLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'clientId': clientId,
      'corporateId': corporateId,
      'createdByUser': createdByUser,
      'driverId': driverId,
      'carServiceTypeId': carServiceTypeId,
      'distance': distance,
      'destinationDistance': destinationDistance,
      'destinationAddress': destinationAddress,
      'clientAddress': clientAddress,
      'clientLatitude': clientLatitude,
      'clientLongitude': clientLongitude,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
    };
  }
}