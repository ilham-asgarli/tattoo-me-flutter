part of 'retouch_alert_bloc.dart';

abstract class RetouchAlertEvent extends Equatable {
  const RetouchAlertEvent();
}

class StartRetouchSending extends RetouchAlertEvent {
  @override
  List<Object?> get props => [];
}

class EndRetouchSending extends RetouchAlertEvent {
  @override
  List<Object?> get props => [];
}
