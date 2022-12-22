import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../../../core/base/models/base_success.dart';
import '../../../../../domain/models/auth/user_model.dart';
import '../../../../../domain/repositories/auth/implementations/auto_auth_repository.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends HydratedBloc<SignEvent, SignState> {
  StreamSubscription? userSubscription;

  SignBloc() : super(SignIn(userModel: UserModel())) {
    on<RestoreSignInEvent>(_onRestoreSignInEvent);
    on<ChangeSignEvent>(_onChangeSignEvent);
    on<ChangeSignInStatusEvent>(_onChangeSignInStatusEvent);
    on<SigningEvent>(_onSigningEvent);
    on<SignedEvent>(_onSignedEvent);
    on<SigningOutEvent>(_onSigningOutEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<SignErrorEvent>(_onSignErrorEvent);
    on<ListenChangesEvent>(_onListenChangesEvent);
  }

  _onRestoreSignInEvent(RestoreSignInEvent event, Emitter<SignState> emit) {
    print("RestoreSignInEvent");
    emit(SignIn(userModel: event.restoreSignInUserModel));
    listenUser();
  }

  _onChangeSignEvent(ChangeSignEvent event, Emitter<SignState> emit) {
    print("ChangeSignEvent");
    emit(
      state is SignIn
          ? SignUp(userModel: state.userModel)
          : SignIn(userModel: state.userModel),
    );
  }

  _onChangeSignInStatusEvent(
      ChangeSignInStatusEvent event, Emitter<SignState> emit) {
    print("ChangeSignInStatusEvent");
    emit(
      state is SignIn
          ? SignedIn(userModel: state.userModel)
          : SignIn(userModel: state.userModel),
    );
    listenUser();
  }

  _onSigningEvent(SigningEvent event, Emitter<SignState> emit) {
    print("SigningEvent");
    if (state is SignUp) {
      emit(SigningUp(userModel: state.userModel));
    } else if (state is SignIn || state is SignedUp) {
      emit(SigningIn(userModel: state.userModel));
    }
  }

  _onSignedEvent(SignedEvent event, Emitter<SignState> emit) {
    print("SignedEvent");
    if (state is SigningUp) {
      emit(SignedUp(userModel: state.userModel));
    } else if (state is SigningIn) {
      emit(SignedIn(userModel: event.signedUserModel));
    }
    listenUser();
  }

  _onSigningOutEvent(SigningOutEvent event, Emitter<SignState> emit) {
    print("SigningOutEvent");
    emit(SigningOut(userModel: state.userModel));
  }

  _onSignOutEvent(SignOutEvent event, Emitter<SignState> emit) {
    print("SignOutEvent");
    emit(SignIn(userModel: event.signOutUserModel));
    listenUser();
  }

  _onSignErrorEvent(SignErrorEvent event, Emitter<SignState> emit) {
    print("SignErrorEvent");
    if (state is SigningUp) {
      emit(SignUp(userModel: state.userModel));
    } else if (state is SigningIn) {
      emit(SignIn(userModel: state.userModel));
    }
  }

  _onListenChangesEvent(ListenChangesEvent event, Emitter<SignState> emit) {
    print("ListenChangesEvent");
    emit(state.copyWith(event.listenChangesUserModel));
  }

  void listenUser() {
    AutoAuthRepository authRepository = AutoAuthRepository();

    userSubscription?.cancel();
    userSubscription =
        authRepository.getUserInfo(state.userModel.id ?? "").listen((event) {
      if (event is BaseSuccess<UserModel> && event.data != null) {
        add(ListenChangesEvent(listenChangesUserModel: event.data!));
      }
    });
  }

  @override
  SignState? fromJson(Map<String, dynamic> json) {
    return SignIn(userModel: UserModel().fromJson(json));
  }

  @override
  Map<String, dynamic>? toJson(SignState state) {
    return {"id": state.userModel.id};
  }

  @override
  Future<void> close() {
    userSubscription?.cancel();
    return super.close();
  }
}
