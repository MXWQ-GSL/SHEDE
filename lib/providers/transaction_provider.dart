import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';
import '../models/transaction.dart';
import '../services/notification_service.dart';

class TransactionProvider extends ChangeNotifier {
  late Box<Transaction> _transactionsBox;
  final _uuid = const Uuid();
  final _notif = NotificationService();

  // 通知设置（由 SettingsProvider 同步）
  bool _notifEnabled = true;
  int _advanceDays = 1;
  int _notifHour = 9;
  int _notifMinute = 0;

  TransactionProvider() {
    _transactionsBox = Hive.box<Transaction>(AppConstants.transactionsBox);
  }

  /// 由 SettingsProvider 调用，同步通知参数
  void updateNotifSettings({required bool enabled, required int advanceDays, required int hour, required int minute}) {
    _notifEnabled = enabled;
    _advanceDays = advanceDays;
    _notifHour = hour;
    _notifMinute = minute;
  }

  // 获取所有交易
  List<Transaction> get transactions => _transactionsBox.values.toList();

  // 获取待处理交易
  List<Transaction> get pendingTransactions {
    return transactions
        .where((t) => t.status == TransactionStatus.pending)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // 获取已逾期交易
  List<Transaction> get overdueTransactions {
    return transactions.where((t) => t.isOverdue).toList();
  }

  // 获取近期待处理（未来30天）
  List<Transaction> get upcomingTransactions {
    final now = DateTime.now();
    final nextMonth = now.add(const Duration(days: 30));
    return pendingTransactions
        .where((t) => t.dueDate.isAfter(now) && t.dueDate.isBefore(nextMonth))
        .toList();
  }

  // 按日期获取交易
  List<Transaction> getTransactionsByDate(DateTime date) {
    return transactions.where((t) {
      return t.dueDate.year == date.year &&
             t.dueDate.month == date.month &&
             t.dueDate.day == date.day;
    }).toList();
  }

  // 获取本月应收款总额
  double getMonthlyReceivable() {
    final now = DateTime.now();
    return transactions
        .where((t) =>
            t.type == TransactionType.receivable &&
            t.dueDate.year == now.year &&
            t.dueDate.month == now.month)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // 获取本月应付款总额
  double getMonthlyPayable() {
    final now = DateTime.now();
    return transactions
        .where((t) =>
            t.type == TransactionType.payable &&
            t.dueDate.year == now.year &&
            t.dueDate.month == now.month)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // 获取本月已支出金额
  double getMonthlySpent() {
    final now = DateTime.now();
    return transactions
        .where((t) =>
            t.type == TransactionType.payable &&
            t.status == TransactionStatus.completed &&
            t.completedDate != null &&
            t.completedDate!.year == now.year &&
            t.completedDate!.month == now.month)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // 获取净资产
  double get netAsset => getMonthlyReceivable() - getMonthlyPayable();

  // 获取指定月份的统计数据
  Map<String, double> getMonthlyStats(int year, int month) {
    final monthTransactions = transactions.where((t) {
      final date = t.status == TransactionStatus.completed && t.completedDate != null
          ? t.completedDate!
          : t.dueDate;
      return date.year == year && date.month == month;
    }).toList();

    double income = 0;
    double expense = 0;

    for (final t in monthTransactions) {
      if (t.type == TransactionType.receivable) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }

    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
    };
  }

  // 获取每日统计
  Map<String, Map<String, double>> getDailyStats(int year, int month) {
    final Map<String, Map<String, double>> stats = {};
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dayTransactions = getTransactionsByDate(date);
      
      double income = 0;
      double expense = 0;
      
      for (final t in dayTransactions) {
        if (t.type == TransactionType.receivable) {
          income += t.amount;
        } else {
          expense += t.amount;
        }
      }
      
      stats[day.toString()] = {
        'income': income,
        'expense': expense,
      };
    }

    return stats;
  }

  // 获取分类统计
  Map<String, double> getCategoryStats({
    required TransactionType type,
    required int year,
    required int month,
  }) {
    final Map<String, double> stats = {};
    
    final monthTransactions = transactions.where((t) {
      final date = t.status == TransactionStatus.completed && t.completedDate != null
          ? t.completedDate!
          : t.dueDate;
      return t.type == type &&
             date.year == year &&
             date.month == month;
    });

    for (final t in monthTransactions) {
      stats[t.category] = (stats[t.category] ?? 0) + t.amount;
    }

    return stats;
  }

  // 添加交易
  Future<Transaction> addTransaction({
    required TransactionType type,
    required String category,
    required String name,
    required double amount,
    required DateTime dueDate,
    required CycleType cycle,
    int? customCycleDays,
    String? projectId,
    String? note,
  }) async {
    final transaction = Transaction(
      id: _uuid.v4(),
      type: type,
      category: category,
      name: name,
      amount: amount,
      dueDate: dueDate,
      cycle: cycle,
      customCycleDays: customCycleDays,
      projectId: projectId,
      note: note,
    );

    await _transactionsBox.put(transaction.id, transaction);
    notifyListeners();

    // 安排到期提醒
    if (_notifEnabled && transaction.status != TransactionStatus.completed) {
      await _notif.scheduleReminder(
        txn: transaction,
        advanceDays: _advanceDays,
        hour: _notifHour,
        minute: _notifMinute,
      );
    }

    return transaction;
  }

  // 更新交易
  Future<void> updateTransaction(Transaction transaction) async {
    transaction.updatedAt = DateTime.now();
    await _transactionsBox.put(transaction.id, transaction);
    notifyListeners();

    // 重新安排提醒
    await _notif.cancelReminder(transaction.id);
    if (_notifEnabled && transaction.status != TransactionStatus.completed) {
      await _notif.scheduleReminder(
        txn: transaction,
        advanceDays: _advanceDays,
        hour: _notifHour,
        minute: _notifMinute,
      );
    }
  }

  // 删除交易
  Future<void> deleteTransaction(String id) async {
    await _notif.cancelReminder(id);
    await _transactionsBox.delete(id);
    notifyListeners();
  }

  // 标记为已完成
  Future<void> markAsCompleted(String id) async {
    final transaction = _transactionsBox.get(id);
    if (transaction != null) {
      transaction.status = TransactionStatus.completed;
      transaction.completedDate = DateTime.now();
      transaction.updatedAt = DateTime.now();
      await _transactionsBox.put(id, transaction);
      await _notif.cancelReminder(id);
      notifyListeners();
    }
  }

  // 取消完成（恢复为待处理）
  Future<void> markAsPending(String id) async {
    final transaction = _transactionsBox.get(id);
    if (transaction != null) {
      transaction.status = TransactionStatus.pending;
      transaction.completedDate = null;
      transaction.updatedAt = DateTime.now();
      await _transactionsBox.put(id, transaction);

      // 重新安排提醒
      if (_notifEnabled) {
        await _notif.scheduleReminder(
          txn: transaction,
          advanceDays: _advanceDays,
          hour: _notifHour,
          minute: _notifMinute,
        );
      }

      notifyListeners();
    }
  }

  // 获取指定项目的总投入
  double getProjectTotalInvested(String projectId) {
    return transactions
        .where((t) =>
            t.projectId == projectId &&
            t.type == TransactionType.payable &&
            t.status == TransactionStatus.completed)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // 导出为 CSV 格式
  String exportToCsv() {
    final buffer = StringBuffer();
    buffer.writeln('ID,类型,分类,名称,金额,到期日,周期,状态,完成日期,备注');
    
    for (final t in transactions) {
      buffer.writeln(
        '${t.id},'
        '${t.type == TransactionType.receivable ? "应收" : "应付"},'
        '${t.category},'
        '${t.name},'
        '${t.amount},'
        '${t.dueDate.toIso8601String()},'
        '${t.cycleDescription},'
        '${t.status == TransactionStatus.completed ? "已完成" : t.status == TransactionStatus.overdue ? "逾期" : "待处理"},'
        '${t.completedDate?.toIso8601String() ?? ""},'
        '${t.note ?? ""}'
      );
    }
    
    return buffer.toString();
  }
}
