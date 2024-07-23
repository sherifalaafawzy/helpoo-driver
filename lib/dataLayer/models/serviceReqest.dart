import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/enum.dart';
import 'vehicle.dart';
import 'directionDetails.dart';
import 'driver.dart';

class ServiceRequest {
  ServiceRequest();

  MapPickerStatus fieldPin = MapPickerStatus.pickup;
  String? vehiclePhoneNumber;
  String? clientName;
  String? comment;
  String? clientPhone;
  String? corporateName;
  String? createdByUser;
  String? clientUserId;
  int? userId;
  var corporateCompanyId;
  int? clientId;
  DateTime? createdAt;
  Vehicle? car;
  DirectionDetails? driverDirectionDetails;
  bool isWorking = false;
  bool isClickAble = true;
  Vehicle? selectedCar;
  Driver driver = Driver();
  int? carServiceTypeId;
  int? id;
  String euroOriginalFees = "";
  String euroFees = "";
  String normOriginalFees = "";
  String normFees = "";
  String euroPercent = "";
  String normPercent = "";
  int? fees;
  int? originalFees;
  int? discount;
  int? discountPercentage;
  ServiceRequestStatus status = ServiceRequestStatus.create;
  PaymentStatus paymentStatus = PaymentStatus.pending;
  bool rated = false;
  var clientLatitude;
  var clientLongitude;
  var destination;
  double rating = 0;
  var destinationDistance;
  var distance;
  var distanceText;
  var distanceValue;
  bool promoCode = false;
  String? clientFcmToken;
  String? clientAddress;
  String? destinationAddress;
  int? selectedTowingService = 2;
  String paymentMethod = "";
  LatLng? pickup;
  LatLng? towingDestination;
  int? adminDiscount;

  String get link => "https://tracking.helpooapp.net/?id=$id";

  bool get create => status == ServiceRequestStatus.create;

  bool get open => status == ServiceRequestStatus.open;

  bool get confirmed => status == ServiceRequestStatus.confirmed;

  bool get accepted => status == ServiceRequestStatus.accepted;

  bool get arrived => status == ServiceRequestStatus.arrived;

  bool get started => status == ServiceRequestStatus.started;

  bool get destArrived => status == ServiceRequestStatus.destArrived;

  bool get done => status == ServiceRequestStatus.done;

  bool get pending => status == ServiceRequestStatus.pending;

  bool get canceled => status == ServiceRequestStatus.canceled;

  bool get notAvailable => status == ServiceRequestStatus.notAvailable;

  bool get notPaid => paymentStatus == PaymentStatus.notPaid;

  bool get paid => paymentStatus == PaymentStatus.paid;

  bool get pendingPayment => paymentStatus == PaymentStatus.pending;

  bool get needRefund => paymentStatus == PaymentStatus.needRefund;

  bool get refundDone => paymentStatus == PaymentStatus.refundDone;

  clearRequest() {
    fieldPin = MapPickerStatus.pickup;
    vehiclePhoneNumber = null;
    clientName = null;
    comment = null;
    isClickAble = true;
    clientPhone = null;
    corporateName = null;
    createdByUser = null;
    clientId = null;
    createdAt = null;
    car = null;
    driverDirectionDetails = null;
    isWorking = false;
    // selectedCar = null;
    driver = Driver();
    carServiceTypeId = null;
    id = null;
    fees = null;
    originalFees = null;
    discount = null;
    discountPercentage = null;
    adminDiscount = null;
    status = ServiceRequestStatus.create;
    paymentStatus = PaymentStatus.pending;
    rated = false;
    clientLatitude = null;
    clientLongitude = null;
    destination = null;
    rating = 0;
    destinationDistance = null;
    distance = null;
    distanceText = null;
    distanceValue = null;
    promoCode = false;
    clientFcmToken = null;
    clientAddress = null;
    destinationAddress = null;
    selectedTowingService = 2;
    paymentMethod = "";
    pickup = null;
    towingDestination = null;
  }

