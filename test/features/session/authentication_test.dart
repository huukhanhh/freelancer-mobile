import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/authentication_repository.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/domain/user_session.dart';
import 'package:workly/features/session/presentation/view_models/authentication_view_model.dart';

class ControlledAuthenticationRepository implements AuthenticationRepository {
  final login = Completer<UserSession>();
  int signInCount = 0;
  @override
  Future<UserSession?> readSession() async => null;
  @override
  Future<UserSession> signIn({
    required String email,
    required String password,
  }) {
    signInCount++;
    return login.future;
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  test(
    'both demo roles authenticate offline and logout clears repository state',
    () async {
      for (final account in [DemoAccounts.client, DemoAccounts.freelancer]) {
        final repository = MockSessionRepository();
        expect(await repository.readSession(), isNull);
        final signedIn = await repository.signIn(
          email: '  ${account.email.toUpperCase()}  ',
          password: DemoAccounts.password,
        );
        expect(signedIn.role, account.role);
        expect((await repository.readSession())?.userId, account.userId);
        await repository.signOut();
        expect(await repository.readSession(), isNull);
      }
    },
  );

  test(
    'bad credentials do not establish a session or expose the password',
    () async {
      final repository = MockSessionRepository();
      await expectLater(
        repository.signIn(email: DemoAccounts.clientEmail, password: 'wrong'),
        throwsA(isA<AuthenticationFailure>()),
      );
      expect(await repository.readSession(), isNull);
    },
  );

  test(
    'form validation prevents repository calls; valid retry succeeds',
    () async {
      final repository = ControlledAuthenticationRepository();
      final vm = AuthenticationViewModel(repository);
      addTearDown(vm.dispose);
      expect(await vm.signIn(email: 'bad-email', password: ''), isFalse);
      expect(vm.emailError, isNotNull);
      expect(vm.passwordError, isNotNull);
      expect(repository.signInCount, 0);
      final request = vm.signIn(
        email: DemoAccounts.clientEmail,
        password: DemoAccounts.password,
      );
      expect(vm.status, AuthenticationStatus.submitting);
      expect(vm.emailError, isNull);
      expect(vm.passwordError, isNull);
      repository.login.complete(DemoAccounts.client);
      expect(await request, isTrue);
      expect(vm.session?.role, UserRole.client);
    },
  );

  test(
    'invalid login shows failure and a later valid login recovers',
    () async {
      final repository = MockSessionRepository();
      final vm = AuthenticationViewModel(repository);
      addTearDown(vm.dispose);
      expect(
        await vm.signIn(email: DemoAccounts.clientEmail, password: 'wrong'),
        isFalse,
      );
      expect(vm.status, AuthenticationStatus.failure);
      expect(vm.message, isNotNull);
      expect(
        await vm.signIn(
          email: DemoAccounts.freelancerEmail,
          password: DemoAccounts.password,
        ),
        isTrue,
      );
      expect(vm.message, isNull);
      expect(vm.session?.role, UserRole.freelancer);
      expect(await vm.signOut(), isTrue);
      expect(vm.session, isNull);
      expect(await repository.readSession(), isNull);
    },
  );

  test('repeat submit does not duplicate login and late completion cannot undo logout', () async {
    final repository = ControlledAuthenticationRepository();
    final vm = AuthenticationViewModel(repository);
    addTearDown(vm.dispose);
    final pending = vm.signIn(
      email: DemoAccounts.clientEmail,
      password: DemoAccounts.password,
    );
    expect(
      await vm.signIn(
        email: DemoAccounts.clientEmail,
        password: DemoAccounts.password,
      ),
      isFalse,
    );
    expect(repository.signInCount, 1);
    expect(await vm.signOut(), isTrue);
    repository.login.complete(DemoAccounts.client);
    expect(await pending, isFalse);
    expect(vm.status, AuthenticationStatus.idle);
    expect(vm.session, isNull);
  });

  test('completion after disposal does not notify listeners', () async {
    final repository = ControlledAuthenticationRepository();
    final vm = AuthenticationViewModel(repository);
    var notifications = 0;
    vm.addListener(() => notifications++);
    final pending = vm.signIn(
      email: DemoAccounts.clientEmail,
      password: DemoAccounts.password,
    );
    vm.dispose();
    repository.login.complete(DemoAccounts.client);
    expect(await pending, isFalse);
    expect(notifications, 1);
  });

  test('deterministic unavailable scenario can be retried', () async {
    final repository = MockSessionRepository(unavailable: true);
    final vm = AuthenticationViewModel(repository);
    addTearDown(vm.dispose);
    expect(
      await vm.signIn(
        email: DemoAccounts.clientEmail,
        password: DemoAccounts.password,
      ),
      isFalse,
    );
    expect(vm.status, AuthenticationStatus.failure);
    repository.unavailable = false;
    expect(
      await vm.signIn(
        email: DemoAccounts.clientEmail,
        password: DemoAccounts.password,
      ),
      isTrue,
    );
  });

  test('repository logout invalidates an in-flight delayed login', () async {
    final repository = MockSessionRepository(
      latency: const Duration(milliseconds: 5),
    );
    final pending = repository.signIn(
      email: DemoAccounts.clientEmail,
      password: DemoAccounts.password,
    );
    await repository.signOut();
    await expectLater(pending, throwsA(isA<AuthenticationFailure>()));
    expect(await repository.readSession(), isNull);
  });
}
