import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/session_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

class PendingSessionRepository implements SessionRepository {
  final requests = <Completer<UserSession?>>[];
  @override
  Future<UserSession?> readSession() {
    final request = Completer<UserSession?>();
    requests.add(request);
    return request.future;
  }
}

void main() {
  test('anonymous and role fixtures remain distinct', () async {
    for (final fixture in [
      null,
      MockSessionRepository.client,
      MockSessionRepository.freelancer,
    ]) {
      final vm = SessionViewModel(MockSessionRepository(session: fixture));
      addTearDown(vm.dispose);
      final states = <SessionStatus>[];
      vm.addListener(() => states.add(vm.status));
      await vm.initialize();
      expect(states, [SessionStatus.loading, SessionStatus.ready]);
      expect(vm.session, same(fixture));
    }
  });
  test('failure clears state and can be retried', () async {
    final repository = PendingSessionRepository();
    final vm = SessionViewModel(repository);
    addTearDown(vm.dispose);
    final first = vm.initialize();
    repository.requests.single.completeError(StateError('synthetic failure'));
    await first;
    expect(vm.status, SessionStatus.failure);
    expect(vm.session, isNull);
    final retry = vm.initialize();
    repository.requests.last.complete(MockSessionRepository.client);
    await retry;
    expect(vm.status, SessionStatus.ready);
    expect(vm.session?.role, UserRole.client);
  });
  test('late response cannot replace latest session', () async {
    final repository = PendingSessionRepository();
    final vm = SessionViewModel(repository);
    addTearDown(vm.dispose);
    final old = vm.initialize();
    final latest = vm.initialize();
    repository.requests.last.complete(MockSessionRepository.freelancer);
    await latest;
    repository.requests.first.complete(MockSessionRepository.client);
    await old;
    expect(vm.session?.role, UserRole.freelancer);
  });
  test('completion after disposal does not notify', () async {
    final repository = PendingSessionRepository();
    final vm = SessionViewModel(repository);
    var notifications = 0;
    vm.addListener(() => notifications++);
    final pending = vm.initialize();
    vm.dispose();
    repository.requests.single.complete(MockSessionRepository.client);
    await pending;
    expect(notifications, 1);
  });
}
