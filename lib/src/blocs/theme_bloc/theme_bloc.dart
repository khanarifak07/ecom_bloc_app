import 'package:ecom_app_bloc/src/blocs/theme_bloc/theme_event.dart';
import 'package:ecom_app_bloc/src/blocs/theme_bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitialState()) {
    on<ChangeThemeEvent>(_changeTheme);
  }

  void _changeTheme(ChangeThemeEvent event, Emitter<ThemeState> emit) {
    final mode = event.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeChangedState(mode));
  }
}
