import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../config/constants.dart';

class SettingsProvider extends ChangeNotifier {
  late Box _settingsBox;
  
  ThemeMode _themeMode = ThemeMode.system;
  double _monthlyBudget = 0;
  int _budgetResetDay = 1;
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  int _reminderAdvanceDays = 1;
  bool _overBudgetAlert = true;

  SettingsProvider() {
    _settingsBox = Hive.box(AppConstants.settingsBox);
    _loadSettings();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get monthlyBudget => _monthlyBudget;
  int get budgetResetDay => _budgetResetDay;
  bool get reminderEnabled => _reminderEnabled;
  TimeOfDay get reminderTime => _reminderTime;
  int get reminderAdvanceDays => _reminderAdvanceDays;
  bool get overBudgetAlert => _overBudgetAlert;

  // 加载设置
  void _loadSettings() {
    final themeIndex = _settingsBox.get(AppConstants.themeKey, defaultValue: 0);
    _themeMode = ThemeMode.values[themeIndex];
    
    _monthlyBudget = _settingsBox.get(AppConstants.budgetKey, defaultValue: 0.0);
    _budgetResetDay = _settingsBox.get(AppConstants.budgetResetDayKey, defaultValue: 1);
    
    _reminderEnabled = _settingsBox.get(AppConstants.reminderEnabledKey, defaultValue: true);
    
    final hour = _settingsBox.get('${AppConstants.reminderTimeKey}_hour', defaultValue: 9);
    final minute = _settingsBox.get('${AppConstants.reminderTimeKey}_minute', defaultValue: 0);
    _reminderTime = TimeOfDay(hour: hour, minute: minute);
    
    _reminderAdvanceDays = _settingsBox.get(AppConstants.reminderAdvanceDaysKey, defaultValue: 1);
    _overBudgetAlert = _settingsBox.get(AppConstants.overBudgetAlertKey, defaultValue: true);
  }

  // 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsBox.put(AppConstants.themeKey, mode.index);
    notifyListeners();
  }

  // 设置月度预算
  Future<void> setMonthlyBudget(double budget) async {
    _monthlyBudget = budget;
    await _settingsBox.put(AppConstants.budgetKey, budget);
    notifyListeners();
  }

  // 设置预算重置日
  Future<void> setBudgetResetDay(int day) async {
    _budgetResetDay = day;
    await _settingsBox.put(AppConstants.budgetResetDayKey, day);
    notifyListeners();
  }

  // 设置提醒开关
  Future<void> setReminderEnabled(bool enabled) async {
    _reminderEnabled = enabled;
    await _settingsBox.put(AppConstants.reminderEnabledKey, enabled);
    notifyListeners();
  }

  // 设置提醒时间
  Future<void> setReminderTime(TimeOfDay time) async {
    _reminderTime = time;
    await _settingsBox.put('${AppConstants.reminderTimeKey}_hour', time.hour);
    await _settingsBox.put('${AppConstants.reminderTimeKey}_minute', time.minute);
    notifyListeners();
  }

  // 设置提前提醒天数
  Future<void> setReminderAdvanceDays(int days) async {
    _reminderAdvanceDays = days;
    await _settingsBox.put(AppConstants.reminderAdvanceDaysKey, days);
    notifyListeners();
  }

  // 设置超支提醒
  Future<void> setOverBudgetAlert(bool enabled) async {
    _overBudgetAlert = enabled;
    await _settingsBox.put(AppConstants.overBudgetAlertKey, enabled);
    notifyListeners();
  }

  // 获取主题模式名称
  String getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色模式';
      case ThemeMode.dark:
        return '深色模式';
    }
  }
}
