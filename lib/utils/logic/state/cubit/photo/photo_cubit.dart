import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit() : super(const PhotoNew());

  void changePhoto() {
    emit(state is PhotoNew ? const PhotoOld() : const PhotoNew());
  }

  void showOldPhoto() {
    emit(const PhotoOld());
  }

  void showNewPhoto() {
    emit(const PhotoNew());
  }
}
