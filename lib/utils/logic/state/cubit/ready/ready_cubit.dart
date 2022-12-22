import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ready_state.dart';

class ReadyCubit extends Cubit<ReadyState> {
  ReadyCubit() : super(ReadyInitial());

  void rebuild() {
    emit(ReadyInitial());
  }
}
