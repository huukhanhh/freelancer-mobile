import 'package:flutter/foundation.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';

class DiscoveryViewModel extends ChangeNotifier {
  // Presentation knots preserve the source handle positions for 2m / 30m.
  // Backend filtering receives currency amounts, never these display fractions.
  static int budgetAt(double t) =>
      ((t <= .2
                  ? t / .2 * 2000000
                  : t <= .85
                  ? 2000000 + (t - .2) / .65 * 28000000
                  : 30000000 + (t - .85) / .15 * 20000000) /
              100000)
          .round() *
      100000;
  static double fractionAt(int amount) => amount <= 2000000
      ? amount / 2000000 * 0.2
      : amount <= 30000000
      ? 0.2 + (amount - 2000000) / 28000000 * 0.65
      : 0.85 + (amount - 30000000) / 20000000 * 0.15;
  DiscoveryViewModel(this._repository);
  final JobRepository _repository;
  List<Job> _jobs = const [];
  bool loading = true;
  String? error;
  bool _disposed = false;
  int _loadGeneration = 0;
  String query = '';
  String viewer = '';
  JobFilters applied = const JobFilters();
  JobFilters draft = const JobFilters(
    category: 'Web',
    technology: 'Flutter',
    minimum: 2000000,
    maximum: 30000000,
    remote: true,
    verified: true,
    billing: 'Trọn gói',
  );
  final _saved = <String>{};
  final _history = <String>[
    'Flutter developer',
    'UI/UX Designer',
    'Frontend React',
  ];
  List<String> get history => List.unmodifiable(_history);
  Set<String> get saved => Set.unmodifiable(_saved);
  List<Job> savedJobs(String category) => [
    for (final id in _saved.toList().reversed)
      for (final job in _jobs)
        if (job.id == id &&
            (category == 'Tất cả' ||
                (category == 'UI/UX'
                    ? job.category == 'Thiết kế'
                    : job.category == 'Web')))
          job,
  ];
  List<Job> get featured => List.unmodifiable(
    _jobs.where(
      (j) => ['job-demo-4', 'job-demo-5', 'job-demo-6'].contains(j.id),
    ),
  );
  List<Job> matching(JobFilters filters) =>
      _jobs.where(filters.matches).toList();
  List<Job> get results {
    final words = query
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final list = matching(applied)
        .where(
          (job) =>
              words.isEmpty ||
              words.any(
                (w) => '${job.title} ${job.skills.join(' ')} ${job.category}'
                    .toLowerCase()
                    .contains(w),
              ),
        )
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(list);
  }

  Future<void> initialize() async {
    if (_disposed) return;
    final generation = ++_loadGeneration;
    loading = true;
    error = null;
    _changed();
    try {
      final jobs = await _repository.fetchJobs();
      if (_disposed || generation != _loadGeneration) return;
      _jobs = jobs;
    } catch (_) {
      if (_disposed || generation != _loadGeneration) return;
      error = 'Chưa thể tải công việc. Vui lòng thử lại.';
    }
    loading = false;
    _changed();
  }

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  void setViewer(String id) {
    if (viewer == id) return;
    viewer = id;
    _saved.clear();
    _history
      ..clear()
      ..addAll(['Flutter developer', 'UI/UX Designer', 'Frontend React']);
    query = '';
    applied = const JobFilters();
    _changed();
  }

  void search(String value) {
    query = value.trim();
    applied = const JobFilters();
    if (query.isNotEmpty) {
      _history.remove(query);
      _history.insert(0, query);
      if (_history.length > 8) _history.removeLast();
    }
    _changed();
  }

  void clearHistory() {
    _history.clear();
    _changed();
  }

  void toggleSaved(String id) {
    if (!_saved.remove(id)) _saved.add(id);
    _changed();
  }

  void updateDraft(JobFilters filters) {
    draft = filters;
    _changed();
  }

  void resetDraft() {
    draft = const JobFilters();
    _changed();
  }

  void applyDraft() {
    applied = draft;
    query = '';
    _changed();
  }

  void category(String value) {
    applied = const JobFilters().copyWith(
      category: switch (value) {
        'Tất cả' => '',
        'UI/UX' => 'Thiết kế',
        'Lập trình' => 'Web',
        _ => value,
      },
    );
    query = '';
    _changed();
  }

  void removeTechnology() {
    applied = applied.copyWith(technology: '');
    _changed();
  }

  void removeRemote() {
    applied = applied.copyWith(remote: false);
    _changed();
  }

  void removeBudget() {
    applied = applied.copyWith(minimum: 0, maximum: 50000000);
    _changed();
  }

  void sortNewest() {
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    _loadGeneration++;
    super.dispose();
  }
}
