import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  SignBloc() : super(const SignIn()) {
    on<ChangeSignEvent>(_onChangeSignEvent);
    on<SigningEvent>(_onSigningEvent);
    on<SignedEvent>(_onSignedEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  _onChangeSignEvent(ChangeSignEvent event, Emitter<SignState> emit) {
    emit(
      state is SignIn
          ? SignUp(signUpUserModel: event.userModel)
          : SignIn(signInUserModel: event.userModel),
    );
  }

  _onSigningEvent(SigningEvent event, Emitter<SignState> emit) {
    if (state is SignUp) {
      emit(SigningUp(signUpUserModel: event.userModel));
    } else if (state is SignIn || state is SignedUp) {
      emit(SigningIn(signInUserModel: event.userModel));
    }
  }

  _onSignedEvent(SignedEvent event, Emitter<SignState> emit) {
    if (state is SigningUp) {
      emit(SignedUp(signUpUserModel: event.userModel));
    } else if (state is SigningIn) {
      emit(SignedIn(signInUserModel: event.userModel));
    }
  }

  _onSignOutEvent(SignOutEvent event, Emitter<SignState> emit) {
    emit(SignIn(signInUserModel: event.userModel));
  }
}
