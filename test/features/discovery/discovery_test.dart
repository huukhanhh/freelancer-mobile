import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:workly/features/discovery/data/mock_job_repository.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/discovery/presentation/view_models/discovery_view_model.dart';

class ControlledJobs implements JobRepository {
  final requests = <Completer<List<Job>>>[];
  @override
  Future<List<Job>> fetchJobs() {
    final c = Completer<List<Job>>();
    requests.add(c);
    return c.future;
  }
}

void main() {
  test('search, history deletion and source Python empty state use actual fixtures', () async {
    final vm = DiscoveryViewModel(MockJobRepository());
    addTearDown(vm.dispose);
    await vm.initialize();
    expect(vm.results.length, 24);
    expect(vm.featured.map((j) => j.id), [
      'job-demo-4',
      'job-demo-5',
      'job-demo-6',
    ]);
    vm.search('Flutter developer');
    expect(vm.results, isNotEmpty);
    expect(vm.results.every((j) => j.skills.contains('Flutter')), isTrue);
    expect(vm.history.first, 'Flutter developer');
    vm.search('Python');
    expect(vm.results, isEmpty);
    vm.clearHistory();
    expect(vm.history, isEmpty);
  });
  test('budget, category, technology, billing and verification combine consistently', () async {
    final vm = DiscoveryViewModel(MockJobRepository());
    addTearDown(vm.dispose);
    await vm.initialize();
    vm.updateDraft(
      const JobFilters(
        minimum: 10000000,
        maximum: 20000000,
        category: 'Web',
        technology: 'Flutter',
        remote: true,
        verified: true,
        billing: 'Trọn gói',
      ),
    );
    vm.applyDraft();
    expect(vm.results, isNotEmpty);
    expect(
      vm.results.every(
        (j) =>
            j.budget >= 10000000 &&
            j.budget <= 20000000 &&
            j.category == 'Web' &&
            j.remote &&
            j.verified &&
            !j.hourly &&
            j.skills.contains('Flutter'),
      ),
      isTrue,
    );
    vm.removeTechnology();
    expect(vm.applied.technology, isEmpty);
    vm.removeBudget();
    expect(vm.applied.minimum, 0);
    vm.resetDraft();
    vm.applyDraft();
    expect(vm.results.length, 24);
  });
  test(
    'saved state survives navigation commands and clears for another viewer',
    () async {
      final vm = DiscoveryViewModel(MockJobRepository());
      addTearDown(vm.dispose);
      await vm.initialize();
      vm.setViewer('freelancer-a');
      vm.toggleSaved('job-demo-1');
      vm.search('React');
      vm.category('UI/UX');
      expect(vm.saved, {'job-demo-1'});
      vm.setViewer('freelancer-b');
      expect(vm.saved, isEmpty);
      expect(() => vm.saved.add('x'), throwsUnsupportedError);
    },
  );
  test('repository failure can retry without retaining an error', () async {
    final repo = MockJobRepository(unavailable: true);
    final vm = DiscoveryViewModel(repo);
    addTearDown(vm.dispose);
    await vm.initialize();
    expect(vm.error, isNotNull);
    expect(vm.loading, isFalse);
    repo.unavailable = false;
    await vm.initialize();
    expect(vm.error, isNull);
    expect(vm.results.length, 24);
  });
  test('in-flight completion after disposal never notifies', () async {
    final repo = ControlledJobs();
    final vm = DiscoveryViewModel(repo);
    var notices = 0;
    vm.addListener(() => notices++);
    final request = vm.initialize();
    vm.dispose();
    repo.requests.single.complete(const []);
    await request;
    expect(notices, 1);
  });
  test('late old load cannot overwrite a newer successful refresh', () async {
    final repo = ControlledJobs();
    final vm = DiscoveryViewModel(repo);
    addTearDown(vm.dispose);
    final older = vm.initialize();
    final newer = vm.initialize();
    repo.requests[1].complete(await MockJobRepository().fetchJobs());
    await newer;
    repo.requests[0].complete(const []);
    await older;
    expect(vm.results.length, 24);
    expect(vm.loading, isFalse);
    expect(vm.error, isNull);
  });
}
