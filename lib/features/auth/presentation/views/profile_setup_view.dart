import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/views/role_selection_view.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/session/domain/account_setup_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({
    required this.model,
    required this.role,
    required this.onBack,
    required this.onComplete,
    super.key,
  });
  final AuthFlowViewModel model;
  final UserRole role;
  final VoidCallback onBack, onComplete;
  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: widget.model.session.session?.displayName ?? '',
  );
  final _specialty = TextEditingController(text: 'Thiết kế UI/UX'),
      _company = TextEditingController(),
      _website = TextEditingController();
  final _technologies = <String>{};
  bool _business = false, _logo = false, _other = false;
  static const _tech = [
    ('Figma', 'Figma'),
    ('React', 'React'),
    ('Java', 'Java'),
    ('PHP', 'Php'),
    ('Flutter', 'Flutter'),
    ('JavaScript', 'Javascript'),
  ];
  @override
  void dispose() {
    for (final c in [_name, _specialty, _company, _website]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      (value ?? '').trim().isEmpty ? 'Vui lòng nhập thông tin.' : null;
  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await widget.model.complete(
      ProfileSetup(
        role: widget.role,
        displayName: _name.text.trim(),
        specialty: widget.role == UserRole.freelancer
            ? _specialty.text.trim()
            : '',
        technologies: _technologies,
        companyName: _business ? _company.text.trim() : null,
        companyWebsite: _business ? _website.text.trim() : null,
        logoUploaded: _business && _logo,
      ),
    );
    if (mounted && ok) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) {
      final client = widget.role == UserRole.client;
      return AuthPage(
        title: client ? 'Hồ sơ Client' : 'Hồ sơ Freelancer',
        onBack: widget.onBack,
        action: AuthAction(
          label: client ? 'Hoàn tất & khám phá' : 'Hoàn tất hồ sơ',
          busy: widget.model.busy,
          onPressed: _submit,
        ),
        child: Form(
          key: _form,
          child: AuthScrollBody(
            children: [
              const SetupProgress(step: 2),
              Text(
                client ? 'Sẵn sàng tìm cộng sự' : 'Giới thiệu tài năng của bạn',
                style: authText(21, weight: FontWeight.w700),
              ),
              if (!client)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ProfileTokens.border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Row(
                      children: [
                        const FigmaAsset(
                          '585:4234',
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
                                widget.model.session.session?.displayName ??
                                    'Minh Anh Demo',
                                style: authText(13, weight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ảnh cá nhân · ${widget.model.email}',
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
              AuthField(
                label: 'Họ và tên',
                controller: _name,
                validator: _required,
              ),
              if (client) ...[
                Text(
                  'Bạn hoạt động với tư cách nào?',
                  style: authText(13, weight: FontWeight.w500),
                ),
                _ActivityOption(
                  business: false,
                  selected: !_business,
                  onTap: () => setState(() => _business = false),
                ),
                _ActivityOption(
                  business: true,
                  selected: _business,
                  onTap: () => setState(() => _business = true),
                ),
                if (_business) ...[
                  AuthField(
                    label: 'Tên doanh nghiệp',
                    controller: _company,
                    validator: _required,
                  ),
                  AuthField(
                    label: 'Website doanh nghiệp',
                    controller: _website,
                    keyboardType: TextInputType.url,
                    validator: (s) {
                      if ((s ?? '').trim().isEmpty) return null;
                      final uri = Uri.tryParse(s!.trim());
                      return uri != null &&
                              ['https', 'http'].contains(uri.scheme) &&
                              uri.host.isNotEmpty
                          ? null
                          : 'Vui lòng nhập địa chỉ website hợp lệ.';
                    },
                  ),
                  _LogoOption(
                    uploaded: _logo,
                    onTap: () => setState(() => _logo = !_logo),
                  ),
                ],
                Text(
                  'Chọn hoạt động độc lập? Bạn có thể liên kết doanh nghiệp sau trong Hồ sơ.',
                  style: authText(11, color: EmeraldColors.textSecondary),
                ),
              ] else ...[
                AuthField(
                  label: 'Chuyên môn của bạn',
                  controller: _specialty,
                  validator: _required,
                ),
                Text(
                  'Công nghệ bạn thường dùng',
                  style: authText(13, weight: FontWeight.w500),
                ),
                for (var row = 0; row < 3; row++)
                  Row(
                    children: [
                      for (var col = 0; col < 2; col++) ...[
                        if (col > 0) const SizedBox(width: 8),
                        Expanded(
                          child: _TechnologyOption(
                            label: _tech[row * 2 + col].$1,
                            slot:
                                'imgProfileTechnology${_tech[row * 2 + col].$2}',
                            selected: _technologies.contains(
                              _tech[row * 2 + col].$1,
                            ),
                            onTap: () => setState(() {
                              _other = false;
                              final label = _tech[row * 2 + col].$1;
                              if (!_technologies.remove(label)) {
                                _technologies.add(label);
                              }
                            }),
                          ),
                        ),
                      ],
                    ],
                  ),
                _TechnologyOption(
                  label: 'Khác · Cập nhật sau',
                  slot: 'imgMessagingIconMore',
                  selected: _other,
                  height: 44,
                  onTap: () => setState(() {
                    _other = true;
                    _technologies.clear();
                  }),
                ),
              ],
              if (widget.model.error case final String message)
                AuthFeedback(message: message),
            ],
          ),
        ),
      );
    },
  );
}

class _ActivityOption extends StatelessWidget {
  const _ActivityOption({
    required this.business,
    required this.selected,
    required this.onTap,
  });
  final bool business, selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: Material(
      color: selected ? EmeraldColors.surfaceSubtle : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ProfileTokens.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                FigmaAsset(
                  '876:6976',
                  business
                      ? 'imgProfileIconLayers'
                      : 'imgEmerald2026NavigationIconProfile',
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business
                            ? 'Đại diện doanh nghiệp'
                            : 'Hoạt động độc lập',
                        style: authText(13, weight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        business
                            ? 'Bổ sung tên, logo và thông tin công ty'
                            : 'Dùng hồ sơ cá nhân để đăng dự án',
                        style: authText(11, color: EmeraldColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _TechnologyOption extends StatelessWidget {
  const _TechnologyOption({
    required this.label,
    required this.slot,
    required this.selected,
    required this.onTap,
    this.height = 40,
  });
  final String label, slot;
  final bool selected;
  final VoidCallback onTap;
  final double height;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: Material(
      color: selected ? EmeraldColors.surfaceSubtle : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ProfileTokens.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              children: [
                if (slot == 'imgProfileTechnologyReact')
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24 * .0109,
                        vertical: 24 * .0633,
                      ),
                      child: FigmaAsset('670:4711', 'imgGroup'),
                    ),
                  )
                else
                  FigmaAsset('585:4234', slot, width: 24, height: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: authText(13, weight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _LogoOption extends StatelessWidget {
  const _LogoOption({required this.uploaded, required this.onTap});
  final bool uploaded;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: ProfileTokens.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: EmeraldColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const FigmaAsset(
                '879:7399',
                'imgFrame',
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
                    'Logo doanh nghiệp',
                    style: authText(13, weight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    uploaded ? 'Đã thêm ảnh demo' : 'Thêm ảnh · Không bắt buộc',
                    style: authText(11, color: EmeraldColors.textSecondary),
                  ),
                ],
              ),
            ),
            const FigmaAsset(
              '879:7399',
              'imgProfileIconPlus',
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    ),
  );
}
