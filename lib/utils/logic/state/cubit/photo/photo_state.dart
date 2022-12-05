part of 'photo_cubit.dart';

abstract class PhotoState extends Equatable {
  final bool isSwitch;

  const PhotoState(this.isSwitch);

  @override
  List<Object> get props => [isSwitch];
}

class PhotoOld extends PhotoState {
  const PhotoOld() : super(false);
}

class PhotoNew extends PhotoState {
  const PhotoNew() : super(true);
}
