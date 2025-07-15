import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);
  @override
  List<Object> get props => [themeMode];
}

class ThemeInitialState extends ThemeState {
  const ThemeInitialState() : super(ThemeMode.light);
}

class ThemeChangedState extends ThemeState {
  const ThemeChangedState(super.themeMode);
}
