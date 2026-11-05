import 'package:workly/features/session/domain/session_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

/// Frontend auth boundary. A future Firebase adapter must implement this contract.
/// Mock authentication does not provide security or a production credential.
abstract interface class AuthenticationRepository implements SessionRepository {
  Future<UserSession> signIn({required String email, required String password});
  Future<void> signOut();
}

enum AuthenticationFailureCode {
  invalidCredentials,
  unavailable,
  unverifiedEmail,
}

class AuthenticationFailure implements Exception {
  const AuthenticationFailure(this.code);
  final AuthenticationFailureCode code;
}
