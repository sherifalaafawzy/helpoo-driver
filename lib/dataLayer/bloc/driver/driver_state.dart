part of 'driver_cubit.dart';

abstract class DriverState {}

class DriverInitial extends DriverState {}

class DriverGetDriverRequests extends DriverState {
  List<dynamic> driverRequests = [];
  DriverGetDriverRequests({required this.driverRequests});
}

class DriverGetDriverRequestsLoading extends DriverState {}

class UpdateLocation extends DriverState {
  bool success = false;
  UpdateLocation({required this.success});
}

class UpdateRequestLoadingStatus extends DriverState {}

class UpdateRequestSuccessStatus extends DriverState {}

class UpdateRequestFailedStatus extends DriverState {}
class UnAssinDriver extends DriverState {}
