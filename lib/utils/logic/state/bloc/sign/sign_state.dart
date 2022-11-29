part of 'sign_bloc.dart';

abstract class SignState extends Equatable {
  final UserModel? userModel;

  const SignState({this.userModel});

  @override
  List<dynamic> get props => [userModel];
}

abstract class SignUpState extends SignState {
  final UserModel? signUpUserModel;

  const SignUpState({this.signUpUserModel}) : super(userModel: signUpUserModel);

  @override
  List<dynamic> get props => [signUpUserModel];
}

abstract class SignInState extends SignState {
  final UserModel? signInUserModel;

  const SignInState({this.signInUserModel}) : super(userModel: signInUserModel);

  @override
  List<dynamic> get props => [signInUserModel];
}

class SignUp extends SignUpState {
  const SignUp({super.signUpUserModel});
}

class SigningUp extends SignUpState {
  const SigningUp({super.signUpUserModel});
}

class SignedUp extends SignUpState {
  const SignedUp({super.signUpUserModel});
}

class SignIn extends SignInState {
  const SignIn({super.signInUserModel});
}

class SigningIn extends SignInState {
  const SigningIn({super.signInUserModel});
}

class SignedIn extends SignInState {
  const SignedIn({super.signInUserModel});
}
