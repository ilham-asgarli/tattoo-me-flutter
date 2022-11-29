import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'retouch_state.dart';

class RetouchCubit extends Cubit<RetouchState> {
  RetouchCubit() : super(RetouchInQueue());
}
