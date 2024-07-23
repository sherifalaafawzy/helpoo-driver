import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'FNOLMedia.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../presitationLayer/pages/user_home_content/FNOL/FNOLMapPicker.dart';
import '../../presitationLayer/pages/user_home_content/FNOL/FNOLStepDone.dart';
import '../constants/enum.dart';
import 'currentUser.dart';
import 'locationAddress.dart';
import '../../presitationLayer/pages/user_home_content/FNOL/airBagImageInput.dart';
import '../../presitationLayer/pages/user_home_content/FNOL/imageInput.dart';
import 'FNOLType.dart';
import 'imagesModel.dart';
import 'vehicle.dart';

class FNOL {
  FNOL();

  int? id;
  Vehicle? selectedCar;
  List<String> pdf = [];
  List<ImagesModel> mainImages = [];
  List<ImagesModel> allImages = [];
  List<FNOLType> selectedTypes = [];
  List<String> requiredImages = [];

  // List<String> imagesTaked = [];
  List statusList = [];
  List<String> airBagImages = [];
  List<String> policeReportImages = [];
  List<String> repairReportImages = [];
  List<String> supplementImages = [];
  List<String> resurveyImages = [];
  MediaController mediaController = MediaController();
  DateTime? billDeliveryDate;
  String billingAddress = "";
  LatLng? billingAddressLatLng;
  String? beforeRepairAddress;
  String? supplementAddress;
  String? resurveyAddress;
  String? aRepairAddress;
  String? rightSaveAddress;
  List beforeRepairLocation = [];
  String? bRepairLocation;
  String? supplementLocation;
  String? resurveyLocation;
  String? aRepairLocation;
  String? rightSaveLocation;
  LatLng? beforeRepairAddressLatLng;
  LatLng? supplementAddressLatLng;
  LatLng? resurveyAddressLatLng;
  LatLng? aRepairAddressLatLng;
  LatLng? rightSaveAddressLatLng;
  FNOLStatus status = FNOLStatus.created;
  DateTime? createdAt;
  XFile? picture;
  List<XFile>? galleryImages;
  int imageCounter = 0;
  int allImagesCounter = 0;
  List billDeliveryTimeRangeList = [];
  String billDeliveryTimeRange = "";
  String billDeliveryNotes = "";
  List billDeliveryNotesList = [];
  GetStorage prefs = GetStorage();
  String? base64String;
  LocationAddress? addressLatLng;
  LocationAddress? billDeliveryLocation;
  LocationAddress? beforeRepairAddress2;
  LocationAddress? afterRepairAddress2;
  String? base64String2;
  LatLng? currentLocation;
  String currentAddress = "";
  String comment = "";
  int? createdByUser;
  String? img1,
      img2,
      img3,
      img4,
      img5,
      img6,
      // img7,
      img8,
      img9,
      // img10,
      img11,
      img12,
      img13,
      img14,
      img15,
      // img16,
      img17,
      img18,
      // img19,
      img20,
      img21,
      img22,
      img23,
      img24,
      internalImg1,
      internalImg2,
      internalImg3,
      internalImg4,
      internalImg5,
      internalImg6,
      idImg1,
      idImg2,
      idImg3,
      idImg4,
      glassImg1,
      glassImg2,
      glassImg3,
      glassImg4,
      glassImg5,
      video,
      report;

  List<FNOLType> get types => FNOLType.types;

  get preInseption => types.firstWhere((element) => element.id == 2);

  get frontAccident => types.firstWhere((element) => element.id == 3);

  get backAccident => types.firstWhere((element) => element.id == 4);

  get rightSideAccident => types.firstWhere((element) => element.id == 5);

  get leftSideAccident => types.firstWhere((element) => element.id == 6);

  get frontGlassAccident => types.firstWhere((element) => element.id == 7);

  get fullCarAccident => types.firstWhere((element) => element.id == 8);

  get checkIn => types.firstWhere((element) => element.id == 9);

  get checkOut => types.firstWhere((element) => element.id == 10);

  get carRoofAccident => types.firstWhere((element) => element.id == 11);

  get repairReport => types.firstWhere((element) => element.id == 12);

  get rearGlassAccident => types.firstWhere((element) => element.id == 13);

