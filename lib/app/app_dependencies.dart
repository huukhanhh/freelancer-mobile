import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/session_repository.dart';

/// Composition root: replace repositories here when a backend is available.
class AppDependencies {
  const AppDependencies({required this.sessionRepository});
  factory AppDependencies.mock() =>
      AppDependencies(sessionRepository: MockSessionRepository());

  final SessionRepository sessionRepository;
}
