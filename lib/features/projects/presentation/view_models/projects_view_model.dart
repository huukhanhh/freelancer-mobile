import 'package:flutter/foundation.dart';
import 'package:workly/features/projects/domain/project_repository.dart';

class ProjectsViewModel extends ChangeNotifier {
  ProjectsViewModel(this.repository);
  final ProjectRepository repository;
  ProjectManagement? management;
  List<Project> owned = const [];
  ProjectDraft? draft;
  Project? published;
  String _viewer = "", projectStatus = "Đang tuyển";
  String? error;
  int _viewerGeneration = 0;
  List<Project> _projects = const [];
  bool ready = false, failed = false, _disposed = false;
  Project? find(String id) {
    for (final p in [...owned, ..._projects]) {
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

  Future<void> setViewer(String viewer) async {
    if (viewer == _viewer) return;
    _viewer = viewer;
    final gen = ++_viewerGeneration;
    owned = [];
    draft = null;
    published = null;
    error = null;
    notifyListeners();
    if (viewer.isEmpty) return;
    final result = await repository.fetchOwned(viewer);
    if (_disposed || gen != _viewerGeneration) return;
    owned = result;
    notifyListeners();
  }

  void beginCreation({String? id}) {
    draft = repository.newDraft();
    if (id != null) {
      final p = find(id);
      if (p != null) {
        draft!.editId = p.id;
        draft!.fields.addAll({
          'title': p.title,
          'description': p.description,
          'budget': p.budget.toString(),
        });
        draft!.cover = true;
      }
    }
    error = null;
    notifyListeners();
  }

  void change(String field, String value) {
    draft!.fields[field] = value;
    error = null;
    notifyListeners();
  }

  void category(String value) {
    draft!.category = value;
    notifyListeners();
  }

  void cover(bool selected) {
    draft!.cover = selected;
    notifyListeners();
  }

  void addSkill(String value) {
    if (value.trim().isEmpty) return;
    if (draft!.skills.length < 8) draft!.skills.add(value.trim());
    notifyListeners();
  }

  void removeSkill(String value) {
    draft!.skills.remove(value);
    notifyListeners();
  }

  void roleChange(int i, {String? count, String? price}) {
    final r = draft!.roles[i];
    if (count != null) r.count = count;
    if (price != null) r.price = price;
    notifyListeners();
  }

  void addRole(String name, String count, String price) {
    if (name.trim().isEmpty) return;
    draft!.roles.add(HiringRoleDraft(name.trim(), count, price, ''));
    notifyListeners();
  }

  void removeRole(int i) {
    draft!.roles.removeAt(i);
    notifyListeners();
  }

  void removeFile(int i) {
    draft!.files.removeAt(i);
    notifyListeners();
  }

  void addFile() {
    const sources = [
      ('PDF', 'GreenPay-brief.pdf', '2,4 MB'),
      ('ZIP', 'brand-assets.zip', '6,8 MB'),
    ];
    for (final f in sources) {
      if (!draft!.files.any((a) => a.$2 == f.$2)) {
        draft!.files.add(f);
        break;
      }
    }
    notifyListeners();
  }

  Project draftProject() {
    final d = draft!;
    final id = d.editId ?? 'client-project-demo-${owned.length + 1}';
    return Project(
      id: id,
      code: d.editId == null
          ? 'P-DEMO-${owned.length + 1}'
          : find(id)?.code ?? id,
      title: d.fields['title']!,
      owner: 'Trần Quốc Huy',
      startDate: d.fields['start']!,
      endDate: d.fields['end']!,
      billing: d.fields['billing']!,
      attachments: List.unmodifiable(d.files),
      skills: List.unmodifiable(d.skills),
      description: d.fields['description']!,
      budget: d.budget,
      days: d.days,
      vacancies: [
        for (var i = 0; i < d.roles.length; i++)
          Vacancy(
            'role-$i',
            d.roles[i].title,
            d.roles[i].amount,
            d.roles[i].scope,
            count: d.roles[i].headcount,
          ),
      ],
      imageNode: '692:5436',
      imageSlot: 'imgSelectedProjectCover169',
    );
  }

  bool validate() {
    final d = draft;
    if (d == null) return false;
    error = d.fields['title']!.trim().isEmpty
        ? 'Vui lòng nhập tên dự án.'
        : null;
    notifyListeners();
    return error == null;
  }

  Future<bool> publish() async {
    if (!validate()) return false;
    final p = draftProject();
    await repository.saveOwned(_viewer, p);
    final rows = await repository.fetchOwned(_viewer);
    if (_disposed) return false;
    published = p;
    owned = rows;
    notifyListeners();
    return true;
  }

  void selectStatus(String status) {
    projectStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
