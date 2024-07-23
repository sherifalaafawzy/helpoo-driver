// ignore_for_file: must_be_immutable

part of 'app_bloc.dart';

abstract class AppBlocState extends Equatable {
  const AppBlocState();
  @override
  List<Object> get props => [];
}

class AppBlocInitial extends AppBlocState {
  final lang;
  final seen;
  AppBlocInitial({required this.lang, this.seen});
}

class ChangeLanguage extends AppBlocState {
  final lang;
  ChangeLanguage({this.lang});
}

class selectedBox extends AppBlocState {}
class ChangePackageBenefits extends AppBlocState {}

class UnSelected extends AppBlocState {}
class updatePromoPackage extends AppBlocState {}
class changePromoPackage extends AppBlocState {}

class LanguageSelected extends AppBlocState {
  final languageSelected;
  LanguageSelected({this.languageSelected});
}

class ChangeSeen extends AppBlocState {
  final seen;
  ChangeSeen({this.seen});
}

class NetworkSuccess extends AppBlocState {
  final bool connected;
  NetworkSuccess({required this.connected});
}

class NetworkFailure extends AppBlocState {
  final bool connected;
  NetworkFailure({required this.connected});
}

class FetchItems extends AppBlocState {
  List<String> items = [];
  FetchItems({required this.items});
}

class ManufactorLoaded extends AppBlocState {
  final List<Manufacture> allManufactur;
  ManufactorLoaded({required this.allManufactur});
}

class ModelLoaded extends AppBlocState {
  final List<Model> allModels;
  ModelLoaded({required this.allModels});
}

class AddingVehicle extends AppBlocState {
  final List<Vehicle> allVehicles;
  AddingVehicle({required this.allVehicles});
}
