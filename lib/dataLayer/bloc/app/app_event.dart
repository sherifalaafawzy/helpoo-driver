part of 'app_bloc.dart';

abstract class AppBlocEvent extends Equatable {
  const AppBlocEvent();

  @override
  List<Object> get props => [];
}
// class AppBlocObserve extends AppBlocEvent {}

// class NetworkNotify extends AppBlocEvent {
//   final bool isConnected;

//   NetworkNotify({this.isConnected = false});
// }

class onConnected extends AppBlocEvent {}

class onNotConnected extends AppBlocEvent {}

class mainPackageInsuranceItems extends AppBlocEvent {}
