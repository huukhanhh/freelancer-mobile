import 'package:workly/features/projects/domain/project_repository.dart';
import 'package:workly/features/projects/data/mock_project_repository.dart';
import 'package:workly/features/proposals/domain/proposal_repository.dart';
import 'package:workly/features/proposals/data/mock_proposal_repository.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/account_setup_repository.dart';
import 'package:workly/features/home/domain/marketplace_repository.dart';
import 'package:workly/features/home/data/mock_marketplace_repository.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/discovery/data/mock_job_repository.dart';

/// Composition root: replace repositories here when a backend is available.
class AppDependencies {
  AppDependencies({
    required this.sessionRepository,
    this.marketplaceRepository = const MockMarketplaceRepository(),
    JobRepository? jobRepository,
    ProjectRepository? projectRepository,
    ProposalRepository? proposalRepository,
  }) : jobRepository = jobRepository ?? MockJobRepository(),
       proposalRepository = proposalRepository ?? MockProposalRepository() {
    this.projectRepository =
        projectRepository ?? MockProjectRepository(this.jobRepository);
  }
  factory AppDependencies.mock() =>
      AppDependencies(sessionRepository: MockSessionRepository());

  final AccountSetupRepository sessionRepository;
  final MarketplaceRepository marketplaceRepository;
  final JobRepository jobRepository;
  late final ProjectRepository projectRepository;
  final ProposalRepository proposalRepository;
}
