import 'package:helpoo/dataLayer/models/imagesModel.dart';
import 'package:helpoo/dataLayer/models/insuranceCompany.dart';
import 'package:helpoo/dataLayer/models/locationAddress.dart';
import 'package:helpoo/dataLayer/models/manufactur.dart';
import 'package:helpoo/dataLayer/models/model.dart';

class GetAccidentDetailsModel {
  String? status;
  Report? report;
  List<ImagesModel>? mainImages;
  List<ImagesModel>? policeImages;
  List<ImagesModel>? supplementImages;
  List<ImagesModel>? bRepairImages;
  List<ImagesModel>? resurveyImages;
  List<ImagesModel>? additional;

  GetAccidentDetailsModel(
      {this.status,
      this.report,
      this.mainImages,
      this.policeImages,
      this.supplementImages,
      this.bRepairImages,
      this.resurveyImages,
      this.additional});

  GetAccidentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    report = json['report'] != null ? Report.fromJson(json['report']) : null;
    mainImages =
        json['mainImages'] != null ? (json['mainImages'] as List).map((e) => ImagesModel.fromJson(e)).toList() : null;
    policeImages = json['policeImages'] != null
        ? (json['policeImages'] as List).map((e) => ImagesModel.fromJson(e)).toList()
        : null;
    supplementImages = json['supplementImages'] != null
        ? (json['supplementImages'] as List).map((e) => ImagesModel.fromJson(e)).toList()
        : null;
    bRepairImages = json['bRepairImages'] != null
        ? (json['bRepairImages'] as List).map((e) => ImagesModel.fromJson(e)).toList()
        : null;
    resurveyImages = json['resurveyImages'] != null
        ? (json['resurveyImages'] as List).map((e) => ImagesModel.fromJson(e)).toList()
        : null;
    additional =
        json['additional'] != null ? (json['additional'] as List).map((e) => ImagesModel.fromJson(e)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'report': report!.toJson(),
      'mainImages': mainImages!.map((v) => v.toJson()).toList(),
      'policeImages': policeImages!.map((v) => v.toJson()).toList(),
      'supplementImages': supplementImages!.map((v) => v.toJson()).toList(),
      'bRepairImages': bRepairImages!.map((v) => v.toJson()).toList(),
      'resurveyImages': resurveyImages!.map((v) => v.toJson()).toList(),
      'additional': additional!.map((v) => v.toJson()).toList(),
    };
  }
}

//******************************************************************************
class Report {
  int? id;
  int? requiredImagesNo;
  int? uploadedImagesCounter;
  String? ref;
  String? comment;
  String? phoneNumber;
  String? audioCommentWritten;
  String? client;
  String? repairCost;
  String? commentUser;
  String? status;
  List<String>? statusList;
  String? aiRef;
  LocationAddress? location;
  List<String>? billDeliveryDate;
  List<String>? billDeliveryTimeRange;
  List<String>? billDeliveryNotes;
  List<LocationAddress>? billDeliveryLocation;
  List<LocationAddress>? beforeRepairLocation;
  List<LocationAddress>? afterRepairLocation;
  String? video;
  List<String>? bRepairName;
  List<LocationAddress>? rightSaveLocation;
  List<LocationAddress>? supplementLocation;
  List<LocationAddress>? resurveyLocation;
  String? createdAt;
  String? updatedAt;
  int? carId;
  int? createdByUser;
  int? clientId;
  int? insuranceCompanyId;
  Car? car;
  List<AccidentTypes>? accidentTypes;
  Client? clientModel;

