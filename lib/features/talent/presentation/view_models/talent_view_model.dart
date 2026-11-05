import 'package:flutter/foundation.dart';
import 'package:workly/features/talent/domain/talent_repository.dart';

class TalentViewModel extends ChangeNotifier {
  TalentViewModel(this.repository);
  final TalentRepository repository;
  List<Talent> _talent = const [];
  String viewer = '',
      category = 'Tất cả',
      query = '',
      inviteQuery = '',
      inviteSkill = '';
  final selected = <String>{};
  int sentCount = 0;
  String? error;
  bool _disposed = false;
  Future<void> initialize() async {
    final data = await repository.fetchTalent();
    if (_disposed) return;
    _talent = data;
    notifyListeners();
  }

  void setViewer(String value) {
    if (viewer == value) return;
    viewer = value;
    selected.clear();
    sentCount = 0;
    query = '';
    inviteQuery = '';
    inviteSkill = '';
    category = 'Tất cả';
    error = null;
    notifyListeners();
  }

  Talent? find(String id) {
    for (final t in _talent) {
      if (t.id == id) return t;
    }
    return null;
  }

  List<Talent> get results => _talent
      .take(3)
      .where(
        (t) =>
            (category == 'Tất cả' || t.category == category) &&
            (query.isEmpty ||
                '${t.name} ${t.fullName} ${t.skills.join(' ')}'
                    .toLowerCase()
                    .contains(query.toLowerCase())),
      )
      .toList();
  List<Talent> get compared => _talent.take(2).toList();
  List<Talent> get inviteResults => _talent
      .where(
        (t) =>
            [
              'talent-demo-1',
              'talent-demo-4',
              'talent-demo-5',
              'talent-demo-6',
            ].contains(t.id) &&
            (inviteQuery.isEmpty ||
                '${t.fullName} ${t.skills.join(' ')}'.toLowerCase().contains(
                  inviteQuery.toLowerCase(),
                )) &&
            (inviteSkill.isEmpty || t.skills.contains(inviteSkill)),
      )
      .toList();
  void search(String value) {
    query = value;
    notifyListeners();
  }

  void selectCategory(String value) {
    category = value;
    notifyListeners();
  }

  void searchInvite(String value) {
    inviteQuery = value;
    notifyListeners();
  }

  void skillInvite(String value) {
    inviteSkill = inviteSkill == value ? '' : value;
    notifyListeners();
  }

  void toggleInvite(String id) {
    if (!selected.remove(id)) selected.add(id);
    error = null;
    notifyListeners();
  }

  void preselect(String id) {
    selected.add(id);
    error = null;
    notifyListeners();
  }

  Future<bool> sendInvites() async {
    if (selected.isEmpty) {
      error = 'Chọn ít nhất một freelancer để gửi lời mời.';
      notifyListeners();
      return false;
    }
    await repository.invite(viewer, Set.unmodifiable(selected));
    if (_disposed) return false;
    sentCount = selected.length;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
