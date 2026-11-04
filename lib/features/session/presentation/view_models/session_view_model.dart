import 'package:flutter/foundation.dart';
import 'package:workly/features/session/domain/session_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

enum SessionStatus { idle, loading, ready, failure }

class SessionViewModel extends ChangeNotifier {
  SessionViewModel(this._repository);
  final SessionRepository _repository;
  SessionStatus _status = SessionStatus.idle;
  UserSession? _session;
  int _generation = 0;
  bool _disposed = false;
  SessionStatus get status => _status;
  UserSession? get session => _session;

  Future<void> initialize() async {
    if (_disposed) return;
    final generation = ++_generation;
    _status = SessionStatus.loading;
    _session = null;
    notifyListeners();
    try {
      final value = await _repository.readSession();
      if (_disposed || generation != _generation) return;
      _session = value;
      _status = SessionStatus.ready;
    } catch (_) {
      if (_disposed || generation != _generation) return;
      _status = SessionStatus.failure;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
