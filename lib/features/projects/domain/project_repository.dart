class Vacancy {
  const Vacancy(this.id, this.title, this.budget, this.scope);
  final String id, title, scope;
  final int budget;
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
  });
  final String id, code, title, owner, description, imageNode, imageSlot;
  final int budget, days;
  final List<Vacancy> vacancies;
}

abstract interface class ProjectRepository {
  Future<List<Project>> fetchProjects();
  Future<ProjectManagement> fetchManagement();
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
