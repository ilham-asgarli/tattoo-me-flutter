part of 'sign_bloc.dart';

abstract class SignState extends Equatable {
  const SignState();
}

abstract class SignUpState extends SignState {
  const SignUpState();
}

abstract class SignInState extends SignState {
  const SignInState();
}

class SignUp extends SignUpState {
  @override
  List<Object> get props => [];
}

class SigningUp extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignedUp extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignIn extends SignInState {
  @override
  List<Object> get props => [];
}

class SigningIn extends SignInState {
  @override
  List<Object> get props => [];
}

class SignedIn extends SignInState {
  @override
  List<Object> get props => [];
}
