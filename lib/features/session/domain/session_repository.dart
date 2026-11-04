import 'package:workly/features/session/domain/user_session.dart';

abstract interface class SessionRepository {
  /// Null means anonymous. Implementations may throw on failure.
  Future<UserSession?> readSession();
}
