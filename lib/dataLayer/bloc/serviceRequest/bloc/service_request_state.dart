part of 'service_request_bloc.dart';

abstract class ServiceRequestState extends Equatable {
  const ServiceRequestState();

  @override
  List<Object> get props => [];
}

class ServiceRequestInitial extends ServiceRequestState {}

class GetMap extends ServiceRequestState {}

class StatusChanged extends ServiceRequestState {}

class changeRadioPremium extends ServiceRequestState {}
class changeRadioNormal extends ServiceRequestState {}

class destinationReady extends ServiceRequestState {}

class currentReady extends ServiceRequestState {}
class changeCarState extends ServiceRequestState {}
class changeCarTwiceState extends ServiceRequestState {}
class changePickerUsability extends ServiceRequestState {}

