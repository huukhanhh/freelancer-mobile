import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_illustration.dart';
import 'package:workly/features/session/domain/authentication_validation.dart';

class RecoveryView extends StatefulWidget {
  const RecoveryView({
    required this.model,
    required this.onBack,
    required this.onSuccess,
    super.key,
  });
  final AuthFlowViewModel model;
  final VoidCallback onBack, onSuccess;
  @override
  State<RecoveryView> createState() => _RecoveryViewState();
}

class _RecoveryViewState extends State<RecoveryView> {
  final _form = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.model.email);
  final _password = TextEditingController(),
      _confirmation = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final resetting = widget.model.recoveryStep == 2;
    final ok = await widget.model.recover(_email.text, _password.text);
    if (mounted && ok && resetting) widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) {
      final m = widget.model;
      final reset = m.recoveryStep == 2;
      return AuthPage(
        title: 'Khôi phục tài khoản',
        onBack: widget.onBack,
        action: AuthAction(
          label: reset ? 'Cập nhật mật khẩu' : 'Gửi liên kết khôi phục',
          busy: m.busy,
          onPressed: _submit,
        ),
        child: Form(
          key: _form,
          child: AuthScrollBody(
            children: [
              if (reset) ...[
                AuthHeading(
                  title: 'Tạo mật khẩu mới',
                  subtitle: m.email,
                  node: '880:7967',
                ),
                AuthField(
                  label: 'Mật khẩu mới',
                  controller: _password,
                  password: true,
                  validator: (s) =>
                      AuthenticationValidation.newPassword(s ?? ''),
                ),
                AuthField(
                  label: 'Nhập lại mật khẩu mới',
                  controller: _confirmation,
                  password: true,
                  validator: (s) => s == _password.text
                      ? null
                      : 'Mật khẩu nhập lại chưa khớp.',
                  onSubmitted: _submit,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FigmaAsset(
                      '880:7967',
                      'imgProfileIconCheck',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dùng ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.',
                        style: authText(
                          13,
                          weight: FontWeight.w500,
                          color: EmeraldColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const AuthIllustration(node: '585:4406', recovery: true),
                Text(
                  'Quên mật khẩu?',
                  textAlign: TextAlign.left,
                  style: authText(25, weight: FontWeight.w700),
                ),
                Text(
                  'Nhập email đã đăng ký để nhận liên kết tạo mật khẩu mới.',
                  textAlign: TextAlign.left,
                  style: authText(14, color: EmeraldColors.textSecondary),
                ),
                AuthField(
                  label: 'Email đã đăng ký',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (s) => AuthenticationValidation.email(s ?? ''),
                ),
                Text(
                  'Mật khẩu hiện tại giữ nguyên đến khi bạn hoàn tất đặt lại.',
                  style: authText(11, color: EmeraldColors.textSecondary),
                ),
                AuthAction(
                  label: 'Quay lại đăng nhập',
                  outlined: true,
                  onPressed: widget.onBack,
                ),
              ],
              if (m.error case final String message)
                AuthFeedback(message: message),
            ],
          ),
        ),
      );
    },
  );
}

class RecoverySuccessView extends StatelessWidget {
  const RecoverySuccessView({
    required this.email,
    required this.onLogin,
    super.key,
  });
  final String email;
  final VoidCallback onLogin;
  @override
  Widget build(BuildContext context) => AuthPage(
    action: AuthAction(label: 'Quay lại đăng nhập', onPressed: onLogin),
    child: AuthScrollBody(
      children: [
        const AuthIllustration(node: '585:4440', confirmed: true),
        Text(
          'Sẵn sàng trở lại.',
          textAlign: TextAlign.center,
          style: authText(25, weight: FontWeight.w700),
        ),
        Text(
          'Mật khẩu đã được cập nhật thành công.',
          textAlign: TextAlign.center,
          style: authText(14, color: EmeraldColors.textSecondary),
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.primaryDark,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ProfileTokens.border),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Sử dụng mật khẩu mới để tiếp tục công việc.',
            style: authText(14, color: EmeraldColors.textSecondary),
          ),
        ),
      ],
    ),
  );
}
