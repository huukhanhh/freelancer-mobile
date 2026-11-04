enum UserRole { client, freelancer }

/// Frontend metadata only, never an auth token or credential.
class UserSession {
  const UserSession({required this.userId, required this.role});
  final String userId;
  final UserRole role;
}
