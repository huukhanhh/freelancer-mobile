import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_illustration.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({
    required this.model,
    required this.onBack,
    required this.onLogin,
    super.key,
  });
  final AuthFlowViewModel model;
  final VoidCallback onBack, onLogin;
  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final _digits = List.generate(6, (_) => TextEditingController());
  final _focus = List.generate(6, (_) => FocusNode());
  @override
  void dispose() {
    for (final c in _digits) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  void _changed(int index, String text) {
    if (text.length > 1) {
      // Paste/autofill all six digits, also when pasted into a later box.
      final start = text.length >= 6 ? 0 : index;
      for (var i = 0; i < text.length && start + i < 6; i++) {
        _digits[start + i].text = text[i];
      }
      _focus[(start + text.length).clamp(0, 5)].requestFocus();
    } else if (text.isNotEmpty && index < 5) {
      _focus[index + 1].requestFocus();
    } else if (text.isEmpty && index > 0) {
      _focus[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) {
      final m = widget.model;
      return AuthPage(
        title: 'Xác minh email',
        onBack: widget.onBack,
        action: AuthAction(
          label: m.otpVerified ? 'Đăng nhập lần đầu' : 'Xác minh email',
          busy: m.busy,
          onPressed: () {
            if (m.otpVerified) {
              widget.onLogin();
            } else {
              FocusScope.of(context).unfocus();
              m.verify(_digits.map((c) => c.text).join());
            }
          },
        ),
        child: AuthScrollBody(
          gap: m.otpVerified ? 16 : 12,
          children: m.otpVerified
              ? [
                  const AuthIllustration(node: '880:7738', confirmed: true),
                  Text(
                    'Đăng ký thành công',
                    textAlign: TextAlign.center,
                    style: authText(21, weight: FontWeight.w700),
                  ),
                  Text(
                    'Đăng nhập lần đầu để chọn vai trò và hoàn thiện hồ sơ của bạn.',
                    textAlign: TextAlign.center,
                    style: authText(14, color: EmeraldColors.textSecondary),
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: EmeraldColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Email đã được xác minh',
                        style: authText(11, color: EmeraldColors.primaryDark),
                      ),
                    ),
                  ),
                  Text(
                    m.email,
                    textAlign: TextAlign.center,
                    style: authText(
                      13,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                ]
              : [
                  const AuthIllustration(node: '585:4268'),
                  Text(
                    'Mở hộp thư nhé.',
                    textAlign: TextAlign.left,
                    style: authText(25, weight: FontWeight.w700),
                  ),
                  Text(
                    'Nhập mã 6 chữ số được gửi đến',
                    textAlign: TextAlign.left,
                    style: authText(14, color: EmeraldColors.textSecondary),
                  ),
                  Text(
                    m.email,
                    textAlign: TextAlign.left,
                    style: authText(
                      13,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < 6; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: TextField(
                              key: ValueKey('otp-$i'),
                              controller: _digits[i],
                              focusNode: _focus[i],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              autofillHints: i == 0
                                  ? const [AutofillHints.oneTimeCode]
                                  : null,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              onChanged: (value) => _changed(i, value),
                              style: authText(21, weight: FontWeight.w700),
                              decoration: InputDecoration(
                                semanticCounterText: 'Chữ số ${i + 1}',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: ProfileTokens.border,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (m.error case final String message)
                    AuthFeedback(message: message),
                  SizedBox(
                    height: 44,
                    child: TextButton(
                      onPressed: m.busy ? null : m.resend,
                      child: Text(
                        m.resendLabel,
                        style: authText(
                          13,
                          weight: FontWeight.w500,
                          color: EmeraldColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  AuthAction(
                    label: 'Thay đổi email',
                    outlined: true,
                    onPressed: widget.onBack,
                  ),
                  Text(
                    'Mã có hiệu lực trong 5 phút. Kiểm tra thêm thư mục spam nếu cần.',
                    style: authText(11, color: EmeraldColors.textSecondary),
                  ),
                ],
        ),
      );
    },
  );
}
