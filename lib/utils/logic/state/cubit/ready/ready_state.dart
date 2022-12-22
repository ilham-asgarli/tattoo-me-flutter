part of 'ready_cubit.dart';

abstract class ReadyState extends Equatable {
  const ReadyState();
}

class ReadyInitial extends ReadyState {
  @override
  List<Object> get props => [];
}
