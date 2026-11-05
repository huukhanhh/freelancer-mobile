import 'package:flutter/foundation.dart';
import 'package:workly/features/session/domain/account_setup_repository.dart';
import 'package:workly/features/session/domain/authentication_validation.dart';
import 'package:workly/features/session/domain/user_session.dart';
import 'package:workly/features/session/presentation/view_models/authentication_view_model.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

class AuthFlowViewModel extends ChangeNotifier {
  AuthFlowViewModel(this.repository, this.session) {
    authentication = AuthenticationViewModel(repository);
    authentication.addListener(_changed);
  }
  final AccountSetupRepository repository;
  final SessionViewModel session;
  late final AuthenticationViewModel authentication;
  bool onboardingSeen = false;
  bool splashFinished = false;
  void finishSplash() {
    splashFinished = true;
    _changed();
  }

  bool consent = true;
  bool otpVerified = false;
  bool busy = false;
  String email = '';
  String? error;
  String resendLabel = 'Gửi lại mã';
  UserRole? selectedRole;
  int recoveryStep = 0;
  bool _disposed = false;

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  void finishOnboarding() {
    onboardingSeen = true;
    _changed();
  }

  void toggleConsent() {
    consent = !consent;
    error = null;
    _changed();
  }

  void selectRole(UserRole role) {
    selectedRole = role;
    _changed();
  }

  void clearError() {
    error = null;
    _changed();
  }

  void beginRecovery() {
    recoveryStep = 0;
    error = null;
    _changed();
  }

  Future<bool> run(Future<void> Function() operation) async {
    if (_disposed || busy) return false;
    busy = true;
    error = null;
    _changed();
    var success = false;
    try {
      await operation();
      success = true;
    } on AccountSetupFailure catch (failure) {
      error = switch (failure.code) {
        AccountSetupFailureCode.duplicateEmail => 'Email đã được đăng ký.',
        AccountSetupFailureCode.invalidCode => 'Mã xác minh chưa đúng.',
        AccountSetupFailureCode.expiredCode =>
          'Mã đã hết hạn. Vui lòng gửi lại mã.',
        AccountSetupFailureCode.invalidState =>
          'Vui lòng thực hiện lại bước trước.',
      };
    } catch (_) {
      error = 'Chưa thể thực hiện. Vui lòng thử lại.';
    }
    if (_disposed) return false;
    busy = false;
    _changed();
    return success;
  }

  Future<bool> register(String address, String password) async {
    if (!consent) {
      error = 'Vui lòng đồng ý Điều khoản sử dụng và Chính sách bảo mật.';
      _changed();
      return false;
    }
    if (AuthenticationValidation.email(address) != null ||
        AuthenticationValidation.newPassword(password) != null) {
      return false;
    }
    return run(() async {
      await repository.register(email: address, password: password);
      email = address.trim().toLowerCase();
      otpVerified = false;
      resendLabel = 'Gửi lại mã';
      selectedRole = null;
    });
  }

  Future<bool> verify(String code) => run(() async {
    await repository.verifyEmail(email: email, code: code);
    otpVerified = true;
  });

  Future<bool> resend() => run(() async {
    await repository.resendCode(email);
    resendLabel = 'Đã gửi lại mã';
  });

  Future<bool> signIn(String address, String password) async {
    final success = await authentication.signIn(
      email: address,
      password: password,
    );
    if (_disposed) return false;
    email = address.trim().toLowerCase();
    if (success) await session.initialize();
    _changed();
    return success;
  }

  Future<bool> google() => run(() async {
    final user = await repository.signInWithGoogle();
    email = user.email;
    await session.initialize();
  });

  Future<bool> complete(ProfileSetup profile) => run(() async {
    await repository.completeProfile(profile);
    await session.initialize();
  });

  Future<bool> recover(String address, String password) => run(() async {
    if (recoveryStep < 2) {
      email = address.trim().toLowerCase();
      await repository.requestRecovery(email);
      // The source CTA changes directly to the New password state.
      recoveryStep = 2;
    } else {
      await repository.resetPassword(email: email, password: password);
    }
  });

  Future<bool> signOut() async {
    final success = await authentication.signOut();
    if (success) await session.initialize();
    return success;
  }

  @override
  void dispose() {
    _disposed = true;
    authentication.removeListener(_changed);
    authentication.dispose();
    super.dispose();
  }
}
