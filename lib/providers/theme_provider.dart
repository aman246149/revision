import 'package:dsanotes/theme/custom_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData themeData = AppTheme.darkTheme();
  bool lightTheme = true;

  void switchCurrentTheme() {
    lightTheme = !lightTheme;
    if (!lightTheme) {
      themeData = AppTheme.lightTheme();
    } else {
      themeData = AppTheme.darkTheme();
    }
    notifyListeners();
  }
}
