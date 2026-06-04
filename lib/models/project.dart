import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 4)
enum ProjectStatus {
  @HiveField(0)
  active, // 进行中
  @HiveField(1)
  archived, // 已归档
}

@HiveType(typeId: 5)
class Project extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double? budget;
  
  @HiveField(3)
  final DateTime startDate;
  
  @HiveField(4)
  ProjectStatus status;
  
  @HiveField(5)
  final DateTime? archivedAt;
  
  @HiveField(6)
  final String? description;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    this.budget,
    required this.startDate,
    this.status = ProjectStatus.active,
    this.archivedAt,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // 归档项目
  void archive() {
    status = ProjectStatus.archived;
    updatedAt = DateTime.now();
  }

  // 取消归档
  void unarchive() {
    status = ProjectStatus.active;
    updatedAt = DateTime.now();
  }

  // 计算预算使用百分比
  double? getBudgetPercentage(double totalInvested) {
    if (budget == null || budget == 0) return null;
    return totalInvested / budget!;
  }

  Project copyWith({
    String? id,
    String? name,
    double? budget,
    DateTime? startDate,
    ProjectStatus? status,
    DateTime? archivedAt,
    String? description,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      budget: budget ?? this.budget,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      archivedAt: archivedAt ?? this.archivedAt,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
