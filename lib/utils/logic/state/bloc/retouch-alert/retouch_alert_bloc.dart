import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/enums/app_enums.dart';

part 'retouch_alert_event.dart';
part 'retouch_alert_state.dart';

class RetouchAlertBloc extends Bloc<RetouchAlertEvent, RetouchAlertState> {
  RetouchAlertBloc()
      : super(const RetouchAlertState(
            retouchSendingState: RetouchSendingState.ready)) {
    on<StartRetouchSending>(_onStartRetouchSending);
    on<EndRetouchSending>(_onEndRetouchSending);
  }

  void _onStartRetouchSending(
      RetouchAlertEvent event, Emitter<RetouchAlertState> emit) {
    emit(
      const RetouchAlertState(
        retouchSendingState: RetouchSendingState.sending,
      ),
    );
  }

  void _onEndRetouchSending(
      RetouchAlertEvent event, Emitter<RetouchAlertState> emit) {
    emit(
      const RetouchAlertState(
        retouchSendingState: RetouchSendingState.sent,
      ),
    );
  }
}
