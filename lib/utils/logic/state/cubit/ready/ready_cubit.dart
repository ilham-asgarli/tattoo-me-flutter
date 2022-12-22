import 'package:bloc/bloc.dart';

part 'ready_state.dart';

class ReadyCubit extends Cubit<ReadyState> {
  ReadyCubit() : super(ReadyInitial());

  void rebuild() {
    emit(ReadyInitial());
  }
}
