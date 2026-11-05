import 'package:flutter/foundation.dart';
import 'package:workly/features/profiles/domain/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this.repository);
  final ProfileRepository repository;
  FreelancerProfile? profile;
  final fields = <String, String>{};
  final technologies = <String>{};
  String _viewer = '';
  int _generation = 0;
  bool _disposed = false;
  PortfolioEntry? portfolioDraft;
  Future<void> setViewer(String viewer) async {
    if (viewer == _viewer) return;
    _viewer = viewer;
    final gen = ++_generation;
    profile = null;
    portfolioDraft = null;
    fields.clear();
    technologies.clear();
    notifyListeners();
    if (viewer.isEmpty) return;
    final result = await repository.fetchProfile(viewer);
    if (_disposed || gen != _generation) return;
    profile = result;
    beginEdit();
  }

  void beginEdit() {
    final p = profile;
    if (p == null) return;
    fields
      ..clear()
      ..addAll({
        'title': p.title,
        'bio': p.bio,
        'rate': p.rate,
        'location': p.location,
        'company': p.company,
        'position': p.position,
        'fromYear': p.fromYear,
        'toYear': p.toYear,
        'workDescription': p.workDescription,
      });
    technologies
      ..clear()
      ..addAll(p.technologies);
    notifyListeners();
  }

  void change(String key, String value) {
    fields[key] = value;
    notifyListeners();
  }

  void toggle(String name) {
    if (!technologies.remove(name)) technologies.add(name);
    notifyListeners();
  }

  Future<void> save() async {
    if (profile == null) return;
    profile = profile!.updated(fields, technologies);
    await repository.saveProfile(_viewer, profile!);
    if (!_disposed) notifyListeners();
  }

  void editPortfolio(String? id) {
    final p = profile;
    if (p == null) return;
    portfolioDraft = id == null
        ? PortfolioEntry(
            id: 'demo-${p.portfolio.length + 1}',
            title: '',
            metadata: 'UI/UX · Mobile App · 2026',
            node: '585:5606',
            slot: 'imgPortfolioCover',
          )
        : p.portfolio.firstWhere((e) => e.id == id);
    notifyListeners();
  }

  void changePortfolio({
    String? title,
    String? role,
    String? description,
    String? link,
  }) {
    portfolioDraft = portfolioDraft?.copyWith(
      title: title,
      role: role,
      description: description,
      link: link,
    );
    notifyListeners();
  }

  void changeCover() {
    final d = portfolioDraft;
    if (d == null) return;
    const slots = ['imgPortfolioCover', 'imgWorkspaceView', 'imgProcessView'];
    final i = slots.indexOf(d.slot);
    portfolioDraft = d.copyWith(
      node: '585:5606',
      slot: slots[(i + 1) % slots.length],
    );
    notifyListeners();
  }

  Future<bool> savePortfolio() async {
    final d = portfolioDraft, p = profile;
    if (d == null || p == null || d.title.trim().isEmpty) return false;
    final entries = [...p.portfolio];
    final i = entries.indexWhere((e) => e.id == d.id);
    if (i < 0) {
      entries.add(d);
    } else {
      entries[i] = d;
    }
    profile = p.updated({}, p.technologies, portfolio: entries);
    await repository.saveProfile(_viewer, profile!);
    if (!_disposed) notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
