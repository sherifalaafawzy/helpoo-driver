import 'package:helpoo/service_request/core/models/service_request/service_request_model.dart';

class CheckServiceRequestModel {
  final String status;
  final ServiceRequestDetails? serviceRequestDetails;

  CheckServiceRequestModel({
    required this.status,
    required this.serviceRequestDetails,
  });

  factory CheckServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return CheckServiceRequestModel(
      status: json['status'] ?? '',
      serviceRequestDetails: json['request'] != null ? ServiceRequestDetails.fromJson(json['request']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'request': serviceRequestDetails?.toJson(),
    };
  }
}