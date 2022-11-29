import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  SignBloc() : super(SignIn()) {
    on<ChangeSignEvent>(_onChangeSignEvent);
    on<SigningEvent>(_onSigningEvent);
    on<SignedEvent>(_onSignedEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  _onChangeSignEvent(ChangeSignEvent event, Emitter<SignState> emit) {
    emit(state is SignIn ? SignUp() : SignIn());
  }

  _onSigningEvent(SigningEvent event, Emitter<SignState> emit) {
    if (state is SignUp) {
      emit(SigningUp());
    } else if (state is SignIn || state is SignedUp) {
      emit(SigningIn());
    }
  }

  _onSignedEvent(SignedEvent event, Emitter<SignState> emit) {
    if (state is SigningUp) {
      emit(SignedUp());
    } else if (state is SigningIn) {
      emit(SignedIn());
    }
  }

  _onSignOutEvent(SignOutEvent event, Emitter<SignState> emit) {
    emit(SignIn());
  }
}
