import 'package:flutter_test/flutter_test.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/account_setup_repository.dart';
import 'package:workly/features/session/domain/authentication_repository.dart';
import 'package:workly/features/session/domain/authentication_validation.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/domain/user_session.dart';

void main() {
  const address = 'new@workly.example';
  const password = DemoAccounts.password;
  test(
    'registration requires verification, role setup survives logout',
    () async {
      final repo = MockSessionRepository();
      await repo.register(email: address, password: password);
      expect(await repo.readSession(), isNull);
      await expectLater(
        repo.signIn(email: address, password: password),
        throwsA(
          isA<AuthenticationFailure>().having(
            (e) => e.code,
            'code',
            AuthenticationFailureCode.unverifiedEmail,
          ),
        ),
      );
      await repo.verifyEmail(
        email: address,
        code: MockSessionRepository.demoCode,
      );
      final first = await repo.signIn(email: address, password: password);
      expect(first.profileComplete, isFalse);
      await repo.completeProfile(
        ProfileSetup(
          role: UserRole.client,
          displayName: 'Client Demo',
          companyName: 'Demo Studio',
          logoUploaded: true,
        ),
      );
      await repo.signOut();
      final next = await repo.signIn(email: address, password: password);
      expect(next.profileComplete, isTrue);
      expect(next.role, UserRole.client);
      expect(repo.profileFor(next.userId)?.companyName, 'Demo Studio');
    },
  );
  test(
    'OTP rejects wrong/expired input; resend renews five minute window',
    () async {
      var now = DateTime.utc(2026, 11, 5);
      final repo = MockSessionRepository(now: () => now);
      await repo.register(email: address, password: password);
      await expectLater(
        repo.verifyEmail(email: address, code: '000000'),
        throwsA(
          isA<AccountSetupFailure>().having(
            (e) => e.code,
            'code',
            AccountSetupFailureCode.invalidCode,
          ),
        ),
      );
      now = now.add(const Duration(minutes: 5));
      await expectLater(
        repo.verifyEmail(email: address, code: MockSessionRepository.demoCode),
        throwsA(
          isA<AccountSetupFailure>().having(
            (e) => e.code,
            'code',
            AccountSetupFailureCode.expiredCode,
          ),
        ),
      );
      await repo.resendCode(address);
      await repo.verifyEmail(
        email: address,
        code: MockSessionRepository.demoCode,
      );
      expect(
        (await repo.signIn(email: address, password: password)).email,
        address,
      );
    },
  );
  test(
    'duplicate email normalizes case and keeps original credentials',
    () async {
      final repo = MockSessionRepository();
      await repo.register(email: address, password: password);
      await expectLater(
        repo.register(email: ' NEW@WORKLY.EXAMPLE ', password: 'Different1'),
        throwsA(
          isA<AccountSetupFailure>().having(
            (e) => e.code,
            'code',
            AccountSetupFailureCode.duplicateEmail,
          ),
        ),
      );
      await repo.verifyEmail(
        email: address,
        code: MockSessionRepository.demoCode,
      );
      await repo.signIn(email: address, password: password);
    },
  );
  test('password reset updates login and consumes recovery grant', () async {
    final repo = MockSessionRepository();
    await repo.requestRecovery(DemoAccounts.clientEmail);
    await repo.resetPassword(
      email: DemoAccounts.clientEmail,
      password: 'NewDemo123!',
    );
    await expectLater(
      repo.signIn(email: DemoAccounts.clientEmail, password: password),
      throwsA(isA<AuthenticationFailure>()),
    );
    await repo.signIn(email: DemoAccounts.clientEmail, password: 'NewDemo123!');
    await expectLater(
      repo.resetPassword(
        email: DemoAccounts.clientEmail,
        password: 'OtherDemo123!',
      ),
      throwsA(isA<AccountSetupFailure>()),
    );
  });
  test(
    'recovery expiry and absent accounts reveal no account existence',
    () async {
      var now = DateTime.utc(2026, 11, 5);
      final repo = MockSessionRepository(now: () => now);
      await repo.requestRecovery(address);
      now = now.add(const Duration(minutes: 5));
      await expectLater(
        repo.resetPassword(email: address, password: password),
        throwsA(isA<AccountSetupFailure>()),
      );
      await repo.requestRecovery(address);
      await repo.resetPassword(email: address, password: password);
      expect(await repo.readSession(), isNull);
    },
  );
  test(
    'Google demo reuses profile and never needs a network provider',
    () async {
      final repo = MockSessionRepository();
      final first = await repo.signInWithGoogle();
      expect(first.profileComplete, isFalse);
      await repo.completeProfile(
        ProfileSetup(
          role: UserRole.freelancer,
          displayName: 'Demo',
          technologies: {'Flutter'},
        ),
      );
      await repo.signOut();
      final next = await repo.signInWithGoogle();
      expect(next.userId, first.userId);
      expect(next.profileComplete, isTrue);
      expect(repo.profileFor(next.userId)?.technologies, {'Flutter'});
    },
  );
  test('new password validation follows source strength requirement', () {
    for (final value in [
      'short',
      'alllowercase1',
      'ALLUPPERCASE1',
      'NoDigitsHere',
    ]) {
      expect(AuthenticationValidation.newPassword(value), isNotNull);
    }
    expect(AuthenticationValidation.newPassword(password), isNull);
  });
}
