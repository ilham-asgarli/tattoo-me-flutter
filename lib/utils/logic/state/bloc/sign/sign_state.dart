part of 'sign_bloc.dart';

abstract class SignState extends Equatable {
  final UserModel userModel;

  const SignState({required this.userModel});

  @override
  List<dynamic> get props => [userModel];
}

abstract class SignUpState extends SignState {
  const SignUpState({required super.userModel});
}

abstract class SignInState extends SignState {
  const SignInState({required super.userModel});
}

abstract class SignOutState extends SignState {
  const SignOutState({required super.userModel});
}

class SignUp extends SignUpState {
  const SignUp({required super.userModel});
}

class SigningUp extends SignUpState {
  const SigningUp({required super.userModel});
}

class SignedUp extends SignUpState {
  const SignedUp({required super.userModel});
}

class SignIn extends SignInState {
  const SignIn({required super.userModel});
}

class SigningIn extends SignInState {
  const SigningIn({required super.userModel});
}

class SignedIn extends SignInState {
  const SignedIn({required super.userModel});
}

class SigningOut extends SignOutState {
  const SigningOut({required super.userModel});
}
