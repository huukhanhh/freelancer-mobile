class Vacancy {
  const Vacancy(this.id, this.title, this.budget, this.scope, {this.count = 1});
  final String id, title, scope;
  final int budget;
  final int count;
}

class Project {
  const Project({
    required this.id,
    required this.code,
    required this.title,
    required this.owner,
    required this.description,
    required this.budget,
    required this.days,
    required this.vacancies,
    required this.imageNode,
    required this.imageSlot,
    this.startDate = "01/11/2026",
    this.endDate = "30/11/2026",
    this.billing = "Trọn gói",
    this.attachments = const [],
    this.skills = const ["Figma", "UI/UX", "Mobile UX"],
  });
  final String id, code, title, owner, description, imageNode, imageSlot;
  final int budget, days;
  final String startDate, endDate, billing;
  final List<(String, String, String)> attachments;
  final List<String> skills;
  final List<Vacancy> vacancies;
}

abstract interface class ProjectRepository {
  Future<List<Project>> fetchProjects();
  Future<ProjectManagement> fetchManagement();
  ProjectDraft newDraft();
  Future<List<Project>> fetchOwned(String viewer);
  Future<void> saveOwned(String viewer, Project project);
}

class ProjectManagement {
  const ProjectManagement({
    required this.received,
    required this.newProposals,
    required this.candidates,
    required this.attachments,
  });
  final int received, newProposals;
  final List<(String, String, String, int, int, String)> candidates;
  final List<(String, String, String)> attachments;
}

class HiringRoleDraft {
  HiringRoleDraft(this.title, this.count, this.price, this.scope);
  String title, count, price, scope;
  int get headcount => int.tryParse(count) ?? 0;
  int get amount => int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}

class ProjectDraft {
  ProjectDraft({
    required this.fields,
    required this.skills,
    required this.roles,
    required this.files,
    this.cover = false,
    this.editId,
  });
  final Map<String, String> fields;
  final Set<String> skills;
  final List<HiringRoleDraft> roles;
  final List<(String, String, String)> files;
  String? editId;
  bool cover;
  String category = 'Thiết kế';
  int get budget =>
      int.tryParse(
        (fields['budget'] ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
      ) ??
      0;
  int get count => roles.fold(0, (n, r) => n + r.headcount);
  int get allocated => roles.fold(0, (n, r) => n + r.headcount * r.amount);
  int get days {
    DateTime? read(String key) {
      final a = (fields[key] ?? '').split('/');
      if (a.length != 3) return null;
      final d = int.tryParse(a[0]),
          m = int.tryParse(a[1]),
          y = int.tryParse(a[2]);
      if (d == null || m == null || y == null) return null;
      return DateTime(y, m, d);
    }

    final start = read('start'), end = read('end');
    if (start == null || end == null) return 30;
    return end.difference(start).inDays + 1;
  }
}
