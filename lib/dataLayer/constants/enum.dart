enum PaymentStatus { notPaid, pending, paid, needRefund, refundDone }

enum MapPickerStatus { pickup, destination }

enum Role { public, client, inspector, driver, corporate }

enum ServiceRequestStatus {
  create,
  open,
  confirmed,
  pending,
  canceled,
  notAvailable,
  accepted,
  arrived,
  started,
  done,
  destArrived,
  paid
}

enum FNOLStatus {
  created,
  policeReport,
  bRepair,
  aRepair,
  appendix,
  billing,
  rightSave,
  done
}
