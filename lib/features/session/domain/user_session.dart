enum UserRole { client, freelancer }

/// Frontend metadata only, never an auth token or credential.
class UserSession {
  const UserSession({
    required this.userId,
    required this.role,
    this.displayName = '',
    this.email = '',
  });
  final String userId;
  final UserRole role;
  final String displayName;
  final String email;
}
