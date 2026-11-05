import 'package:workly/features/projects/domain/project_repository.dart';
import 'package:workly/features/proposals/domain/proposal_repository.dart';

class MockProposalRepository implements ProposalRepository {
  final _records = <String, List<Proposal>>{};
  List<Proposal> _forViewer(String viewer) => _records.putIfAbsent(
    viewer,
    () => [
      for (var i = 0; i < 3; i++)
        Proposal(
          id: 'DX-DEMO-${i + 1}',
          projectId: 'proposal-seed-${i + 1}',
          title: [
            'Thiết kế app giao đồ ăn',
            'Thiết kế website Mộc Studio',
            'Bộ nhận diện Cà phê Việt',
          ][i],
          vacancy: 'UI/UX',
          price: [12500000, 8000000, 6500000][i],
          days: 30,
          letter: '',
          answers: const [],
          startDate: '01/11/2026',
          imageNode: '585:7841',
          imageSlot: 'imgProjectCoverThumbnail${i == 0 ? '' : i}',
          sentDate: ['23/10/2026', '21/10/2026', '19/10/2026'][i],
        ),
    ],
  );
  @override
  Future<List<Proposal>> fetchProposals(String viewer) async =>
      List.unmodifiable(_forViewer(viewer));
  @override
  Future<Proposal> submit(
    String viewer,
    Project project,
    Vacancy vacancy, {
    required int price,
    required int days,
    required String startDate,
    required String letter,
    required List<String> answers,
  }) async {
    if (viewer.isEmpty) throw StateError('No mock viewer');
    final rows = _forViewer(viewer);
    for (final p in rows) {
      if (p.projectId == project.id && p.vacancy == vacancy.title) return p;
    }
    final p = Proposal(
      id: 'DX-DEMO-${rows.length + 1}',
      projectId: project.id,
      title: project.title,
      vacancy: vacancy.title,
      price: price,
      days: days,
      letter: letter,
      answers: List.unmodifiable(answers),
      startDate: startDate,
      imageNode: project.imageNode,
      imageSlot: project.imageSlot,
    );
    rows.insert(0, p);
    return p;
  }
}
