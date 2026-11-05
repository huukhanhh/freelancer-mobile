import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/account_setup_repository.dart';
import 'package:workly/features/home/domain/marketplace_repository.dart';
import 'package:workly/features/home/data/mock_marketplace_repository.dart';

/// Composition root: replace repositories here when a backend is available.
class AppDependencies {
  const AppDependencies({
    required this.sessionRepository,
    this.marketplaceRepository = const MockMarketplaceRepository(),
  });
  factory AppDependencies.mock() =>
      AppDependencies(sessionRepository: MockSessionRepository());

  final AccountSetupRepository sessionRepository;
  final MarketplaceRepository marketplaceRepository;
}
