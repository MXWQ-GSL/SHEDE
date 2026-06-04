import 'package:hive/hive.dart';

part 'repayment.g.dart';

/// 还款计划
@HiveType(typeId: 6)
class RepaymentPlan extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name; // 如 "XX银行房贷"

  @HiveField(2)
  int totalMonths; // 总还款月数

  @HiveField(3)
  int defaultDueDay; // 默认还款日（每月几号）

  @HiveField(4)
  bool isFixedAmount; // true=每月固定金额, false=每月不同金额

  @HiveField(5)
  double fixedAmount; // 固定金额模式下的每月金额

  @HiveField(6)
  List<RepaymentEntry> entries; // 各月还款明细（浮动金额模式使用）

  @HiveField(7)
  DateTime startDate; // 开始还款日期

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  RepaymentPlan({
    required this.id,
    required this.name,
    required this.totalMonths,
    required this.defaultDueDay,
    this.isFixedAmount = true,
    this.fixedAmount = 0,
    List<RepaymentEntry>? entries,
    required this.startDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : entries = entries ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 获取指定月份的还款条目
  RepaymentEntry? getEntryForMonth(int year, int month) {
    for (final e in entries) {
      if (e.year == year && e.month == month) return e;
    }
    return null;
  }

  /// 获取本月还款
  RepaymentEntry? get currentMonthEntry {
    final now = DateTime.now();
    return getEntryForMonth(now.year, now.month);
  }

  /// 获取所有待还款的条目
  List<RepaymentEntry> get pendingEntries {
    return entries.where((e) => !e.isCompleted).toList()
      ..sort((a, b) {
        final aDate = DateTime(a.year, a.month, a.dueDay);
        final bDate = DateTime(b.year, b.month, b.dueDay);
        return aDate.compareTo(bDate);
      });
  }

  /// 获取近期待还款（未来30天内）
  List<RepaymentEntry> get upcomingEntries {
    final now = DateTime.now();
    final deadline = now.add(const Duration(days: 30));
    return pendingEntries.where((e) {
      final due = DateTime(e.year, e.month, e.dueDay);
      return due.isAfter(now.subtract(const Duration(days: 1))) &&
          due.isBefore(deadline);
    }).toList();
  }

  /// 根据配置自动生成 entries
  void generateEntries() {
    entries.clear();
    for (int i = 0; i < totalMonths; i++) {
      final date = DateTime(startDate.year, startDate.month + i, 1);
      final amount = isFixedAmount
          ? fixedAmount
          : (i < entries.length ? entries[i].amount : fixedAmount);
      entries.add(RepaymentEntry(
        year: date.year,
        month: date.month,
        amount: amount,
        dueDay: defaultDueDay,
      ));
    }
  }
}

/// 单月还款条目
@HiveType(typeId: 7)
class RepaymentEntry extends HiveObject {
  @HiveField(0)
  final int year;

  @HiveField(1)
  final int month;

  @HiveField(2)
  double amount; // 该月应还金额

  @HiveField(3)
  int dueDay; // 该月还款日

  @HiveField(4)
  bool isCompleted; // 是否已还

  @HiveField(5)
  DateTime? completedAt; // 实际还款时间

  RepaymentEntry({
    required this.year,
    required this.month,
    required this.amount,
    required this.dueDay,
    this.isCompleted = false,
    this.completedAt,
  });

  /// 到期日
  DateTime get dueDate => DateTime(year, month, dueDay);

  /// 是否逾期
  bool get isOverdue {
    if (isCompleted) return false;
    return dueDate.isBefore(DateTime.now());
  }

  /// 状态描述
  String get statusText {
    if (isCompleted) return '已还';
    if (isOverdue) return '逾期';
    return '待还';
  }
}
