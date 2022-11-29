part of 'sign_bloc.dart';

abstract class SignEvent extends Equatable {
  const SignEvent();
}

class ChangeSignEvent extends SignEvent {
  @override
  List<Object?> get props => [];
}

class SigningEvent extends SignEvent {
  @override
  List<Object?> get props => [];
}

class SignedEvent extends SignEvent {
  @override
  List<Object?> get props => [];
}

class SignOutEvent extends SignEvent {
  @override
  List<Object?> get props => [];
}
