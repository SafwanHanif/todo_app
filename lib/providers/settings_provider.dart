import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  bool _remindersEnabled = true;
  bool _dailySummaryEnabled = true;
  final String _userName = 'Wajid Khan';
  final String _userEmail = 'wajid@example.com';

  bool get darkMode => _darkMode;
  bool get remindersEnabled => _remindersEnabled;
  bool get dailySummaryEnabled => _dailySummaryEnabled;
  String get userName => _userName;
  String get userEmail => _userEmail;

  ThemeMode get themeMode => _darkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleReminders() {
    _remindersEnabled = !_remindersEnabled;
    notifyListeners();
  }

  void toggleDailySummary() {
    _dailySummaryEnabled = !_dailySummaryEnabled;
    notifyListeners();
  }
}
