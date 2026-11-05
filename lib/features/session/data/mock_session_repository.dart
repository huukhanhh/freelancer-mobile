import 'package:workly/features/session/domain/authentication_repository.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/domain/user_session.dart';

/// In-memory offline demo. The delay/error controls support deterministic UI QA.
/// All state resets on process restart; these are not production credentials.
class MockSessionRepository implements AuthenticationRepository {
  factory MockSessionRepository({
    UserSession? session,
    Duration latency = Duration.zero,
    bool unavailable = false,
  }) => MockSessionRepository._(session, latency, unavailable);

  MockSessionRepository._(this._session, this.latency, this.unavailable);

  static const client = DemoAccounts.client;
  static const freelancer = DemoAccounts.freelancer;
  final Duration latency;
  bool unavailable;
  UserSession? _session;
  int _operation = 0;
  UserSession? get session => _session;

  Future<void> _wait() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (unavailable) {
      throw const AuthenticationFailure(AuthenticationFailureCode.unavailable);
    }
  }

  @override
  Future<UserSession?> readSession() async {
    await _wait();
    return _session;
  }

  @override
  Future<UserSession> signIn({
    required String email,
    required String password,
  }) async {
    final operation = ++_operation;
    await _wait();
    if (operation != _operation) {
      throw const AuthenticationFailure(AuthenticationFailureCode.unavailable);
    }
    final account = DemoAccounts.find(email);
    if (account == null || password != DemoAccounts.password) {
      throw const AuthenticationFailure(
        AuthenticationFailureCode.invalidCredentials,
      );
    }
    _session = account;
    return account;
  }

  @override
  Future<void> signOut() async {
    // Invalidate requests synchronously so a late login cannot restore a session.
    if (unavailable) {
      throw const AuthenticationFailure(AuthenticationFailureCode.unavailable);
    }
    _operation++;
    _session = null;
  }
}
