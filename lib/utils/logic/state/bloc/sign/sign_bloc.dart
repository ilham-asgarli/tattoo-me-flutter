import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  SignBloc() : super(SignIn()) {
    on<ChangeSignEvent>(_onChangeSignEvent);
  }

  _onChangeSignEvent(ChangeSignEvent event, Emitter<SignState> emit) {
    emit(state is SignIn ? SignUp() : SignIn());
  }
}