  Map<String, String> imagesNamesEn = {
    "img1": "Vin Number",
    "img2": "Odometer",
    "img3": "Hood, Grilles and Headlights",
    "img4": "Front Bumper",
    "img5": "Windshield",
    "img6": "Front Right corner",
    // "img7": "Right Front Fender and Right Front Rim",
    "img8": "Front Right Door, Fender & Rim",
    "img9": "Rear Right Door, Fender & Rim",
    // "img10": "Right Rear Fender and Right Rear Rim",
    "img11": "Rear Right corner",
    "img12": "Trunk and Tail Lights",
    "img13": "Rear Bumper",
    "img14": "Rear Glass",
    "img15": "Rear Left corner",
    // "img16": "Left Rear Fender and Left Rear Rim",
    "img17": "Rear Left Door, Fender & Rim",
    "img18": "Front Left Door, Fender & Rim",
    // "img19": "Left Front Fender and Left Front Rim",
    "img20": "Front Left corner",
    "img21": "Roof of the vehicle from the Left side",
    "img22": "Roof of the vehicle from the Right side",
    "img23": "vehicle Engine Basin",
    "img24": "Trunk of the vehicle from the inside",
    "internal_img1": "Front Salon",
    "internal_img2": "Rear Salon",
    "internal_img3": "Steering Wheel",
    "internal_img4": "Transmission",
    "internal_img5": "vehicle Engine Basin",
    "internal_img6": "Trunk of the vehicle from inside",
    "id_img1": "Front of Driver's License",
    "id_img2": "Back of  Driver's License",
    "id_img3": "Front of vehicle License",
    "id_img4": "Back of vehicle License",
    "id_img5": "Front of National ID",
    "id_img6": "Back of National ID",
    "glass_img1": "Right Corner Windshield",
    "glass_img2": "Left Corner Windshield",
    "glass_img3": "Windshield from the corner of the driver's seat",
    "glass_img4": "Passenger seat angle front windshield",
  };

  Map<String, String> imagesNamesAr = {
    "img1": "رقم الشاسية",
    "img2": "عداد الكيلومتر",
    "img3": "الكبوت و الشبكة و الكشافات الأمامية",
    "img4": "الاكصدام الأمامي",
    "img5": "الزجاج الأمامي",
    "img6": "الزاوية الأمامية اليمنى",
    // "img7": "الرفرف الأمامي الايمن و الجنط الأمامي الايمن",
    "img8": "الباب و الرفرف و الجنط الأمامي الايمن",
    "img9": "الباب و الرفرف و الجنط الخلفي الايمن",
    // "img10": "الرفرف الخلفي الايمن و الجنط الخلفي الايمن",
    "img11": "الزاوية الخلفية اليمنى",
    "img12": "الشنطة و الكشافات الخلفية",
    "img13": "الاكصدام الخلفي",
    "img14": "الزجاج الخلفي",
    "img15": "الزاوية الخلفية اليسرى",
    // "img16": "الرفرف الخلفي الايسر و الجنط الخلفي الايسر",
    "img17": "الباب و الرفرف و الجنط الخلفي الايسر",
    "img18": "الباب و الرفرف و الجنط الأمامي الايسر",
    // "img19": "الرفرف الأمامي الايسر و الجنط الأمامي الايسر",
    "img20": "الزاوية الأمامية اليسرى",
    "img21": "سقف السيارة من الجانب الايسر",
    "img22": "سقف السيارة من الجانب الايمن",
    "img23": "حوض موتور السيارة",
    "img24": "شنطة السيارة من الداخل",
    "internal_img1": "الصالون الأمامي",
    "internal_img2": "الصالون الخلفي",
    "internal_img3": "عجلة القيادة",
    "internal_img4": "ناقل الحركة",
    "internal_img5": "حوض موتور السيارة",
    "internal_img6": "شنطة السيارة من الداخل",
    "id_img1": "صورة رخصة السائق الأمامية",
    "id_img2": "صورة رخصة السائق الخلفية",
    "id_img3": "صورة رخصة السيارة الأمامية",
    "id_img4": "صورة رخصة السيارة الخلفية",
    "id_img5": "صورة الرقم القومي الأمامية",
    "id_img6": "صورة الرقم القومي الخلفية",
    "glass_img1": "الزجاج الأمامي من الزاوية اليمنى",
    "glass_img2": "الزجاج الأمامي من الزاوية اليسرى",
    "glass_img3": "الزجاج الأمامي من زاوية مقعد السائق",
    "glass_img4": "الزجاج الأمامي من زاوية مقعد الراكب",
  };

