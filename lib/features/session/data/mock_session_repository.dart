import 'package:workly/features/session/domain/authentication_repository.dart';
import 'package:workly/features/session/domain/account_setup_repository.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/domain/user_session.dart';

/// In-memory offline demo. The delay/error controls support deterministic UI QA.
/// All state resets on process restart; these are not production credentials.
class MockSessionRepository implements AccountSetupRepository {
  factory MockSessionRepository({
    UserSession? session,
    Duration latency = Duration.zero,
    bool unavailable = false,
    DateTime Function()? now,
  }) => MockSessionRepository._(
    session,
    latency,
    unavailable,
    now ?? DateTime.now,
  );

  MockSessionRepository._(
    this._session,
    this.latency,
    this.unavailable,
    this._now,
  );

  static const client = DemoAccounts.client;
  static const freelancer = DemoAccounts.freelancer;
  final Duration latency;
  bool unavailable;
  UserSession? _session;
  final DateTime Function() _now;
  final _users = <String, UserSession>{
    DemoAccounts.clientEmail: client,
    DemoAccounts.freelancerEmail: freelancer,
  };
  final _passwords = <String, String>{
    DemoAccounts.clientEmail: DemoAccounts.password,
    DemoAccounts.freelancerEmail: DemoAccounts.password,
  };
  final _verified = <String>{
    DemoAccounts.clientEmail,
    DemoAccounts.freelancerEmail,
  };
  final _codesExpire = <String, DateTime>{};
  final _profiles = <String, ProfileSetup>{};
  String? _recoveryEmail;
  DateTime? _recoveryExpiry;
  static const demoCode = '482916';
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
    final address = email.trim().toLowerCase();
    final account = _users[address];
    if (account == null || password != _passwords[address]) {
      throw const AuthenticationFailure(
        AuthenticationFailureCode.invalidCredentials,
      );
    }
    if (!_verified.contains(address)) {
      throw const AuthenticationFailure(
        AuthenticationFailureCode.unverifiedEmail,
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

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _wait();
    final address = email.trim().toLowerCase();
    if (_users.containsKey(address)) {
      throw const AccountSetupFailure(AccountSetupFailureCode.duplicateEmail);
    }
    _users[address] = UserSession(
      userId: 'mock-user-${_users.length + 1}',
      role: UserRole.freelancer,
      email: address,
      profileComplete: false,
    );
    _passwords[address] = password;
    _codesExpire[address] = _now().add(const Duration(minutes: 5));
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    await _wait();
    final address = email.trim().toLowerCase();
    final expiry = _codesExpire[address];
    if (expiry == null) {
      throw const AccountSetupFailure(AccountSetupFailureCode.invalidState);
    }
    if (!_now().isBefore(expiry)) {
      throw const AccountSetupFailure(AccountSetupFailureCode.expiredCode);
    }
    if (code != demoCode) {
      throw const AccountSetupFailure(AccountSetupFailureCode.invalidCode);
    }
    _verified.add(address);
    _codesExpire.remove(address);
  }

  @override
  Future<void> resendCode(String email) async {
    await _wait();
    final address = email.trim().toLowerCase();
    if (!_users.containsKey(address) || _verified.contains(address)) {
      throw const AccountSetupFailure(AccountSetupFailureCode.invalidState);
    }
    _codesExpire[address] = _now().add(const Duration(minutes: 5));
  }

  @override
  Future<UserSession> signInWithGoogle() async {
    final operation = ++_operation;
    await _wait();
    if (operation != _operation) {
      throw const AuthenticationFailure(AuthenticationFailureCode.unavailable);
    }
    const email = 'minhanh@workly.example';
    final account = _users.putIfAbsent(
      email,
      () => const UserSession(
        userId: 'mock-google-001',
        role: UserRole.freelancer,
        email: email,
        displayName: 'Minh Anh Demo',
        profileComplete: false,
      ),
    );
    _verified.add(email);
    _session = account;
    return account;
  }

  @override
  Future<UserSession> completeProfile(ProfileSetup profile) async {
    final operation = _operation;
    final current = _session;
    await _wait();
    if (current == null ||
        operation != _operation ||
        !identical(current, _session)) {
      throw const AccountSetupFailure(AccountSetupFailureCode.invalidState);
    }
    final next = current.copyWith(
      role: profile.role,
      displayName: profile.displayName,
      profileComplete: true,
    );
    _profiles[current.userId] = profile;
    _users[current.email] = next;
    _session = next;
    return next;
  }

  @override
  ProfileSetup? profileFor(String userId) => _profiles[userId];

  @override
  Future<void> requestRecovery(String email) async {
    await _wait();
    _recoveryEmail = email.trim().toLowerCase();
    _recoveryExpiry = _now().add(const Duration(minutes: 5));
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String password,
  }) async {
    await _wait();
    final address = email.trim().toLowerCase();
    if (address != _recoveryEmail ||
        _recoveryExpiry == null ||
        !_now().isBefore(_recoveryExpiry!)) {
      throw const AccountSetupFailure(AccountSetupFailureCode.invalidState);
    }
    // Privacy-preserving demo: a missing account gets the same success response.
    if (_passwords.containsKey(address)) _passwords[address] = password;
    _recoveryEmail = null;
    _recoveryExpiry = null;
  }
}
