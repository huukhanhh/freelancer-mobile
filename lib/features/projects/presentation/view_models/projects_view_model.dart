import 'package:flutter/foundation.dart';
import 'package:workly/features/projects/domain/project_repository.dart';

class ProjectsViewModel extends ChangeNotifier {
  ProjectsViewModel(this.repository);
  final ProjectRepository repository;
  ProjectManagement? management;
  List<Project> _projects = const [];
  bool ready = false, failed = false, _disposed = false;
  Project? find(String id) {
    for (final p in _projects) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> initialize() async {
    try {
      final result = await repository.fetchProjects();
      final facts = await repository.fetchManagement();
      if (_disposed) return;
      _projects = result;
      management = facts;
      failed = false;
    } catch (_) {
      if (_disposed) return;
      failed = true;
    }
    ready = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
