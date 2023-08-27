part of 'designer_status_bloc.dart';

@immutable
abstract class DesignerStatusEvent {
  const DesignerStatusEvent();
}

class ChangeDesignerRequestCount extends DesignerStatusEvent {
  final int minRequestCount;

  const ChangeDesignerRequestCount({
    required this.minRequestCount,
  });
}
