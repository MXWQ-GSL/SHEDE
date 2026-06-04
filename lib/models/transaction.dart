import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  receivable, // 应收款
  @HiveField(1)
  payable, // 应付款
}

@HiveType(typeId: 1)
enum TransactionStatus {
  @HiveField(0)
  pending, // 待处理
  @HiveField(1)
  completed, // 已完成
  @HiveField(2)
  overdue, // 逾期
}

@HiveType(typeId: 2)
enum CycleType {
  @HiveField(0)
  once, // 一次性
  @HiveField(1)
  monthly, // 每月
  @HiveField(2)
  weekly, // 每周
  @HiveField(3)
  yearly, // 每年
  @HiveField(4)
  custom, // 自定义
}

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final TransactionType type;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final String name;
  
  @HiveField(4)
  final double amount;
  
  @HiveField(5)
  final DateTime dueDate;
  
  @HiveField(6)
  final CycleType cycle;
  
  @HiveField(7)
  final int? customCycleDays;
  
  @HiveField(8)
  final String? projectId;
  
  @HiveField(9)
  TransactionStatus status;
  
  @HiveField(10)
  DateTime? completedDate;
  
  @HiveField(11)
  final String? note;
  
  @HiveField(12)
  final DateTime createdAt;
  
  @HiveField(13)
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.cycle,
    this.customCycleDays,
    this.projectId,
    this.status = TransactionStatus.pending,
    this.completedDate,
    this.note,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // 标记为已完成
  void markAsCompleted() {
    status = TransactionStatus.completed;
    updatedAt = DateTime.now();
  }

  // 检查是否逾期
  bool get isOverdue {
    return status == TransactionStatus.pending && 
           dueDate.isBefore(DateTime.now());
  }

  // 获取周期描述
  String get cycleDescription {
    switch (cycle) {
      case CycleType.once:
        return '一次性';
      case CycleType.monthly:
        return '每月';
      case CycleType.weekly:
        return '每周';
      case CycleType.yearly:
        return '每年';
      case CycleType.custom:
        return '每$customCycleDays天';
    }
  }

  // 计算下一个到期日
  DateTime get nextDueDate {
    if (cycle == CycleType.once) return dueDate;
    
    final now = DateTime.now();
    DateTime next = dueDate;
    
    while (next.isBefore(now)) {
      switch (cycle) {
        case CycleType.monthly:
          next = DateTime(next.year, next.month + 1, next.day);
          break;
        case CycleType.weekly:
          next = next.add(const Duration(days: 7));
          break;
        case CycleType.yearly:
          next = DateTime(next.year + 1, next.month, next.day);
          break;
        case CycleType.custom:
          next = next.add(Duration(days: customCycleDays ?? 30));
          break;
        default:
          break;
      }
    }
    
    return next;
  }

  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? category,
    String? name,
    double? amount,
    DateTime? dueDate,
    CycleType? cycle,
    int? customCycleDays,
    String? projectId,
    TransactionStatus? status,
    DateTime? completedDate,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      cycle: cycle ?? this.cycle,
      customCycleDays: customCycleDays ?? this.customCycleDays,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      completedDate: completedDate ?? this.completedDate,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
