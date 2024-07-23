part of 'fnol_bloc.dart';

abstract class FnolEvent extends Equatable {
  const FnolEvent();

  @override
  List<Object> get props => [];
}

class GetLocation extends FnolEvent {
  final Position? position;
  GetLocation({this.position});
}


class EmptyEvent extends FnolEvent {}
