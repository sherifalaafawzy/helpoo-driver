part of 'service_request_bloc.dart';

abstract class ServiceRequestEvent extends Equatable {
  const ServiceRequestEvent();

  @override
  List<Object> get props => [];
}
class ServiceRequestObserve extends ServiceRequestEvent {}

class StatusNotify extends ServiceRequestEvent {
  final ServiceRequestStatus status;
  StatusNotify({this.status = ServiceRequestStatus.create});
}

class GetLocation extends ServiceRequestEvent {
  final Position? position;
  GetLocation({this.position});
}

class changeRadioState extends ServiceRequestEvent {
  final int? x;
   changeRadioState({this.x});
}
