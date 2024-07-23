import 'currentUser.dart';

class InsuranceCompany {
  int? id;
  String? enName;
  String? arName;
  int? packageRequestCount;
  int? packageDiscountPercentage;
  int? maxTotalDiscount;
  String? photo;
  String get name => (CurrentUser.language == "ar" ? arName : enName) ?? "";

  InsuranceCompany.fromJson(Map json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    photo = json['photo'] ?? '';
    packageRequestCount = json['package_request_count'];
    packageDiscountPercentage = json['package_discount_percentage'];
    maxTotalDiscount = json['max_total_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['en_name'] = this.enName ?? '';
    data['ar_name'] = this.arName ?? '';
    data['photo'] = this.photo ?? '';
    data['package_request_count'] = this.packageRequestCount ?? 0;
    data['package_discount_percentage'] = this.packageDiscountPercentage ?? 0;
    data['max_total_discount'] = this.maxTotalDiscount ?? 0;
    return data;
  }
}
