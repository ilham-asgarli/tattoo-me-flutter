import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends HydratedBloc<SignEvent, SignState> {
  SignBloc() : super(SignIn(userModel: UserModel())) {
    on<RestoreSignInEvent>(_onRestoreSignInEvent);
    on<ChangeSignEvent>(_onChangeSignEvent);
    on<ChangeSignInStatusEvent>(_onChangeSignInStatusEvent);
    on<SigningEvent>(_onSigningEvent);
    on<SignedEvent>(_onSignedEvent);
    on<SigningOutEvent>(_onSigningOutEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<SignErrorEvent>(_onSignErrorEvent);
  }

  _onRestoreSignInEvent(RestoreSignInEvent event, Emitter<SignState> emit) {
    emit(SignIn(userModel: event.restoreSignInUserModel));
  }

  _onChangeSignEvent(ChangeSignEvent event, Emitter<SignState> emit) {
    emit(
      state is SignIn
          ? SignUp(userModel: state.userModel)
          : SignIn(userModel: state.userModel),
    );
  }

  _onChangeSignInStatusEvent(
      ChangeSignInStatusEvent event, Emitter<SignState> emit) {
    emit(
      state is SignIn
          ? SignedIn(userModel: state.userModel)
          : SignIn(userModel: state.userModel),
    );
  }

  _onSigningEvent(SigningEvent event, Emitter<SignState> emit) {
    if (state is SignUp) {
      emit(SigningUp(userModel: state.userModel));
    } else if (state is SignIn || state is SignedUp) {
      emit(SigningIn(userModel: state.userModel));
    }
  }

  _onSignedEvent(SignedEvent event, Emitter<SignState> emit) {
    if (state is SigningUp) {
      emit(SignedUp(userModel: state.userModel));
    } else if (state is SigningIn) {
      emit(SignedIn(userModel: event.signedUserModel));
    }
  }

  _onSigningOutEvent(SigningOutEvent event, Emitter<SignState> emit) {
    emit(SigningOut(userModel: state.userModel));
  }

  _onSignOutEvent(SignOutEvent event, Emitter<SignState> emit) {
    emit(SignIn(userModel: event.signOutUserModel));
  }

  _onSignErrorEvent(SignErrorEvent event, Emitter<SignState> emit) {
    if (state is SigningUp) {
      emit(SignUp(userModel: state.userModel));
    } else if (state is SigningIn) {
      emit(SignIn(userModel: state.userModel));
    }
  }

  @override
  SignState? fromJson(Map<String, dynamic> json) {
    return SignIn(userModel: UserModel().fromJson(json));
  }

  @override
  Map<String, dynamic>? toJson(SignState state) {
    return {"id": state.userModel.id};
  }
}
