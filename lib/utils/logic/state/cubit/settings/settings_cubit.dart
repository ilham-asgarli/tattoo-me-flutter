import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../core/base/models/base_success.dart';
import '../../../../../domain/models/settings/settings_model.dart';
import '../../../../../domain/repositories/settings/implementations/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  StreamSubscription? _subscription;
  SettingsRepository settingsRepository = SettingsRepository();

  SettingsCubit() : super(const SettingsState()) {
    startListening();
  }

  void startListening() {
    _subscription =
        settingsRepository.getDesignRequestsSettingsStream().listen((event) {
      if (event is BaseSuccess<SettingsModel>) {
        emit(SettingsState(settingsModel: event.data));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
