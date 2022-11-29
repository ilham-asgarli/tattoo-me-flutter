import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../ui/constants/enums/app_theme_enum.dart';
import '../../../helpers/theme/theme_helper.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
          ThemeState(
            appTheme: AppTheme.main,
            themeMode: ThemeHelper.instance.getThemeModePreference(),
          ),
        ) {
    on<ChangeTheme>(_onChangeTheme);
  }

  _onChangeTheme(ChangeTheme event, Emitter<ThemeState> emit) {
    emit(
      ThemeState(
        appTheme: event.appTheme,
        themeMode: event.themeMode,
      ),
    );
  }
}
