import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeBloc extends Cubit<ThemeState> {
  ThemeBloc()
      : super(ThemeState(
          themeMode: ThemeMode.system,
          themeData: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        ));

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(
      themeMode: newThemeMode,
      themeData: state.themeData,
      darkTheme: state.darkTheme,
    ));
  }
}
