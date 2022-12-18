part of 'retouch_alert_bloc.dart';

class RetouchAlertState extends Equatable {
  final RetouchSendingState retouchSendingState;

  const RetouchAlertState({required this.retouchSendingState});

  @override
  List<Object> get props => [retouchSendingState];
}
