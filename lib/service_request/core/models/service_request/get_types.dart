class GetServiceReqTypes {
  String? status;
  List<ServiceRequestsType>? serviceRequestsTypes;

  GetServiceReqTypes({
    this.status,
    this.serviceRequestsTypes,
  });

  GetServiceReqTypes.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    serviceRequestsTypes = json['serviceRequestsTypes'] != null
        ? (json['serviceRequestsTypes'] as List)
            .map((e) => ServiceRequestsType.fromJson(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'serviceRequestsTypes':
          serviceRequestsTypes?.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceRequestsType {
  int? id;
  String? enName;
  String? arName;
  int? baseCost;
  int? costPerKm;
  String? createdAt;
  String? updatedAt;
  int? carType;

  ServiceRequestsType({
    this.id,
    this.enName,
    this.arName,
    this.baseCost,
    this.costPerKm,
    this.createdAt,
    this.updatedAt,
    this.carType,
  });

  ServiceRequestsType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    baseCost = json['base_cost'];
    costPerKm = json['cost_per_km'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    carType = json['car_type'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'base_cost': baseCost,
      'cost_per_km': costPerKm,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'car_type': carType,
    };
  }
}