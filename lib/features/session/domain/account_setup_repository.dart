import 'package:workly/features/session/domain/authentication_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

/// Mock-first contract for the observed registration/OTP/setup/recovery flows.
abstract interface class AccountSetupRepository
    implements AuthenticationRepository {
  Future<void> register({required String email, required String password});
  Future<void> verifyEmail({required String email, required String code});
  Future<void> resendCode(String email);
  Future<UserSession> signInWithGoogle();
  Future<UserSession> completeProfile(ProfileSetup profile);
  Future<void> requestRecovery(String email);
  Future<void> resetPassword({required String email, required String password});
  ProfileSetup? profileFor(String userId);
}

class ProfileSetup {
  ProfileSetup({
    required this.role,
    required this.displayName,
    this.specialty = '',
    Set<String> technologies = const {},
    this.companyName,
    this.companyWebsite,
    this.logoUploaded = false,
  }) : technologies = Set.unmodifiable(technologies);
  final UserRole role;
  final String displayName;
  final String specialty;
  final Set<String> technologies;
  final String? companyName;
  final String? companyWebsite;
  final bool logoUploaded;
}

enum AccountSetupFailureCode {
  duplicateEmail,
  invalidCode,
  expiredCode,
  invalidState,
}

class AccountSetupFailure implements Exception {
  const AccountSetupFailure(this.code);
  final AccountSetupFailureCode code;
}
