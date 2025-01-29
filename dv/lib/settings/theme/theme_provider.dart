import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  static int _selectedThemeIndex = 0; // 선택된 테마 인덱스

  static int get selectedThemeIndex => _selectedThemeIndex;

  void changeTheme(int index) {
    
    _selectedThemeIndex = index;
    notifyListeners();
  }
}