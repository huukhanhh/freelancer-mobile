import 'package:flutter_test/flutter_test.dart';
import 'package:workly/features/discovery/data/mock_job_repository.dart';
import 'package:workly/features/projects/data/mock_project_repository.dart';
import 'package:workly/features/proposals/data/mock_proposal_repository.dart';
import 'package:workly/features/proposals/presentation/view_models/proposal_view_model.dart';

void main() {
  test(
    'listing IDs resolve correctly and role budgets sum to project budget',
    () async {
      final projects = await MockProjectRepository(MockJobRepository())
          .fetchProjects();
      expect(projects.first.title, 'Flutter E-commerce App');
      final green = projects.firstWhere((p) => p.id == 'job-demo-4');
      expect(
        green.vacancies.fold<int>(0, (n, v) => n + v.budget),
        green.budget,
      );
      expect(green.vacancies[1].title, 'Frontend');
    },
  );
  test(
    'screening requires answers and retains them when navigating backwards',
    () async {
      final projects = await MockProjectRepository(MockJobRepository())
          .fetchProjects();
      final p = projects[3];
      final vm = ProposalViewModel(MockProposalRepository());
      addTearDown(vm.dispose);
      await vm.setViewer('synthetic-a');
      vm.begin(p, p.vacancies[0]);
      expect(vm.nextQuestion(), false);
      expect(vm.draft!.answerError, true);
      vm.answer('Synthetic answer one');
      expect(vm.nextQuestion(), false);
      expect(vm.draft!.question, 1);
      vm.answer('Synthetic answer two');
      expect(vm.previousQuestion(), true);
      expect(vm.draft!.answers.first, 'Synthetic answer one');
    },
  );
  test(
    'quote rejects invalid dates and updates review dates from edited inputs',
    () async {
      final projects = await MockProjectRepository(MockJobRepository())
          .fetchProjects();
      final p = projects[3];
      final vm = ProposalViewModel(MockProposalRepository());
      addTearDown(vm.dispose);
      await vm.setViewer('synthetic-a');
      vm.begin(p, p.vacancies[1]);
      vm.changeQuote(startDate: '31/02/2026');
      expect(vm.validateQuote(), false);
      vm.changeQuote(startDate: '10/11/2026', days: '5', price: '18.500.000');
      expect(vm.validateQuote(), true);
      expect(vm.draft!.amount, 18500000);
      expect(vm.draft!.dates, '10/11/2026 → 14/11/2026');
      vm.changeQuote(price: '-100');
      expect(vm.validateQuote(), false);
    },
  );
  test('submit retains selected role and deduplicates retries; viewers are isolated', () async {
    final projects = await MockProjectRepository(MockJobRepository())
        .fetchProjects();
    final p = projects[3];
    final store = MockProposalRepository();
    final vm = ProposalViewModel(store);
    addTearDown(vm.dispose);
    await vm.setViewer('synthetic-a');
    vm.begin(p, p.vacancies[1]);
    vm.changeLetter('Synthetic frontend application.');
    expect(await vm.submit(), false);
    for (var i = 0; i < 3; i++) {
      vm.answer('Synthetic answer $i');
      vm.nextQuestion();
    }
    expect(await vm.submit(), true);
    expect(vm.sent!.vacancy, 'Frontend');
    expect(vm.sent!.price, 18000000);
    expect(vm.sent!.answers.length, 3);
    expect(vm.proposals.length, 4);
    expect(await vm.submit(), true);
    expect(vm.proposals.length, 4);
    await vm.setViewer('synthetic-b');
    expect(vm.draft, isNull);
    expect(vm.sent, isNull);
    expect(vm.proposals.length, 3);
  });
}
