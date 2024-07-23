class VoucherModel {
  String? status;
  Voucher? voucher;

  VoucherModel({this.status, this.voucher});

  VoucherModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    voucher =
        json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.voucher != null) {
      data['voucher'] = this.voucher!.toJson();
    }
    return data;
  }
}

class Voucher {
  VoucherData? voucher;

  Voucher({this.voucher});

  Voucher.fromJson(Map<String, dynamic> json) {
    voucher =
        json['voucher'] != null ? VoucherData.fromJson(json['voucher']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.voucher != null) {
      data['voucher'] = this.voucher!.toJson();
    }
    return data;
  }
}

class VoucherData {
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
  int? maxFeesDiscount;
  int? maxUse;
  bool? private;
  bool? voucher;
  bool? active;
  String? createdAt;
  String? updatedAt;

  VoucherData(
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
      this.maxFeesDiscount,
      this.maxUse,
      this.private,
      this.voucher,
      this.active,
      this.createdAt,
      this.updatedAt});

  VoucherData.fromJson(Map<String, dynamic> json) {
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
    maxFeesDiscount = json['maxFeesDiscount'];
    maxUse = json['maxUse'];
    private = json['private'];
    voucher = json['voucher'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['maxFeesDiscount'] = this.maxFeesDiscount;
    data['maxUse'] = this.maxUse;
    data['private'] = this.private;
    data['voucher'] = this.voucher;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