  Report({
    this.id,
    this.requiredImagesNo,
    this.uploadedImagesCounter,
    this.ref,
    this.comment,
    this.phoneNumber,
    this.client,
    this.repairCost,
    this.commentUser,
    this.audioCommentWritten,
    this.status,
    this.statusList,
    this.aiRef,
    this.location,
    this.billDeliveryDate,
    this.billDeliveryTimeRange,
    this.billDeliveryNotes,
    this.billDeliveryLocation,
    this.beforeRepairLocation,
    this.afterRepairLocation,
    this.video,
    this.bRepairName,
    this.rightSaveLocation,
    this.supplementLocation,
    this.resurveyLocation,
    this.createdAt,
    this.updatedAt,
    this.carId,
    this.createdByUser,
    this.clientId,
    this.insuranceCompanyId,
    this.car,
    this.accidentTypes,
    this.clientModel,
  });

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    requiredImagesNo = json['requiredImagesNo'] ?? 0;
    uploadedImagesCounter = json['uploadedImagesCounter'] ?? 0;
    ref = json['ref'] ?? '';
    comment = json['comment'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    client = json['client'] ?? '';
    repairCost = json['repairCost'] ?? '';
    commentUser = json['commentUser'] ?? '';
    audioCommentWritten = json['audioCommentWritten'] ?? '';
    status = json['status'] ?? '';
    statusList = json['statusList'] != null ? (json['statusList'] as List).map((e) => e.toString()).toList() : null;
    aiRef = json['aiRef'] ?? '';
    location = json['location'] != null ? LocationAddress.fromJson(json['location']) : null;
    billDeliveryDate =
        json['billDeliveryDate'] != null ? (json['billDeliveryDate'] as List).map((e) => e.toString()).toList() : null;
    billDeliveryTimeRange = json['billDeliveryTimeRange'] != null
        ? (json['billDeliveryTimeRange'] as List).map((e) => e.toString()).toList()
        : null;
    billDeliveryNotes = json['billDeliveryNotes'] != null
        ? (json['billDeliveryNotes'] as List).map((e) => e.toString()).toList()
        : null;
    billDeliveryLocation = json['billDeliveryLocation'] != null
        ? (json['billDeliveryLocation'] as List).map((e) => LocationAddress.fromJson(e)).toList()
        : null;
    beforeRepairLocation = json['beforeRepairLocation'] != null
        ? (json['beforeRepairLocation'] as List).map((e) => LocationAddress.fromJson(e)).toList()
        : null;
    afterRepairLocation = json['afterRepairLocation'] != null
        ? (json['afterRepairLocation'] as List).map((e) => LocationAddress.fromJson(e)).toList()
        : null;
    video = json['video'] ?? '';
    bRepairName = json['bRepairName'] != null ? (json['bRepairName'] as List).map((e) => e.toString()).toList() : null;
    rightSaveLocation = json['rightSaveLocation'] != null
        ? (json['rightSaveLocation'] as List).map((e) => LocationAddress.fromJson(e)).toList()
        : null;

    supplementLocation = json['supplementLocation'] != null
        ? (json['supplementLocation'] as List).map((e) => LocationAddress.fromJson(e)).toList()
        : null;
    resurveyLocation = json['resurveyLocation'] != null
        ? (json['resurveyLocation'] as List).map((e) => LocationAddress.fromJson(e)).toList()
        : null;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    carId = json['carId'] ?? 0;
    createdByUser = json['createdByUser'] ?? 0;
    clientId = json['clientId'] ?? 0;
    insuranceCompanyId = json['insuranceCompanyId'] ?? 0;
    car = json['Car'] != null ? Car.fromJson(json['Car']) : null;
    accidentTypes = json['accidentTypes'] != null
        ? (json['accidentTypes'] as List).map((e) => AccidentTypes.fromJson(e)).toList()
        : null;
    clientModel = json['Client'] != null ? Client.fromJson(json['Client']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requiredImagesNo': requiredImagesNo,
      'uploadedImagesCounter': uploadedImagesCounter,
      'ref': ref,
      'comment': comment,
      'phoneNumber': phoneNumber,
      'client': client,
      'repairCost': repairCost,
      'commentUser': commentUser,
      'audioCommentWritten': audioCommentWritten,
      'status': status,
      'statusList': statusList,
      'aiRef': aiRef,
      'location': location?.toJson(),
      'billDeliveryDate': billDeliveryDate,
      'billDeliveryTimeRange': billDeliveryTimeRange,
      'billDeliveryNotes': billDeliveryNotes,
      'billDeliveryLocation': billDeliveryLocation?.map((v) => v.toJson()).toList(),
      'beforeRepairLocation': beforeRepairLocation?.map((v) => v.toJson()).toList(),
      'afterRepairLocation': afterRepairLocation?.map((v) => v.toJson()).toList(),
      'video': video,
      'bRepairName': bRepairName,
      'rightSaveLocation': rightSaveLocation?.map((v) => v.toJson()).toList(),
      'supplementLocation': supplementLocation?.map((v) => v.toJson()).toList(),
      'resurveyLocation': resurveyLocation?.map((v) => v.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'carId': carId,
      'createdByUser': createdByUser,
      'clientId': clientId,
      'insuranceCompanyId': insuranceCompanyId,
      'Car': car?.toJson(),
      'accidentTypes': accidentTypes?.map((v) => v.toJson()).toList(),
      'Client': clientModel?.toJson(),
    };
  }
}
//******************************************************************************

class Car {
  int? id;
  String? plateNumber;
  int? year;
  String? policyNumber;
  String? policyStarts;
  String? policyEnds;
  String? appendixNumber;
  String? vinNumber;
  bool? policyCanceled;
  String? color;

