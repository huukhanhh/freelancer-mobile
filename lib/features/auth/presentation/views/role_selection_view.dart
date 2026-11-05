import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/session/domain/user_session.dart';

class SetupProgress extends StatelessWidget {
  const SetupProgress({required this.step, super.key});
  final int step;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 20,
        child: Row(
          children: [
            Expanded(
              child: Text(
                step == 1
                    ? 'BƯỚC 1 / 2 · CHỌN VAI TRÒ'
                    : 'BƯỚC 2 / 2 · THIẾT LẬP HỒ SƠ',
                style: authText(11, color: EmeraldColors.primaryDark),
              ),
            ),
            Text(
              step == 1 ? 'Bắt đầu' : 'Gần xong',
              style: authText(11, color: EmeraldColors.textSecondary),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: step == 1
                      ? (i == 0 ? AuthTokens.cyan : EmeraldColors.surfaceSubtle)
                      : (i == 0 ? EmeraldColors.primary : AuthTokens.cyan),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ],
      ),
    ],
  );
}

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({
    required this.model,
    required this.onBack,
    required this.onContinue,
    super.key,
  });
  final AuthFlowViewModel model;
  final VoidCallback onBack, onContinue;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => AuthPage(
      title: 'Chọn vai trò',
      onBack: onBack,
      action: AuthAction(
        label: model.selectedRole == null
            ? 'Chọn vai trò để tiếp tục'
            : 'Tiếp tục',
        onPressed: model.selectedRole == null ? null : onContinue,
      ),
      child: AuthScrollBody(
        children: [
          const SetupProgress(step: 1),
          Text(
            'Bắt đầu theo cách của bạn.',
            style: authText(21, weight: FontWeight.w700),
          ),
          Text(
            'Chọn vai trò để Workly thiết lập trải nghiệm phù hợp.',
            style: authText(14, color: EmeraldColors.textSecondary),
          ),
          _RoleCard(
            role: UserRole.freelancer,
            selected: model.selectedRole == UserRole.freelancer,
            title: 'Tôi là Freelancer',
            subtitle: 'Nhận dự án và phát triển kỹ năng',
            description:
                'Tìm công việc phù hợp, hợp tác và xây dựng hồ sơ của bạn.',
            onTap: () => model.selectRole(UserRole.freelancer),
          ),
          _RoleCard(
            role: UserRole.client,
            selected: model.selectedRole == UserRole.client,
            title: 'Tôi là Client',
            subtitle: 'Tìm người phù hợp cho dự án',
            description:
                'Đăng dự án, chọn Freelancer và quản lý hợp tác của bạn.',
            onTap: () => model.selectRole(UserRole.client),
          ),
          Text(
            'Bạn có thể chỉnh sửa thông tin hồ sơ sau khi hoàn tất.',
            style: authText(11, color: EmeraldColors.textSecondary),
          ),
        ],
      ),
    ),
  );
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onTap,
  });
  final UserRole role;
  final bool selected;
  final String title, subtitle, description;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: ProfileTokens.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: EmeraldColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FigmaAsset(
                      '585:4161',
                      role == UserRole.freelancer ? 'imgFrame1' : 'imgFrame',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: authText(18, weight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: authText(
                            11,
                            color: EmeraldColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ProfileTokens.border),
                    ),
                    child: selected
                        ? const FigmaAsset(
                            '585:4161',
                            'imgRoleSelectedMarker',
                            width: 24,
                            height: 24,
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: authText(14, color: EmeraldColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
