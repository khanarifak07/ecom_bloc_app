import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeThemeEvent extends ThemeEvent {
  final bool isDarkMode;

  ChangeThemeEvent(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}
