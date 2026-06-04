import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';
import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  late Box<Project> _projectsBox;
  final _uuid = const Uuid();

  ProjectProvider() {
    _projectsBox = Hive.box<Project>(AppConstants.projectsBox);
  }

  // 获取所有项目
  List<Project> get projects => _projectsBox.values.toList();

  // 获取进行中的项目
  List<Project> get activeProjects {
    return projects
        .where((p) => p.status == ProjectStatus.active)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // 获取已归档的项目
  List<Project> get archivedProjects {
    return projects
        .where((p) => p.status == ProjectStatus.archived)
        .toList()
      ..sort((a, b) => (b.archivedAt ?? b.updatedAt)
          .compareTo(a.archivedAt ?? a.updatedAt));
  }

  // 根据ID获取项目
  Project? getProjectById(String id) {
    return _projectsBox.get(id);
  }

  // 添加项目
  Future<Project> addProject({
    required String name,
    double? budget,
    required DateTime startDate,
    String? description,
  }) async {
    final project = Project(
      id: _uuid.v4(),
      name: name,
      budget: budget,
      startDate: startDate,
      description: description,
    );

    await _projectsBox.put(project.id, project);
    notifyListeners();
    return project;
  }

  // 更新项目
  Future<void> updateProject(Project project) async {
    project.updatedAt = DateTime.now();
    await _projectsBox.put(project.id, project);
    notifyListeners();
  }

  // 删除项目
  Future<void> deleteProject(String id) async {
    await _projectsBox.delete(id);
    notifyListeners();
  }

  // 归档项目
  Future<void> archiveProject(String id) async {
    final project = _projectsBox.get(id);
    if (project != null) {
      project.status = ProjectStatus.archived;
      project.updatedAt = DateTime.now();
      await _projectsBox.put(id, project);
      notifyListeners();
    }
  }

  // 取消归档
  Future<void> unarchiveProject(String id) async {
    final project = _projectsBox.get(id);
    if (project != null) {
      project.status = ProjectStatus.active;
      project.updatedAt = DateTime.now();
      await _projectsBox.put(id, project);
      notifyListeners();
    }
  }
}
