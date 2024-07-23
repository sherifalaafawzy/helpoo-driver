import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/dataLayer/models/insuranceCompany.dart';

import 'UsedPromosPackages.dart';
import 'packageBenefitsModel.dart';

class User {
  int? id;
  int? userId;
  String? phoneNumber;
  String? username;
  String? name;
  int? corporateCompanyId;
  CorporateCompany? corporateCompany;
  int? roleId;
  String? roleName;
  bool? blocked;
  String? photo;

  User({
    this.id,
    this.userId,
    this.phoneNumber,
    this.username,
    this.name,
    this.roleId,
    this.roleName,
    this.blocked,
    this.photo,
    this.corporateCompanyId,
    this.corporateCompany,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['UserId'] ?? 0;
    phoneNumber = json['PhoneNumber'] ?? '';
    username = json['username'] ?? '';
    name = json['name'] ?? '';
    corporateCompanyId = json['CorporateCompanyId'] ?? 0;
    corporateCompany = json['CorporateCompany'] != null ? CorporateCompany.fromJson(json['CorporateCompany']) : null;
    roleId = json['RoleId'] ?? 0;
    roleName = json['RoleName'] ?? '';
    blocked = json['blocked'] ?? false;
    photo = json['photo'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'UserId': userId,
      'PhoneNumber': phoneNumber,
      'username': username,
      'name': name,
      'CorporateCompanyId': corporateCompanyId,
      'CorporateCompany': corporateCompany!.toJson(),
      'RoleId': roleId,
      'RoleName': roleName,
      'blocked': blocked,
    };
  }
}

class Broker {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? userId;
  User? user;

  Broker({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.user,
  });

  Broker.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    userId = json['UserId'] ?? 0;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }
}

class Package {
  String? id;
  int? packageId;
  int? insuranceCompanyId;
  int? corporateCompanyId;
  String enName = "";
  String arName = "";
  int? numberOfCars;
  int? assignedCars;
  String startDate = "";
  String endDate = "";
  int fees = 0;
  bool? active;
  int? maxDiscountPerTime;
  int? numberOfDiscountTimes;
  int? discountPercentage;
  String arDescription = "";
  String enDescription = "";
  static List<Package> packages = [];
  List<PackageBenefitsModel> packageBenefits = [];
  CorporateCompany? corporateCompany;
  InsuranceCompany? insuranceCompany;
  Broker? broker;

  List<UsedPromosPackages> usedPromosPackages = [];

  Package({this.id = "0"});

  Package.fromJson(json) {
    id = json['id'].toString();
    packageId = json['PackageId'];
    enName = json['enName'];
    arName = json['arName'];
    fees = json['fees'];
    maxDiscountPerTime = json['maxDiscountPerTime'];
    numberOfDiscountTimes = json['numberOfDiscountTimes'];
    discountPercentage = json['discountPercentage'];
    arDescription = json['arDescription'];
    enDescription = json['enDescription'];
    // packageBenefits = json['PackageBenefits'] ?? [];
    if (json['PackageBenefits'] != null) {
      packageBenefits = <PackageBenefitsModel>[];
      json['PackageBenefits'].forEach((v) {
        packageBenefits.add(PackageBenefitsModel.fromJson(v));
      });
    }
    if (json['UsedPromosPackages'] != null) {
      usedPromosPackages = <UsedPromosPackages>[];
      json['UsedPromosPackages'].forEach((v) {
        usedPromosPackages.add(UsedPromosPackages.fromJson(v));
      });
    }
    startDate = json['startDate'] ?? "";
    endDate = json['endDate'] ?? '';
    active = json['active'] ?? false;
    numberOfCars = json['numberOfCars'];
    insuranceCompanyId = json['insuranceCompanyId'];
    corporateCompanyId = json['corporateCompanyId'];
    assignedCars = json['assignedCars'];
    corporateCompany = json['CorporateCompany'] != null ? CorporateCompany.fromJson(json['CorporateCompany']) : null;
    insuranceCompany = json['insuranceCompany'] != null ? InsuranceCompany.fromJson(json['insuranceCompany']) : null;
    broker = json['Broker'] != null ? Broker.fromJson(json['Broker']) : null;
  }

  //to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PackageId'] = this.packageId;
    data['enName'] = this.enName;
    data['arName'] = this.arName;
    data['fees'] = this.fees;
    data['maxDiscountPerTime'] = this.maxDiscountPerTime;
    data['numberOfDiscountTimes'] = this.numberOfDiscountTimes;
    data['discountPercentage'] = this.discountPercentage;
    data['arDescription'] = this.arDescription;
    data['enDescription'] = this.enDescription;
    data['PackageBenefits'] = this.packageBenefits;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['active'] = this.active;
    data['numberOfCars'] = this.numberOfCars;
    data['insuranceCompanyId'] = this.insuranceCompanyId;
    data['corporateCompanyId'] = this.corporateCompanyId;
    data['assignedCars'] = this.assignedCars;
    return data;
  }
}