  parseStatus(val) {
    switch (val) {
      case 'open':
        return ServiceRequestStatus.open;
      case 'pending':
        return ServiceRequestStatus.pending;
      case 'confirmed':
        return ServiceRequestStatus.confirmed;
      case 'arrived':
        return ServiceRequestStatus.arrived;
      case 'canceled':
        return ServiceRequestStatus.canceled;
      case 'not_available':
        return ServiceRequestStatus.notAvailable;
      case 'accepted':
        return ServiceRequestStatus.accepted;
      case 'started':
        return ServiceRequestStatus.started;
      case 'pending':
        return ServiceRequestStatus.pending;
      case 'destArrived':
        return ServiceRequestStatus.destArrived;
      // case 'paid':
      //   return ServiceRequestStatus.paid;
      default:
        return ServiceRequestStatus.done;
    }
  }

  parsePaymentStatus(val) {
    switch (val) {
      case "not_paid":
        return PaymentStatus.notPaid;
      case "pending":
        return PaymentStatus.pending;
      case "paid":
        return PaymentStatus.paid;
      case "need_refund":
        return PaymentStatus.needRefund;
      case "refund_done":
        return PaymentStatus.refundDone;
      default:
        return PaymentStatus.notPaid;
    }
  }

  parsePaymentStatusToString(val) {
    switch (val) {
      case PaymentStatus.notPaid:
        return "not_paid";
      case PaymentStatus.paid:
        return "paid";
      case PaymentStatus.needRefund:
        return "need_refund";
      case PaymentStatus.refundDone:
        return "refund_done";
      case PaymentStatus.pending:
        return "pending";

      default:
        return "not_paid";
    }
  }

  ServiceRequest.fromJson(Map json, cubit) {
    cubit.request.id = json['id'];
    cubit.request.fees = json['fees'];
    cubit.request.createdByUser = json['User']['name'] ?? "";
    cubit.request.status = parseStatus(json['status']);
    cubit.request.paymentStatus = parsePaymentStatus(json['paymentStatus']);
    cubit.request.originalFees = json['originalFees'];
    cubit.request.discount = json['discount'];
    cubit.request.rated = json['rated'] ?? false;
    cubit.request.discountPercentage = json['discountPercentage'];
    cubit.request.adminDiscount = json['adminDiscount'];
    if (json['Driver'] != null) {
      cubit.request.driver = Driver.fromJson3(json['Driver']);
    }
    if (json['location'] != null) {
      cubit.request.pickup = LatLng(
          double.parse(json['location']['clientLatitude']),
          double.parse(json['location']['clientLongitude']));
      cubit.request.towingDestination = LatLng(
          double.parse(json['location']['destinationLat'].toString()),
          double.parse(json['location']['destinationLng'].toString()));
    }
  }

  ServiceRequest.fromJson1(Map json) {
    id = json['id'];
    clientName = json['name'] ?? '';
    fees = json['fees'] ?? '';
    discount = json['discount'] ?? 0;
    paymentStatus = parsePaymentStatus(json['paymentStatus']);
    discountPercentage = json['discountPercentage'] ?? 0;
    adminDiscount = json['adminDiscount'] ?? 0;
    createdAt = DateTime.parse(json['createdAt']);
    clientPhone = json['PhoneNumber'] ?? '';
    if (json['paymentMethod'] != null) {
      paymentMethod = json['paymentMethod'];
    }
    destinationAddress = json['destinationAddress'] ?? '';
    status = parseStatus(json['status']);
    comment = json['comment'] ?? "";
    car = Vehicle.fromJson(json['Car'] ?? {});
    originalFees = json['originalFees'] ?? '';
    rated = json['rated'] ?? false;
    destinationDistance = json['destinationDistance'] ?? "";
    corporateCompanyId = json['CorporateCompanyId'] ?? '';
    clientLatitude = json['location']['clientLatitude'] ?? "";
    clientLongitude = json['location']['clientLongitude'] ?? "";
    towingDestination = LatLng(
        double.parse(json['location']['destinationLat'].toString()),
        double.parse(json['location']['destinationLng'].toString()));
    clientAddress = json['location']['clientAddress'] ?? "";
    destinationAddress = json['location']['destinationAddress'] ?? "";
    pickup = LatLng(double.parse(clientLatitude.toString()),
        double.parse(clientLongitude.toString()));
    if (json['Client'] != null) {
      clientFcmToken =
          json['Client'] != null ? json['Client']['fcmtoken'] ?? '' : "";

      clientUserId = json['Client']['UserId'] != null
          ? json['Client']['UserId'].toString()
          : "";
    }
    createdByUser =
        json['createdByUser'] != null ? json['createdByUser'].toString() : "";
    if (json['Driver'] != null) {
      driver = Driver.fromJson3(json['Driver']);
    }
  }
}
