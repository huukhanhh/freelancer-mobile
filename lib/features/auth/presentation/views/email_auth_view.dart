import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/session/domain/authentication_validation.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/presentation/view_models/authentication_view_model.dart';

/// F04 / F07 share field geometry but retain separate source copy and commands.
class EmailAuthView extends StatefulWidget {
  const EmailAuthView({
    required this.model,
    required this.register,
    required this.onBack,
    required this.onAlternate,
    required this.onGoogle,
    required this.onRecovery,
    required this.onComplete,
    super.key,
  });
  final AuthFlowViewModel model;
  final bool register;
  final VoidCallback onBack, onAlternate, onGoogle, onRecovery, onComplete;
  @override
  State<EmailAuthView> createState() => _EmailAuthViewState();
}

class _EmailAuthViewState extends State<EmailAuthView> {
  final _form = GlobalKey<FormState>();
  late final _email = TextEditingController(
    text: widget.model.email.isEmpty
        ? (widget.register ? '' : DemoAccounts.clientEmail)
        : widget.model.email,
  );
  late final _password = TextEditingController(
    text: widget.register ? '' : DemoAccounts.password,
  );
  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = widget.register
        ? await widget.model.register(_email.text, _password.text)
        : await widget.model.signIn(_email.text, _password.text);
    if (mounted &&
        (ok ||
            (!widget.register &&
                widget.model.authentication.needsVerification))) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) {
      final registering = widget.register;
      final busy =
          widget.model.busy ||
          widget.model.authentication.status == AuthenticationStatus.submitting;
      return AuthPage(
        title: registering ? 'Tạo tài khoản' : 'Đăng nhập',
        onBack: widget.onBack,
        action: AuthAction(
          label: registering ? 'Tạo tài khoản' : 'Đăng nhập',
          busy: busy,
          onPressed: _submit,
        ),
        child: Form(
          key: _form,
          child: AutofillGroup(
            child: AuthScrollBody(
              children: [
                AuthHeading(
                  title: registering
                      ? 'Khởi đầu cùng Workly'
                      : 'Chào mừng trở lại',
                  subtitle: registering
                      ? 'Chọn vai trò sau lần đăng nhập đầu tiên.'
                      : 'Tiếp tục hành trình cùng Workly.',
                  node: registering ? '585:4204' : '585:4320',
                ),
                AuthField(
                  label: registering ? 'Email của bạn' : 'Địa chỉ email',
                  controller: _email,
                  validator: (s) => AuthenticationValidation.email(s ?? ''),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
                AuthField(
                  label: registering ? 'Tạo mật khẩu' : 'Mật khẩu',
                  controller: _password,
                  password: true,
                  validator: (s) => registering
                      ? AuthenticationValidation.newPassword(s ?? '')
                      : AuthenticationValidation.password(s ?? ''),
                  onSubmitted: _submit,
                  autofillHints: [
                    registering
                        ? AutofillHints.newPassword
                        : AutofillHints.password,
                  ],
                ),
                if (registering) ...[
                  Text(
                    'Ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.',
                    style: authText(11, color: EmeraldColors.textSecondary),
                  ),
                  Semantics(
                    checked: widget.model.consent,
                    label: 'Đồng ý điều khoản',
                    child: InkWell(
                      onTap: busy ? null : widget.model.toggleConsent,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 44),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: EmeraldColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: widget.model.consent
                                  ? const FigmaAsset(
                                      '585:4204',
                                      'imgProfileIconCheck',
                                      width: 22,
                                      height: 22,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tôi đồng ý với Điều khoản sử dụng và Chính sách bảo mật của Workly.',
                                style: authText(
                                  11,
                                  color: EmeraldColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    height: 44,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: widget.onRecovery,
                        child: Text(
                          'Quên mật khẩu?',
                          style: authText(
                            13,
                            weight: FontWeight.w500,
                            color: EmeraldColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                if ((registering
                        ? widget.model.error
                        : widget.model.authentication.message)
                    case final String message)
                  AuthFeedback(message: message),
                const AuthDivider(),
                AuthGoogleButton(onPressed: widget.onGoogle),
                AuthAction(
                  label: registering
                      ? 'Đã có tài khoản? Đăng nhập'
                      : 'Chưa có tài khoản? Đăng ký',
                  outlined: true,
                  onPressed: widget.onAlternate,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
