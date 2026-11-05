import 'package:workly/features/session/domain/user_session.dart';

/// Intentionally public, synthetic, offline demo inputs; never real credentials.
abstract final class DemoAccounts {
  static const password = 'WorklyDemo123!';
  static const clientEmail = 'client@workly.example';
  static const freelancerEmail = 'freelancer@workly.example';

  static const client = UserSession(
    userId: 'mock-client-001',
    role: UserRole.client,
    displayName: 'Khách hàng Demo',
    email: clientEmail,
  );
  static const freelancer = UserSession(
    userId: 'mock-freelancer-001',
    role: UserRole.freelancer,
    displayName: 'Freelancer Demo',
    email: freelancerEmail,
  );

  static UserSession? find(String email) =>
      switch (email.trim().toLowerCase()) {
        clientEmail => client,
        freelancerEmail => freelancer,
        _ => null,
      };
}
