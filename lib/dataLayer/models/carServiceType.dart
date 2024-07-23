class CarServiceType {
  int? id;
  static Future<List<CarServiceType>>? carServiceTypes ;
  int? car_type;
  String? enName;
  String? arName;
  bool requiresCarrier = false;
  bool requiresEuropeanTowTruck = false;
  double base_cost = 0;
  double cost_per_km = 0;
  
  CarServiceType.fromJson(json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    base_cost = json['base_cost'].toDouble();
    cost_per_km = json['cost_per_km'].toDouble();
    car_type = json['car_type'];
  }


}
