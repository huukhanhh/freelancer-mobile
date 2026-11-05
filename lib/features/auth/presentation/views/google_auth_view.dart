import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';

class GoogleAuthView extends StatelessWidget {
  const GoogleAuthView({
    required this.model,
    required this.onBack,
    required this.onComplete,
    super.key,
  });
  final AuthFlowViewModel model;
  final VoidCallback onBack, onComplete;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => AuthPage(
      title: 'Tiếp tục với Google',
      onBack: onBack,
      action: AuthAction(
        label: 'Tiếp tục với Minh Anh',
        busy: model.busy,
        onPressed: () async {
          if (await model.google()) onComplete();
        },
      ),
      child: AuthScrollBody(
        children: [
          SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FigmaAsset(
                  '585:4357',
                  'imgRectangle',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                const FigmaAsset('585:4357', 'imgFrame', width: 20, height: 20),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: EmeraldColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const FigmaAsset(
                    '585:4357',
                    'imgFrame1',
                    width: 31.5,
                    height: 31.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Chọn tài khoản để tiếp tục',
            style: authText(21, weight: FontWeight.w700),
          ),
          Text(
            'Kết nối tài khoản Google với Workly.',
            style: authText(14, color: EmeraldColors.textSecondary),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ProfileTokens.border),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  const FigmaAsset(
                    '585:4357',
                    'imgEllipse',
                    width: 44,
                    height: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Minh Anh Demo',
                          style: authText(13, weight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'minhanh@workly.example',
                          style: authText(
                            11,
                            color: EmeraldColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EmeraldColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FigmaAsset(
                  '585:4357',
                  'imgProfileIconCheck',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Google chia sẻ tên, email và ảnh đại diện để tạo hoặc kết nối tài khoản.',
                    style: authText(
                      13,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AuthAction(
            label: 'Sử dụng email khác',
            outlined: true,
            onPressed: onBack,
          ),
          Text(
            'Đăng nhập lần đầu sẽ tiếp tục đến bước chọn vai trò và thiết lập hồ sơ.',
            style: authText(11, color: EmeraldColors.textSecondary),
          ),
          if (model.error case final String message)
            AuthFeedback(message: message),
        ],
      ),
    ),
  );
}
