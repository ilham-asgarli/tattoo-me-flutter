part of 'sign_bloc.dart';

abstract class SignState extends Equatable {
  final UserModel userModel;

  const SignState({required this.userModel});

  SignState copyWith(UserModel userModel);

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

  @override
  SignUp copyWith(UserModel userModel) {
    return SignUp(userModel: userModel);
  }
}

class SigningUp extends SignUpState {
  const SigningUp({required super.userModel});

  @override
  SigningUp copyWith(UserModel userModel) {
    return SigningUp(userModel: userModel);
  }
}

class SignedUp extends SignUpState {
  const SignedUp({required super.userModel});

  @override
  SignedUp copyWith(UserModel userModel) {
    return SignedUp(userModel: userModel);
  }
}

class SignIn extends SignInState {
  const SignIn({required super.userModel});

  @override
  SignIn copyWith(UserModel userModel) {
    return SignIn(userModel: userModel);
  }
}

class SigningIn extends SignInState {
  const SigningIn({required super.userModel});

  @override
  SigningIn copyWith(UserModel userModel) {
    return SigningIn(userModel: userModel);
  }
}

class SignedIn extends SignInState {
  const SignedIn({required super.userModel});

  @override
  SignedIn copyWith(UserModel userModel) {
    return SignedIn(userModel: userModel);
  }
}

class SigningOut extends SignOutState {
  const SigningOut({required super.userModel});

  @override
  SigningOut copyWith(UserModel userModel) {
    return SigningOut(userModel: userModel);
  }
}