  String? getImageObject(String imgName) {
    switch (imgName) {
      case "img1":
        return img1;
      case "img2":
        return img2;
      case "img3":
        return img3;
      case "img4":
        return img4;
      case "img5":
        return img5;
      case "img6":
        return img6;
      // case "img7":
      //   return img7;
      case "img8":
        return img8;
      case "img9":
        return img9;
      // case "img10":
      //   return img10;
      case "img11":
        return img11;
      case "img12":
        return img12;
      case "img13":
        return img13;
      case "img14":
        return img14;
      case "img15":
        return img15;
      // case "img16":
      //   return img16;
      case "img17":
        return img17;
      case "img18":
        return img18;
      // case "img19":
      //   return img19;
      case "img20":
        return img20;
      case "img21":
        return img21;
      case "img22":
        return img22;
      case "img23":
        return img23;
      case "img24":
        return img24;
      case "internal_img1":
        return internalImg1;
      case "internal_img2":
        return internalImg2;
      case "internal_img3":
        return internalImg3;
      case "internal_img4":
        return internalImg4;
      case "internal_img5":
        return internalImg5;
      case "internal_img6":
        return internalImg6;
      case "id_img1":
        return idImg1;
      case "id_img2":
        return idImg2;
      case "id_img3":
        return idImg3;
      case "id_img4":
        return idImg4;
      case "glass_img1":
        return glassImg1;
      case "glass_img2":
        return glassImg2;
      case "glass_img3":
        return glassImg3;
      case "glass_img4":
        return glassImg4;
      case "glass_img5":
        return glassImg5;
      default:
        return null;
    }
  }

  upload(
      {required int idx, required String fileNamePrefix, required bloc}) async {
    if (fileNamePrefix == 'air_bag_images') {
      bloc.uploadImageFNOL(
          fileNamePrefix + idx.toString(), base64String2, bloc.fnol.id, true);
    } else if (fileNamePrefix == 'police') {
      try {
        bloc.uploadImageFNOL(
            fileNamePrefix + idx.toString(), base64String2, bloc.fnol.id, true);
      } catch (e) {
        print('error is = ${e.toString()}');
      }
    } else if (fileNamePrefix == 'repair_before') {
      bloc.uploadImageFNOL(
          fileNamePrefix + idx.toString(), base64String2, bloc.fnol.id, true);
    } else if (fileNamePrefix == 'supplement') {
      bloc.uploadImageFNOL(
          fileNamePrefix + idx.toString(), base64String2, bloc.fnol.id, true);
    } else if (fileNamePrefix == 'resurvey') {
      bloc.uploadImageFNOL(
          fileNamePrefix + idx.toString(), base64String2, bloc.fnol.id, true);
    }
  }

  uploadMultipleImages(
      {required CameraController? controller,
      required int idx,
      required String fileNamePrefix,
      required bloc}) async {
    if (fileNamePrefix == 'air_bag_images') {
      picture = await controller!.takePicture();
      Uint8List imagebytes = await bloc.fnol.picture.readAsBytes();
      base64String2 = base64.encode(imagebytes);
      bloc.fnol.airBagImages.add(base64String2);
      bloc.fnol
          .setImage(fileNamePrefix + idx.toString(), bloc.fnol.picture.path);
    } else if (fileNamePrefix == 'police') {
      try {
        picture = await controller!.takePicture();
        Uint8List imagebytes = await bloc.fnol.picture.readAsBytes();
        base64String2 = base64.encode(imagebytes);
        bloc.fnol.policeReportImages.add(base64String2);
        bloc.fnol
            .setImage(fileNamePrefix + idx.toString(), bloc.fnol.picture.path);
      } catch (e) {
        print('error is = ${e.toString()}');
      }
    } else if (fileNamePrefix == 'repair_before') {
      picture = await controller!.takePicture();
      Uint8List imagebytes = await bloc.fnol.picture.readAsBytes();
      base64String2 = base64.encode(imagebytes);
      bloc.fnol.repairReportImages.add(base64String2);
      bloc.fnol
          .setImage(fileNamePrefix + idx.toString(), bloc.fnol.picture.path);
    } else if (fileNamePrefix == 'supplement') {
      picture = await controller!.takePicture();
      Uint8List imagebytes = await bloc.fnol.picture.readAsBytes();
      base64String2 = base64.encode(imagebytes);
      bloc.fnol.supplementImages.add(base64String2);
      bloc.fnol
          .setImage(fileNamePrefix + idx.toString(), bloc.fnol.picture.path);
    } else if (fileNamePrefix == 'resurvey') {
      picture = await controller!.takePicture();
      Uint8List imagebytes = await bloc.fnol.picture.readAsBytes();
      base64String2 = base64.encode(imagebytes);
      bloc.fnol.resurveyImages.add(base64String2);
      bloc.fnol
          .setImage(fileNamePrefix + idx.toString(), bloc.fnol.picture.path);
    }
  }