  // Null? frontLicense;
  // Null? backLicense;
  int? createdBy;
  int? manufacturerId;
  int? carModelId;
  int? clientId;
  bool? active;
  String? createdAt;
  String? updatedAt;

  // Date? deletedAt;
  int? insuranceCompanyId;
  InsuranceCompany? insuranceCompany;
  Manufacture? manufacturer;
  Model? carModel;

  Car(
      {this.id,
      this.plateNumber,
      this.year,
      this.policyNumber,
      this.policyStarts,
      this.policyEnds,
      this.appendixNumber,
      this.vinNumber,
      this.policyCanceled,
      this.color,
      // this.frontLicense,
      // this.backLicense,
      this.createdBy,
      this.manufacturerId,
      this.carModelId,
      this.clientId,
      this.active,
      this.createdAt,
      this.updatedAt,
      // this.deletedAt,
      this.insuranceCompanyId,
      this.insuranceCompany,
      this.manufacturer,
      this.carModel});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    plateNumber = json['plateNumber'] ?? '';
    year = json['year'] ?? 0;
    policyNumber = json['policyNumber'] ?? '';
    policyStarts = json['policyStarts'] ?? '';
    policyEnds = json['policyEnds'] ?? '';
    appendixNumber = json['appendix_number'] ?? '';
    vinNumber = json['vin_number'] ?? '';
    policyCanceled = json['policyCanceled'] ?? false;
    color = json['color'] ?? '';
    // frontLicense = json['frontLicense'];
    // backLicense = json['backLicense'];
    createdBy = json['CreatedBy'] ?? 0;
    manufacturerId = json['ManufacturerId'] ?? 0;
    carModelId = json['CarModelId'] ?? 0;
    clientId = json['ClientId'] ?? 0;
    active = json['active'] ?? false;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    // deletedAt = json['deletedAt'];
    insuranceCompanyId = json['insuranceCompanyId'] ?? 0;
    insuranceCompany = json['insuranceCompany'] != null ? InsuranceCompany.fromJson(json['insuranceCompany']) : null;
    manufacturer = json['Manufacturer'] != null ? Manufacture.fromJson(json['Manufacturer']) : null;
    carModel = json['CarModel'] != null ? Model.fromJson(json['CarModel']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'year': year,
      'policyNumber': policyNumber,
      'policyStarts': policyStarts,
      'policyEnds': policyEnds,
      'appendixNumber': appendixNumber,
      'vinNumber': vinNumber,
      'policyCanceled': policyCanceled,
      'color': color,
      // 'frontLicense': frontLicense,
      // 'backLicense': backLicense,
      'createdBy': createdBy,
      'manufacturerId': manufacturerId,
      'carModelId': carModelId,
      'clientId': clientId,
      'active': active,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      // 'deletedAt': deletedAt,
      'insuranceCompanyId': insuranceCompanyId,
      'insuranceCompany': insuranceCompany?.toJson(),
      'manufacturer': manufacturer?.toJson(),
      'carModel': carModel?.toJson(),
    };
  }
}

