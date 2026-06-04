import 'package:hive/hive.dart';

part 'living_cost.g.dart';

/// 生活成本月度记录
@HiveType(typeId: 8)
class LivingCostMonth extends HiveObject {
  @HiveField(0)
  final String id; // 格式: "2026-06"

  @HiveField(1)
  int year;

  @HiveField(2)
  int month;

  @HiveField(3)
  double monthlyBudget; // 本月生活成本预算

  @HiveField(4)
  List<LivingCostEntry> entries; // 各项支出

  @HiveField(5)
  DateTime createdAt;

  LivingCostMonth({
    required this.id,
    required this.year,
    required this.month,
    this.monthlyBudget = 0,
    List<LivingCostEntry>? entries,
    DateTime? createdAt,
  })  : entries = entries ?? [],
        createdAt = createdAt ?? DateTime.now();

  double get totalSpent => entries.fold<double>(0, (s, e) => s + e.amount);
  double get remaining => monthlyBudget - totalSpent;
  bool get isOverBudget => totalSpent > monthlyBudget;
}

/// 单项生活成本
@HiveType(typeId: 9)
class LivingCostEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name; // 如 "房租", "餐饮", "水电"

  @HiveField(2)
  double amount;

  @HiveField(3)
  String category; // 分类

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? note;

  @HiveField(6)
  bool isRecurring; // 是否每月固定支出

  LivingCostEntry({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.isRecurring = false,
  });
}
