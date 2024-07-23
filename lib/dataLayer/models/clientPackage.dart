class ClientPackage {
  int? id;
  bool? active;
  String? startDate;
  String? endDate;
  int? clientId;
  int? packageId;

  ClientPackage.fromJson(Map json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    clientId = json['ClientId'];
    packageId = json['PackageId'];
    active = json['active'];
  }
}
