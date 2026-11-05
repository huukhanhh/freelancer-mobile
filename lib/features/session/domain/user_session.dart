enum UserRole { client, freelancer }

/// Frontend metadata only, never an auth token or credential.
class UserSession {
  const UserSession({
    required this.userId,
    required this.role,
    this.displayName = '',
    this.email = '',
    this.profileComplete = true,
  });
  final String userId;
  final UserRole role;
  final String displayName;
  final String email;
  final bool profileComplete;

  UserSession copyWith({
    UserRole? role,
    String? displayName,
    bool? profileComplete,
  }) => UserSession(
    userId: userId,
    role: role ?? this.role,
    displayName: displayName ?? this.displayName,
    email: email,
    profileComplete: profileComplete ?? this.profileComplete,
  );
}
