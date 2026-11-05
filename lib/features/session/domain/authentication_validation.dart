/// Client-side demo validation only; backend authorization stays server-side.
abstract final class AuthenticationValidation {
  static String? email(String value) {
    final input = value.trim();
    if (input.isEmpty) return 'Vui lòng nhập email.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(input)) {
      return 'Email chưa đúng định dạng.';
    }
    return null;
  }

  static String? password(String value) =>
      value.isEmpty ? 'Vui lòng nhập mật khẩu.' : null;

  static String? newPassword(String value) =>
      value.length < 8 ||
          !RegExp('[A-Z]').hasMatch(value) ||
          !RegExp('[a-z]').hasMatch(value) ||
          !RegExp('[0-9]').hasMatch(value)
      ? 'Ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.'
      : null;
}
