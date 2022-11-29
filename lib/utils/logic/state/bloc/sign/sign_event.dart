part of 'sign_bloc.dart';

abstract class SignEvent extends Equatable {
  final UserModel? userModel;

  const SignEvent({this.userModel});

  @override
  List<dynamic> get props => [userModel];
}

class ChangeSignEvent extends SignEvent {
  const ChangeSignEvent({super.userModel});
}

class SigningEvent extends SignEvent {
  const SigningEvent({super.userModel});
}

class SignedEvent extends SignEvent {
  const SignedEvent({super.userModel});
}

class SignOutEvent extends SignEvent {
  const SignOutEvent({super.userModel});
}
