import 'package:workly/features/session/domain/session_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

/// Deterministic in-memory fixtures, no network or real credentials.
class MockSessionRepository implements SessionRepository {
  MockSessionRepository({this.session});
  static const client = UserSession(
    userId: 'mock-client-001',
    role: UserRole.client,
  );
  static const freelancer = UserSession(
    userId: 'mock-freelancer-001',
    role: UserRole.freelancer,
  );
  final UserSession? session;
  @override
  Future<UserSession?> readSession() async => session;
}
