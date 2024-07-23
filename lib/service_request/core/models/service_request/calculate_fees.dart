class CalculateFeesModel {
  String status;
  num euroOriginalFees;
  num euroFees;
  num euroPercentage;
  num normalOriginalFees;
  num normalFees;
  num normalPercentage;

  CalculateFeesModel({
    required this.status,
    required this.euroOriginalFees,
    required this.euroFees,
    required this.euroPercentage,
    required this.normalOriginalFees,
    required this.normalFees,
    required this.normalPercentage,
  });

  factory CalculateFeesModel.fromJson(Map<String, dynamic> json) {
    return CalculateFeesModel(
      status: json['status'],
      euroOriginalFees: json['EuroOriginalFees'],
      euroFees: json['EuroFees'],
      euroPercentage: json['EuroPercent'],
      normalOriginalFees: json['NormOriginalFees'],
      normalFees: json['NormFees'],
      normalPercentage: json['NormPercent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'EuroOriginalFees': euroOriginalFees,
      'EuroFees': euroFees,
      'EuroPercent': euroPercentage,
      'NormOriginalFees': normalOriginalFees,
      'NormFees': normalFees,
      'NormPercent': normalPercentage,
    };
  }
}