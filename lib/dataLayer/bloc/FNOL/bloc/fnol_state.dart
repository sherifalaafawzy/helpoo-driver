part of 'fnol_bloc.dart';

abstract class FnolState extends Equatable {
  const FnolState();

  @override
  List<Object> get props => [];
}

class FnolInitial extends FnolState {}

class EmptyState extends FnolState {}

class GetTypes extends FnolState {}

class GetCurrentPosition extends FnolState {
  bool isFirstTime;

  GetCurrentPosition({
    this.isFirstTime = true,
  });
}

class selectedBox extends FnolState {}

class unSelectedBox extends FnolState {}

class imageTake extends FnolState {}

class counterUpdate extends FnolState {}

class imageNotTake extends FnolState {}

class locationAdded extends FnolState {}

class billLocationAdded extends FnolState {
  bool isSelectFromPopUp;

  billLocationAdded({
    this.isSelectFromPopUp = false,
  });
}

class billAdded extends FnolState {}

class FcmRestApiSuccess extends FnolState {}

class FcmRestApiError extends FnolState {
  final String error;

  FcmRestApiError({
    required this.error,
  });
}
