import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';
import '../models/living_cost.dart';

/// 生活成本 Provider
class LivingCostProvider extends ChangeNotifier {
  late Box<LivingCostMonth> _box;
  final _uuid = const Uuid();

  LivingCostProvider() {
    _box = Hive.box<LivingCostMonth>(AppConstants.livingCostBox);
  }

  /// 获取指定月份的记录（不存在则创建并自动填充固定支出）
  LivingCostMonth getMonth(int year, int month) {
    final id = '$year-${month.toString().padLeft(2, '0')}';
    var monthData = _box.get(id);
    if (monthData == null) {
      monthData = LivingCostMonth(id: id, year: year, month: month);
      _autoFillRecurring(monthData, year, month);
      _box.put(id, monthData);
    }
    return monthData;
  }

  /// 从所有已有月份中收集固定支出模板，填充到新月份
  /// 不依赖"上一个月"，而是全局搜索所有固定条目，避免跳月丢失
  void _autoFillRecurring(LivingCostMonth newMonth, int year, int month) {
    // 收集所有固定支出模板（去重：同名+同分类+同金额）
    final templates = <String, LivingCostEntry>{};
    double? lastBudget;

    for (final m in _box.values) {
      // 收集固定支出
      for (final e in m.entries) {
        if (e.isRecurring) {
          final key = '${e.name}|${e.category}|${e.amount}';
          templates[key] = e;
        }
      }
      // 记录最近月份的预算
      if (lastBudget == null || m.monthlyBudget > 0) {
        lastBudget = m.monthlyBudget;
      }
    }

    // 填充固定支出到新月份
    for (final template in templates.values) {
      newMonth.entries.add(LivingCostEntry(
        id: _uuid.v4(),
        name: template.name,
        amount: template.amount,
        category: template.category,
        date: DateTime(year, month, 1),
        note: template.note,
        isRecurring: true,
      ));
    }

    // 继承预算
    if (lastBudget != null && lastBudget > 0) {
      newMonth.monthlyBudget = lastBudget;
    }
  }

  /// 获取本月
  LivingCostMonth get currentMonth {
    final now = DateTime.now();
    return getMonth(now.year, now.month);
  }

  /// 设置月度生活成本预算
  Future<void> setMonthlyBudget(int year, int month, double budget) async {
    final data = getMonth(year, month);
    data.monthlyBudget = budget;
    await _box.put(data.id, data);
    notifyListeners();
  }

  /// 添加生活成本条目
  Future<void> addEntry({
    required int year,
    required int month,
    required String name,
    required double amount,
    required String category,
    DateTime? date,
    String? note,
    bool isRecurring = false,
  }) async {
    final data = getMonth(year, month);
    data.entries.add(LivingCostEntry(
      id: _uuid.v4(),
      name: name,
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
      note: note,
      isRecurring: isRecurring,
    ));
    await _box.put(data.id, data);
    notifyListeners();
  }

  /// 删除条目
  Future<void> deleteEntry(int year, int month, String entryId) async {
    final data = getMonth(year, month);
    data.entries.removeWhere((e) => e.id == entryId);
    await _box.put(data.id, data);
    notifyListeners();
  }

  /// 获取指定日期的生活成本条目（用于日历显示）
  List<LivingCostEntry> getEntriesByDate(DateTime date) {
    final data = getMonth(date.year, date.month);
    return data.entries.where((e) {
      return e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
    }).toList();
  }

  /// 获取某月固定支出总额
  double getMonthRecurringTotal(int year, int month) {
    final data = getMonth(year, month);
    return data.entries.where((e) => e.isRecurring).fold<double>(0, (s, e) => s + e.amount);
  }

  /// 获取某月非固定支出总额
  double getMonthVariableTotal(int year, int month) {
    final data = getMonth(year, month);
    return data.entries.where((e) => !e.isRecurring).fold<double>(0, (s, e) => s + e.amount);
  }

  /// 生活成本分类
  static const List<String> categories = [
    '房租/房贷',
    '餐饮',
    '交通',
    '水电燃气',
    '通讯',
    '日用品',
    '医疗',
    '教育',
    '其他',
  ];
}
