import 'currentUser.dart';

class PackageBenefitsModel {
  int? id;
  String? enName;
  String? arName;

  PackageBenefitsModel.fromJson(Map json) {
    id = json['id'];
    enName = json['enName'];
    arName = json['arName'];
  }
  String get name => (CurrentUser.isArabic ? arName : enName) ?? "";

 
}


