import 'package:ecom_app_bloc/src/providers/theme/theme.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //light theme
  static final ThemeData lightMode = ThemeData(
    colorScheme: MaterialTheme.lightMediumContrastScheme(),
  );

  //dark theme
  static final ThemeData darkMode = ThemeData(
    colorScheme: MaterialTheme.darkMediumContrastScheme(),
  );

  //initial theme
  ThemeData _themeData = lightMode;

  //getter
  ThemeData get themeData => _themeData;

  //dark mode getter
  bool get isDarkMode => _themeData == darkMode;

  //Constructor of thmeprovider class
  ThemeProvider() {
    final isDark = Utils.getCurrentTheme();
    _themeData = isDark ? darkMode : lightMode;
  }

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      Utils.saveCurrentTheme(true);
    } else {
      themeData = lightMode;
      Utils.saveCurrentTheme(false);
    }
  }
}
