import 'package:workly/features/projects/domain/project_repository.dart';

class Proposal {
  const Proposal({
    required this.id,
    required this.projectId,
    required this.title,
    required this.vacancy,
    required this.price,
    required this.days,
    required this.letter,
    required this.answers,
    required this.startDate,
    required this.imageNode,
    required this.imageSlot,
    this.status = 'Đang chờ',
    this.sentDate = '05/11/2026',
  });
  final String id,
      projectId,
      title,
      vacancy,
      letter,
      startDate,
      imageNode,
      imageSlot,
      status,
      sentDate;
  final int price, days;
  final List<String> answers;
}

abstract interface class ProposalRepository {
  Future<List<Proposal>> fetchProposals(String viewer);
  Future<Proposal> submit(
    String viewer,
    Project project,
    Vacancy vacancy, {
    required int price,
    required int days,
    required String startDate,
    required String letter,
    required List<String> answers,
  });
}
