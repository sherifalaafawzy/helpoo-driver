class UsedPromosPackages {
  int? id;
  int? fees;
  String? createdAt;
  String? updatedAt;
  int? packageId;
  int? packagePromoCodeId;
  int? userId;
  int? clientPackageId;
  PackagePromoCode? packagePromoCode;

  UsedPromosPackages(
      {this.id,
      this.fees,
      this.createdAt,
      this.updatedAt,
      this.packageId,
      this.packagePromoCodeId,
      this.userId,
      this.clientPackageId,
      this.packagePromoCode});

  UsedPromosPackages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fees = json['fees'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    packageId = json['PackageId'];
    packagePromoCodeId = json['PackagePromoCodeId'];
    userId = json['UserId'];
    clientPackageId = json['ClientPackageId'];
    packagePromoCode = json['PackagePromoCode'] != null
        ? new PackagePromoCode.fromJson(json['PackagePromoCode'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fees'] = this.fees;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['PackageId'] = this.packageId;
    data['PackagePromoCodeId'] = this.packagePromoCodeId;
    data['UserId'] = this.userId;
    data['ClientPackageId'] = this.clientPackageId;
    if (this.packagePromoCode != null) {
      data['PackagePromoCode'] = this.packagePromoCode!.toJson();
    }
    return data;
  }
}

class PackagePromoCode {
  int? id;
  String? name;
  String? value;
  String? startDate;
  String? expiryDate;
  String? usageExpiryDate;
  int? percentage;
  int? count;
  int? maxCount;
  int? feesDiscount;
  bool? private;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? corporateCompanyId;
  CorporateCompany? corporateCompany;

  PackagePromoCode(
      {this.id,
      this.name,
      this.value,
      this.startDate,
      this.expiryDate,
      this.usageExpiryDate,
      this.percentage,
      this.count,
      this.maxCount,
      this.feesDiscount,
      this.private,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.corporateCompanyId,
      this.corporateCompany});

  PackagePromoCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    startDate = json['startDate'];
    expiryDate = json['expiryDate'];
    usageExpiryDate = json['usageExpiryDate'];
    percentage = json['percentage'];
    count = json['count'];
    maxCount = json['maxCount'];
    feesDiscount = json['feesDiscount'];
    private = json['private'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    corporateCompanyId = json['CorporateCompanyId'];
    corporateCompany = json['CorporateCompany'] != null
        ? new CorporateCompany.fromJson(json['CorporateCompany'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['startDate'] = this.startDate;
    data['expiryDate'] = this.expiryDate;
    data['usageExpiryDate'] = this.usageExpiryDate;
    data['percentage'] = this.percentage;
    data['count'] = this.count;
    data['maxCount'] = this.maxCount;
    data['feesDiscount'] = this.feesDiscount;
    data['private'] = this.private;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['CorporateCompanyId'] = this.corporateCompanyId;
    if (this.corporateCompany != null) {
      data['CorporateCompany'] = this.corporateCompany!.toJson();
    }
    return data;
  }
}

class CorporateCompany {
  int? id;
  String? enName;
  String? arName;
  int? discountR;
  bool? deferredPa;
  Null startDate;
  Null endDate;
  bool? cash;
  bool? cardToDriv;
  bool? online;
  String? photo;
  Null numofreque;
  String? createdAt;
  String? updatedAt;

  CorporateCompany(
      {this.id,
      this.enName,
      this.arName,
      this.discountR,
      this.deferredPa,
      this.startDate,
      this.endDate,
      this.cash,
      this.cardToDriv,
      this.online,
      this.photo,
      this.numofreque,
      this.createdAt,
      this.updatedAt});

  CorporateCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enName = json['en_name'];
    arName = json['ar_name'];
    discountR = json['discount_r'];
    deferredPa = json['deferredPa'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    cash = json['cash'];
    cardToDriv = json['cardToDriv'];
    online = json['online'];
    photo = json['photo'];
    numofreque = json['numofreque'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['en_name'] = this.enName;
    data['ar_name'] = this.arName;
    data['discount_r'] = this.discountR;
    data['deferredPa'] = this.deferredPa;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['cash'] = this.cash;
    data['cardToDriv'] = this.cardToDriv;
    data['online'] = this.online;
    data['photo'] = this.photo;
    data['numofreque'] = this.numofreque;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
