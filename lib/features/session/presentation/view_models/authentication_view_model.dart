import 'package:flutter/foundation.dart';
import 'package:workly/features/session/domain/authentication_repository.dart';
import 'package:workly/features/session/domain/authentication_validation.dart';
import 'package:workly/features/session/domain/user_session.dart';

enum AuthenticationStatus { idle, submitting, authenticated, failure }

/// Owns login form commands; views may bind this after source design inspection.
/// No widget, routing, provider SDK or Firebase dependency belongs here.
class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationViewModel(this._repository);
  final AuthenticationRepository _repository;
  AuthenticationStatus _status = AuthenticationStatus.idle;
  UserSession? _session;
  String? _emailError;
  String? _passwordError;
  String? _message;
  bool needsVerification = false;
  int _generation = 0;
  bool _disposed = false;

  AuthenticationStatus get status => _status;
  UserSession? get session => _session;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get message => _message;

  Future<bool> signIn({required String email, required String password}) async {
    if (_disposed || _status == AuthenticationStatus.submitting) return false;
    _emailError = AuthenticationValidation.email(email);
    _passwordError = AuthenticationValidation.password(password);
    _message = null;
    needsVerification = false;
    if (_emailError != null || _passwordError != null) {
      _status = AuthenticationStatus.failure;
      notifyListeners();
      return false;
    }
    final generation = ++_generation;
    _status = AuthenticationStatus.submitting;
    notifyListeners();
    try {
      final session = await _repository.signIn(
        email: email.trim(),
        password: password,
      );
      if (_disposed || generation != _generation) return false;
      _session = session;
      _status = AuthenticationStatus.authenticated;
      notifyListeners();
      return true;
    } on AuthenticationFailure catch (error) {
      if (_disposed || generation != _generation) return false;
      needsVerification =
          error.code == AuthenticationFailureCode.unverifiedEmail;
      _message = switch (error.code) {
        AuthenticationFailureCode.invalidCredentials =>
          'Email hoặc mật khẩu chưa đúng.',
        AuthenticationFailureCode.unavailable =>
          'Chưa thể đăng nhập. Vui lòng thử lại.',
        AuthenticationFailureCode.unverifiedEmail =>
          'Vui lòng xác minh email trước khi đăng nhập.',
      };
    } catch (_) {
      if (_disposed || generation != _generation) return false;
      _message = 'Chưa thể đăng nhập. Vui lòng thử lại.';
    }
    _status = AuthenticationStatus.failure;
    notifyListeners();
    return false;
  }

  Future<bool> signOut() async {
    if (_disposed) return false;
    final generation = ++_generation;
    _status = AuthenticationStatus.submitting;
    _message = null;
    _emailError = null;
    _passwordError = null;
    notifyListeners();
    try {
      await _repository.signOut();
      if (_disposed || generation != _generation) return false;
      _session = null;
      _status = AuthenticationStatus.idle;
      notifyListeners();
      return true;
    } catch (_) {
      if (_disposed || generation != _generation) return false;
      _status = AuthenticationStatus.failure;
      _message = 'Chưa thể đăng xuất. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
