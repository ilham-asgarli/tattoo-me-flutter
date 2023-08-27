part of 'designer_status_bloc.dart';

@immutable
abstract class DesignerStatusState {
  const DesignerStatusState();
}

class NoActiveDesigner extends DesignerStatusState {}

class HasDesigner extends DesignerStatusState {
  final int minRequestCount;

  const HasDesigner({
    required this.minRequestCount,
  });
}
