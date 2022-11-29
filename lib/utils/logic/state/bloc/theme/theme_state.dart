part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final AppTheme appTheme;
  final ThemeMode? themeMode;

  const ThemeState({
    required this.appTheme,
    this.themeMode,
  });

  @override
  List<Object?> get props => [
        appTheme,
        themeMode,
      ];
}
