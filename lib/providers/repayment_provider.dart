import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';
import '../models/repayment.dart';

class RepaymentProvider extends ChangeNotifier {
  late Box<RepaymentPlan> _box;
  final _uuid = const Uuid();

  RepaymentProvider() {
    _box = Hive.box<RepaymentPlan>(AppConstants.repaymentBox);
  }

  List<RepaymentPlan> get plans => _box.values.toList();

  /// 获取所有待还款条目（按日期排序）
  List<({RepaymentPlan plan, RepaymentEntry entry})> get allPendingEntries {
    final List<({RepaymentPlan plan, RepaymentEntry entry})> result = [];
    for (final plan in plans) {
      for (final entry in plan.pendingEntries) {
        result.add((plan: plan, entry: entry));
      }
    }
    result.sort((a, b) => a.entry.dueDate.compareTo(b.entry.dueDate));
    return result;
  }

  /// 获取近期待还款（未来30天）
  List<({RepaymentPlan plan, RepaymentEntry entry})> get upcomingEntries {
    final now = DateTime.now();
    final deadline = now.add(const Duration(days: 30));
    return allPendingEntries.where((item) {
      final due = item.entry.dueDate;
      return due.isAfter(now.subtract(const Duration(days: 1))) &&
          due.isBefore(deadline);
    }).toList();
  }

  /// 获取指定日期的还款条目
  List<({RepaymentPlan plan, RepaymentEntry entry})> getEntriesByDate(DateTime date) {
    final List<({RepaymentPlan plan, RepaymentEntry entry})> result = [];
    for (final plan in plans) {
      final entry = plan.getEntryForMonth(date.year, date.month);
      if (entry != null && entry.dueDay == date.day) {
        result.add((plan: plan, entry: entry));
      }
    }
    return result;
  }

  /// 获取某月所有还款条目
  List<({RepaymentPlan plan, RepaymentEntry entry})> getEntriesByMonth(int year, int month) {
    final List<({RepaymentPlan plan, RepaymentEntry entry})> result = [];
    for (final plan in plans) {
      final entry = plan.getEntryForMonth(year, month);
      if (entry != null) {
        result.add((plan: plan, entry: entry));
      }
    }
    return result;
  }

  /// 创建还款计划
  Future<RepaymentPlan> addPlan({
    required String name,
    required int totalMonths,
    required int defaultDueDay,
    required bool isFixedAmount,
    required double fixedAmount,
    required DateTime startDate,
    List<MapEntry<int, double>>? variableAmounts, // monthIndex -> amount
  }) async {
    final plan = RepaymentPlan(
      id: _uuid.v4(),
      name: name,
      totalMonths: totalMonths,
      defaultDueDay: defaultDueDay,
      isFixedAmount: isFixedAmount,
      fixedAmount: fixedAmount,
      startDate: startDate,
    );

    // 生成各月条目
    for (int i = 0; i < totalMonths; i++) {
      final date = DateTime(startDate.year, startDate.month + i, 1);
      double amount;
      if (isFixedAmount) {
        amount = fixedAmount;
      } else {
        // 从 variableAmounts 中查找，找不到用 fixedAmount
        final va = variableAmounts?.where((e) => e.key == i);
        amount = (va != null && va.isNotEmpty) ? va.first.value : fixedAmount;
      }
      plan.entries.add(RepaymentEntry(
        year: date.year,
        month: date.month,
        amount: amount,
        dueDay: defaultDueDay,
      ));
    }

    await _box.put(plan.id, plan);
    notifyListeners();
    return plan;
  }

  /// 更新还款计划
  Future<void> updatePlan(RepaymentPlan plan) async {
    plan.updatedAt = DateTime.now();
    await _box.put(plan.id, plan);
    notifyListeners();
  }

  /// 删除还款计划
  Future<void> deletePlan(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  /// 标记某月已还
  Future<void> markAsCompleted(String planId, int year, int month) async {
    final plan = _box.get(planId);
    if (plan == null) return;
    final entry = plan.getEntryForMonth(year, month);
    if (entry != null) {
      entry.isCompleted = true;
      entry.completedAt = DateTime.now();
      await _box.put(planId, plan);
      notifyListeners();
    }
  }

  /// 取消标记（恢复为待还）
  Future<void> markAsPending(String planId, int year, int month) async {
    final plan = _box.get(planId);
    if (plan == null) return;
    final entry = plan.getEntryForMonth(year, month);
    if (entry != null) {
      entry.isCompleted = false;
      entry.completedAt = null;
      await _box.put(planId, plan);
      notifyListeners();
    }
  }

  /// 更新某月还款金额（浮动金额模式）
  Future<void> updateEntryAmount(String planId, int year, int month, double amount) async {
    final plan = _box.get(planId);
    if (plan == null) return;
    final entry = plan.getEntryForMonth(year, month);
    if (entry != null) {
      entry.amount = amount;
      await _box.put(planId, plan);
      notifyListeners();
    }
  }
}