  pickupMultiImagesForReports(bloc, fileNamePrefix, type) async {
    final ImagePicker _picker = ImagePicker();
    debugPrint('====>>> Pick Multi Image');
    galleryImages = await _picker.pickMultiImage();

    if(galleryImages!.isEmpty) {
      return;
    }

    if (fileNamePrefix == 'police') {
      for (int i = 0; i < galleryImages!.length; i++) {
        bloc.fnol.setImage(
            fileNamePrefix + (i).toString(), bloc.fnol.galleryImages![i].path);
        Uint8List imagebytes = await bloc.fnol.galleryImages![i].readAsBytes();
        String base64String = base64.encode(imagebytes);
        bloc.fnol.policeReportImages.add(base64String);

        bloc.uploadImageFNOL(
            fileNamePrefix + i.toString(), base64String, bloc.fnol.id, true);
      }
      await bloc.updateStatus("policeReport", bloc.fnol.id);
      Get.to(() => fnolStepDone(bloc.fnol,from:fileNamePrefix ,));
      // Get.to(() => homeScreen(index: 0));
    } else if (fileNamePrefix == 'repair_before') {
      for (int i = 0; i < galleryImages!.length; i++) {
        if (type == "supplement") {
          await bloc.updateStatus("supplement" + i.toString(), bloc.fnol.id);
          Get.to(() => fnolMapPicker(fnolType: fileNamePrefix));
        } else if (type == "bRepair") {
          await bloc.updateStatus("bRepair", bloc.fnol.id);
        } else {
          bloc.fnol.setImage(fileNamePrefix + (i).toString(),
              bloc.fnol.galleryImages![i].path);
          Uint8List imagebytes =
              await bloc.fnol.galleryImages![i].readAsBytes();
          String base64String = base64.encode(imagebytes);
          bloc.fnol.repairReportImages.add(base64String);

          bloc.uploadImageFNOL(
              fileNamePrefix + i.toString(), base64String, bloc.fnol.id, true);
          Get.to(() => fnolMapPicker(fnolType: fileNamePrefix));
        }
      }
    } else if (fileNamePrefix == "supplement") {
      for (int i = 0; i < galleryImages!.length; i++) {
        bloc.fnol.setImage(
            fileNamePrefix + (i).toString(), bloc.fnol.galleryImages![i].path);
        Uint8List imagebytes = await bloc.fnol.galleryImages![i].readAsBytes();
        String base64String = base64.encode(imagebytes);
        bloc.fnol.supplementImages.add(base64String);

        bloc.uploadImageFNOL(
            fileNamePrefix + i.toString(), base64String, bloc.fnol.id, true);
      }
      await bloc.updateStatus("supplement", bloc.fnol.id);
      Get.to(() => fnolMapPicker(fnolType: fileNamePrefix));

      // Get.to(() => homeScreen(index: 0));
    } else if (fileNamePrefix == "resurvey") {
      for (int i = 0; i < galleryImages!.length; i++) {
        bloc.fnol.setImage(
            fileNamePrefix + (i).toString(), bloc.fnol.galleryImages![i].path);
        Uint8List imagebytes = await bloc.fnol.galleryImages![i].readAsBytes();
        String base64String = base64.encode(imagebytes);
        bloc.fnol.resurveyImages.add(base64String);

        bloc.uploadImageFNOL(
            fileNamePrefix + i.toString(), base64String, bloc.fnol.id, true);
      }
      await bloc.updateStatus("resurvey", bloc.fnol.id);
      Get.to(() => fnolMapPicker(fnolType: fileNamePrefix));
      // Get.to(() => homeScreen(index: 0));
    }
    // Get.to(() => homeScreen(index: 0));
  }

