import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/core/services/shared_pref_service.dart';

part 'theme_state.dart';

class ThemeBloc extends Cubit<ThemeState> {
  final SharedPrefService _sharedPrefService;
  static const String themePreferenceKey = 'theme_preference';

  ThemeBloc(this._sharedPrefService)
      : super(ThemeState(themeMode: ThemeData())) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode =
        _sharedPrefService.getValue<bool>(themePreferenceKey, false);

    final newThemeMode = isDarkMode ? ThemeData.dark() : ThemeData.light();

    emit(ThemeState(themeMode: newThemeMode));
  }

  Future<void> toggleTheme() async {
    final isDarkMode = state.themeMode == ThemeData.dark();
    final newThemeMode = isDarkMode ? ThemeData.light() : ThemeData.dark();
    _sharedPrefService.putValue(themePreferenceKey, !isDarkMode);
    emit(ThemeState(themeMode: newThemeMode));
  }
}