//******************************************************************************
class AccidentTypes {
  int? id;
  String? enName;
  String? arName;
  String? requiredImages;
  String? createdAt;
  String? updatedAt;
  AccidentTypesAndReports? accidentTypesAndReports;

  AccidentTypes(
      {this.id,
      this.enName,
      this.arName,
      this.requiredImages,
      this.createdAt,
      this.updatedAt,
      this.accidentTypesAndReports});

  AccidentTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    enName = json['en_name'] ?? '';
    arName = json['ar_name'] ?? '';
    requiredImages = json['requiredImages'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    accidentTypesAndReports = json['AccidentTypesAndReports'] != null
        ? AccidentTypesAndReports.fromJson(json['AccidentTypesAndReports'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enName': enName,
      'arName': arName,
      'requiredImages': requiredImages,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'accidentTypesAndReports': accidentTypesAndReports,
    };
  }
}

//******************************************************************************
class AccidentTypesAndReports {
  int? id;
  int? AccidentTypeId;
  int? accidentReportId;
  String? createdAt;
  String? updatedAt;
  int? accidentTypeId;

  AccidentTypesAndReports(
      {this.id, this.AccidentTypeId, this.accidentReportId, this.createdAt, this.updatedAt, this.accidentTypeId});

  AccidentTypesAndReports.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    AccidentTypeId = json['AccidentTypeId'] ?? 0;
    accidentReportId = json['AccidentReportId'] ?? 0;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    accidentTypeId = json['accidentTypeId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'AccidentTypeId': AccidentTypeId,
      'accidentReportId': accidentReportId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'accidentTypeId': accidentTypeId,
    };
  }
}

//******************************************************************************
class Client {
  int? id;
  bool? active;

  // Null? confirmed;
  String? fcmtoken;
  String? createdAt;
  String? updatedAt;
  int? userId;
  User? user;

  Client({
    this.id,
    this.active,
    // this.confirmed,
    this.fcmtoken,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.user,
  });

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    active = json['active'] ?? false;
    // confirmed = json['confirmed'];
    fcmtoken = json['fcmtoken'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    userId = json['UserId'] ?? 0;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      // 'confirmed': confirmed,
      'fcmtoken': fcmtoken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
      'user': user,
    };
  }
}

//******************************************************************************
class User {
  int? id;
  String? phoneNumber;
  String? email;
  String? password;
  String? username;
  String? name;
  bool? blocked;
  String? photo;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? roleId;

  User({
    this.id,
    this.phoneNumber,
    this.email,
    this.password,
    this.username,
    this.name,
    this.blocked,
    this.photo,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.roleId,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    phoneNumber = json['PhoneNumber'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    username = json['username'] ?? '';
    name = json['name'] ?? '';
    blocked = json['blocked'] ?? false;
    photo = json['photo'] ?? '';
    deleted = json['deleted'] ?? false;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    roleId = json['RoleId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'username': username,
      'name': name,
      'blocked': blocked,
      'photo': photo,
      'deleted': deleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'RoleId': roleId,
    };
  }
}

// //******************************************************************************
// class ImagesModel {
//   int? id;
//   String? imageName;
//   String? imagePath;
//   bool? additional;
//   int? count;
//   String? createdAt;
//   String? updatedAt;
//   int? accidentReportId;
//
//   ImagesModel(
//       {this.id,
//       this.imageName,
//       this.imagePath,
//       this.additional,
//       this.count,
//       this.createdAt,
//       this.updatedAt,
//       this.accidentReportId});
//
//   ImagesModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? 0;
//     imageName = json['imageName'] ?? '';
//     imagePath = json['imagePath'] ?? '';
//     additional = json['additional'] ?? false;
//     count = json['count'] ?? 0;
//     createdAt = json['createdAt'] ?? '';
//     updatedAt = json['updatedAt'] ?? '';
//     accidentReportId = json['accidentReportId'] ?? 0;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'imageName': imageName,
//       'imagePath': imagePath,
//       'additional': additional,
//       'count': count,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'accidentReportId': accidentReportId,
//     };
//   }
// }
// //******************************************************************************