  List<String> get requiredImagesList {
    List<String> images = [];
    for (var item in selectedTypes) {
      for (var img in item.requiredImages) {
        if (!images.contains(img)) {
          images.add(img);
        }
      }
    }
    for (var i = 0; i < images.length; i++) {
      if (images[i] == "air_bag_images") {
        String key = images[i];
        images.remove(images[i]);
        images.insert(images.length, key);
      }
    }
    return images;
  }

  Future<void> takeRequiredImage(
      {required FNOL fnol,
      required CameraController controller,
      required String requiredImage,
      required int idx,
      required bloc}) async {
    XFile picture = await controller.takePicture();
    Uint8List imagebytes = await picture.readAsBytes();
    base64String = base64.encode(imagebytes);
    // imagesTaked.add(base64String!);
    fnol.setImage(requiredImage, picture.path);
  }

  setImage(String requiredImage, String imgPath) {
    prefs.write(requiredImage, imgPath);
  }

  Future<String> getImage(String requiredImage) async {
    return prefs.read(requiredImage) ?? '';
  }

  nextImagePage({required bloc, required int idx}) {
    if (idx == -1) {
      // find first null image
      for (var i = 0; i < bloc.fnol.requiredImagesList!.length; i++) {
        var key = bloc.fnol.requiredImagesList![i];
        if (key == "air_bag_images") {
          if (bloc.fnol.airBagImages.isEmpty ||
              (i == bloc.fnol.requiredImagesList!.length - 1 &&
                  bloc.fnol.airBagImages.isEmpty
              // &&
              //     (accidentReport.video == null ||
              //         accidentReport.video!.data.attributes.url.isEmpty)
              )) {
            Get.to(() => airBageImageInput(
                  idx: i,
                  accidentReport: bloc.fnol,
                ));
            return;
          }
        } else {
          String? img = bloc.fnol.getImageObject(key);
          if (img == null) {
            Get.to(() => imageInput(idx: i, requiredImage: key),
                preventDuplicates: false);
            return;
          }
        }
      }
      // if (accidentReport.video == null ||
      //     accidentReport.video!.data.attributes.url.isEmpty) {
      //   Get.to(VideoRecordingPage(accidentReport: accidentReport));
      //   return;
      // } else {
      // Get.to(AccidentReportSummaryPage(
      //   report: bloc.fnol,
      // ));
      // }
    } else if (idx < bloc.fnol.requiredImagesList!.length - 1) {
      /// air_bag_images case
      String requiredImage = bloc.fnol.requiredImagesList![idx + 1];
      if (requiredImage == "air_bag_images") {
        Get.to(() => airBageImageInput(
              idx: idx + 1,
              accidentReport: bloc.fnol,
            ));
      } else {
        Get.to(
            () => imageInput(
                idx: idx + 1,
                requiredImage: bloc.fnol.requiredImagesList![idx + 1]),
            preventDuplicates: false);
      }
    } else {
      // Get.snackbar("Notice", "Last image taken");
      // if (
      // accidentReport.video == null ||
      // accidentReport.video!.data.attributes.url.isEmpty) {
      //   Get.to(VideoRecordingPage(accidentReport: accidentReport));
      //   return;
      // } else {
      //        Get.to(AccidentReportSummaryPage(report: accidentReport));
      // }
    }
  }

  String getImageDescription(String requiredImage) {
    try {
      if (CurrentUser.isEnglish) {
        return imagesNamesEn[requiredImage] ?? requiredImage;
      } else {
        return imagesNamesAr[requiredImage] ?? requiredImage;
      }
    } catch (e) {
      return requiredImage;
    }
  }

  FNOL.fromJson(Map json, bloc) {
    bloc.fnol.id = json['id'];
    bloc.fnol.createdByUser = json['createdByUser'];
    bloc.fnol.createdAt = DateTime.parse(json['createdAt']);
    bloc.fnol.status = parseStatus(json['status']);
  }

