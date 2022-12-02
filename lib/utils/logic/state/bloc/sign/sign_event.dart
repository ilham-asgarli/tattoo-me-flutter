part of 'sign_bloc.dart';

abstract class SignEvent extends Equatable {
  final UserModel? userModel;

  const SignEvent({this.userModel});

  @override
  List<dynamic> get props => [userModel];
}

class RestoreSignInEvent extends SignEvent {
  final UserModel restoreSignInUserModel;

  const RestoreSignInEvent({required this.restoreSignInUserModel})
      : super(userModel: restoreSignInUserModel);
}

class ChangeSignEvent extends SignEvent {
  const ChangeSignEvent();
}

class ChangeSignInStatusEvent extends SignEvent {
  const ChangeSignInStatusEvent();
}

class SigningEvent extends SignEvent {
  const SigningEvent();
}

class SignedEvent extends SignEvent {
  final UserModel signedUserModel;

  const SignedEvent({required this.signedUserModel})
      : super(userModel: signedUserModel);
}

class SigningOutEvent extends SignEvent {
  const SigningOutEvent();
}

class SignOutEvent extends SignEvent {
  final UserModel signOutUserModel;

  const SignOutEvent({required this.signOutUserModel})
      : super(userModel: signOutUserModel);
}

class SignErrorEvent extends SignEvent {
  const SignErrorEvent();
}