  FNOL.fromJson1(Map json, bloc) {
    id = json['id'];
    createdByUser = json['createdByUser'] ?? '';
    beforeRepairLocation = json['bRepairName'] ?? [];
    statusList = json['statusList'] ?? [];
    comment = json['comment'] ?? "no comment";
    // comment = json['comment'] ?? "no comment";
    mediaController.audioFilePath = json['commentUser'] ?? "";
    createdAt = DateTime.parse(json['createdAt']);
    status = parseStatus(json['status']) ?? "";
    if (json['Car'] != null) {
      selectedCar = Vehicle.fromJson(json['Car']);
    }
    billDeliveryNotesList = json['billDeliveryNotes'] ?? [];
    if (json['images'] != null) {
      allImages = List<ImagesModel>.from(
          json['images'].map((images) => ImagesModel.fromJson(images)));
    }

    if (json['CarAccidentReports'] != null) {
      Iterable I = json['CarAccidentReports'];
      I.forEach((element) {
        pdf.add(element['report']);
      });
    }

    if (json['beforeRepairLocation'] != null) {
      // beforeRepairAddress = json['beforeRepairLocation'][0]['address'];
      Iterable I = json['beforeRepairLocation'];
      beforeRepairAddress = I.last['address'];
      beforeRepairAddressLatLng = LatLng(
          I.last['lat'] as double, I.last['lng'] as double);
    }
    if (json['billDeliveryLocation'] != null) {
      // billingAddress = json['billDeliveryLocation'][0]['address'];
      Iterable I = json['billDeliveryLocation'];
      billingAddress = I.last['address'];
      billingAddressLatLng = LatLng(
          I.last['lat'] as double, I.last['lng'] as double);
    }
    if (json['afterRepairLocation'] != null) {
      // aRepairAddress = json['afterRepairLocation'][0]['address'];
      // aRepairLocation = json['afterRepairLocation'][0]['name'];
      Iterable I = json['afterRepairLocation'];
      aRepairAddress = I.last['address'];
      aRepairLocation = I.last['name'];
      aRepairAddressLatLng = LatLng(
          I.last['lat'] as double, I.last['lng'] as double);

      printWarning('PPP=====>> ${aRepairAddressLatLng?.latitude ?? '------'}');
      printWarning('PPP=====>> ${aRepairAddressLatLng?.longitude ?? '------'}');
    }
    if (json['rightSaveLocation'] != null) {
      Iterable I = json['rightSaveLocation'];
      rightSaveAddress = I.last['address'];
      rightSaveLocation = I.last['name'];
      rightSaveAddressLatLng = LatLng(
          I.last['lat'] as double, I.last['lng'] as double);
    }
    if (json['supplementLocation'] != null) {
      Iterable I = json['supplementLocation'] ?? [];
      supplementAddress = I.isNotEmpty ? I.last['address'] : "";
      supplementLocation = I.isNotEmpty ? I.last['name'] : "";
      supplementAddressLatLng = LatLng(
          I.last['lat'] as double, I.last['lng'] as double);
    }
    if (json['resurveyLocation'] != null) {
      Iterable I = json['resurveyLocation'] ?? [];
      resurveyAddress = I.isNotEmpty ? I.last['address'] : "";
      resurveyLocation = I.isNotEmpty ? I.last['name'] : "";
      resurveyAddressLatLng = LatLng(
          I.last['lat'] as double, I.last['lng'] as double);
    }

    if (json['location'] != null) {
      currentAddress = json['location']['address'] as String;
      addressLatLng = LocationAddress.fromJson(json['location']);
    }

    billDeliveryTimeRangeList = json['billDeliveryTimeRange'] ?? [];
    if (json['billDeliveryDate'] != null) {
      Iterable I = json['billDeliveryDate'];
      billDeliveryDate = DateTime.parse(I.last);
    }
  }

  parseStatus(val) {
    switch (val) {
      case 'created':
        return FNOLStatus.created;
      case 'policeReport':
        return FNOLStatus.policeReport;
      case 'bRepair':
        return FNOLStatus.bRepair;
      case 'aRepair':
        return FNOLStatus.aRepair;
      case 'appendix':
        return FNOLStatus.appendix;
      case 'billing':
        return FNOLStatus.billing;
      case 'rightSave':
        return FNOLStatus.rightSave;
      case 'done':
        return FNOLStatus.done;
      default:
        return FNOLStatus.created;
    }
  }
}
