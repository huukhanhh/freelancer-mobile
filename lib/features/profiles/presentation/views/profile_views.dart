import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/core/widgets/role_bottom_bar.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/profiles/domain/profile_repository.dart';
import 'package:workly/features/profiles/presentation/view_models/profile_view_model.dart';

class FreelancerProfileView extends StatelessWidget {
  const FreelancerProfileView({
    required this.model,
    required this.onEdit,
    required this.onSkills,
    required this.onPortfolio,
    required this.onTab,
    required this.onShortcut,
    super.key,
  });
  final ProfileViewModel model;
  final VoidCallback onEdit, onSkills, onPortfolio;
  final ValueChanged<int> onTab;
  final ValueChanged<String> onShortcut;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final p = model.profile;
      if (p == null) return const SizedBox.shrink();
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: EmeraldColors.background,
          body: Column(
            children: [
              SizedBox(
                height: math.max(59, MediaQuery.viewPaddingOf(context).top),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 330,
                      child: Stack(
                        children: [
                          const Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 152,
                            child: FigmaAsset(
                              '585:5316',
                              'imgCoverPhotograph',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 24,
                            child: Text(
                              'Hồ sơ của tôi',
                              style: authText(
                                18,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 16,
                            width: 104,
                            child: ProjectAction(
                              label: 'Chỉnh sửa',
                              onPressed: onEdit,
                              outline: true,
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            top: 110,
                            child: ProfileIdentity(p),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _gaps([
                          _section(
                            'Kỹ năng nổi bật',
                            action: 'Chỉnh sửa',
                            onTap: onSkills,
                          ),
                          if (p.technologies.isEmpty)
                            ProjectCard(
                              children: [
                                Text(
                                  'Chưa cập nhật công nghệ',
                                  style: authText(13, weight: FontWeight.w500),
                                ),
                                Text(
                                  'Bổ sung khi bạn sẵn sàng.',
                                  style: authText(
                                    14,
                                    color: EmeraldColors.textSecondary,
                                  ),
                                ),
                                ProjectAction(
                                  label: 'Cập nhật công nghệ',
                                  onPressed: onSkills,
                                  outline: true,
                                ),
                              ],
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final t in p.technologies) _skill(t),
                              ],
                            ),
                          _section(
                            'Portfolio',
                            action: 'Xem tất cả',
                            onTap: onPortfolio,
                          ),
                          for (final e in p.portfolio)
                            ProfilePortfolioCard(e, source: '585:5316'),
                          _section('Giới thiệu'),
                          Text(
                            p.bio,
                            style: authText(
                              14,
                              color: EmeraldColors.textSecondary,
                            ),
                          ),
                          ProjectCard(
                            children: [
                              Text(
                                'Không gian làm việc',
                                style: authText(18, weight: FontWeight.w700),
                              ),
                              for (final entry in [
                                ('Đề xuất của tôi', 'proposals'),
                                ('Lời mời ứng tuyển', 'invitations'),
                                ('Offer từ Client', 'offers'),
                                ('Dự án đã lưu', 'saved'),
                                ('Ví & thu nhập', 'wallet'),
                                ('Cài đặt & hỗ trợ', 'settings'),
                              ])
                                ProjectAction(
                                  label: entry.$1,
                                  onPressed:
                                      ['proposals', 'saved'].contains(entry.$2)
                                      ? () => onShortcut(entry.$2)
                                      : null,
                                  outline: true,
                                ),
                            ],
                          ),
                        ], 16),
                      ),
                    ),
                  ],
                ),
              ),
              RoleBottomBar(
                client: false,
                node: '585:5316',
                preview: AuthDesignPreview.of(context),
                selectedIndex: 4,
                enabledIndices: const {0, 1, 4},
                onTab: onTab,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity(this.profile, {super.key});
  final FreelancerProfile profile;
  @override
  Widget build(BuildContext context) => ProjectCard(
    children: [
      Row(
        children: [
          const FigmaAsset(
            '585:5316',
            'imgPortraitPhotograph',
            width: 64,
            height: 64,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: authText(
                    22,
                    weight: FontWeight.w700,
                  ).copyWith(height: 28 / 22),
                ),
                Text(
                  profile.title,
                  style: authText(
                    13,
                    weight: FontWeight.w500,
                    color: EmeraldColors.textSecondary,
                  ),
                ),
                Text(
                  '${profile.location} · 3 năm kinh nghiệm',
                  style: authText(11, color: EmeraldColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Đang nhận việc',
            style: authText(11, color: EmeraldColors.primaryDark),
          ),
          Expanded(
            child: Text(
              '${profile.rate}đ/giờ',
              textAlign: TextAlign.right,
              style: authText(
                13,
                weight: FontWeight.w500,
                color: EmeraldColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: EmeraldColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            for (final stat in [
              ('24', 'Dự án'),
              ('4,9', '12 đánh giá'),
              ('98%', 'Hoàn tất'),
            ])
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat.$1,
                      style: authText(
                        18,
                        weight: FontWeight.w700,
                        color: EmeraldColors.primaryDark,
                      ),
                    ),
                    Text(
                      stat.$2,
                      style: authText(11, color: EmeraldColors.textSecondary),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

class PortfolioListView extends StatelessWidget {
  const PortfolioListView({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onPreview,
    required this.onEdit,
    super.key,
  });
  final ProfileViewModel model;
  final VoidCallback onBack, onHome, onPreview;
  final ValueChanged<String?> onEdit;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => ProjectPage(
      title: 'Portfolio của tôi',
      contextHeader: true,
      onBack: onBack,
      onHome: onHome,
      action: ProjectAction(
        label: '＋ Thêm dự án Portfolio',
        onPressed: () => onEdit(null),
      ),
      child: _scroll([
        Text(
          'Những dự án đã làm',
          style: authText(21, weight: FontWeight.w700),
        ),
        Text(
          '${model.profile?.portfolio.length ?? 0} dự án · UI/UX & Mobile App',
          style: authText(14, color: EmeraldColors.textSecondary),
        ),
        for (final e in model.profile?.portfolio ?? <PortfolioEntry>[])
          ProfilePortfolioCard(
            e,
            onPreview: onPreview,
            onEdit: () => onEdit(e.id),
          ),
        Text(
          'Chọn dự án để xem chi tiết hoặc cập nhật case study.',
          style: authText(11, color: EmeraldColors.textSecondary),
        ),
      ]),
    ),
  );
}

class ProfilePortfolioCard extends StatelessWidget {
  const ProfilePortfolioCard(
    this.entry, {
    this.onPreview,
    this.onEdit,
    this.source,
    super.key,
  });
  final PortfolioEntry entry;
  final VoidCallback? onPreview, onEdit;
  final String? source;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: ProfileTokens.border),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FigmaAsset(
          source != null && entry.node == '585:5527' ? source! : entry.node,
          entry.slot,
          height: 164,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _gaps([
              Text(entry.title, style: authText(18, weight: FontWeight.w700)),
              Text(
                entry.metadata,
                style: authText(11, color: EmeraldColors.textSecondary),
              ),
              Row(
                children: [
                  const FigmaAsset(
                    '585:5527',
                    'imgProfileTechnologyFigma',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Figma · Mobile app',
                    style: authText(11, color: EmeraldColors.textSecondary),
                  ),
                ],
              ),
              if (onPreview != null || onEdit != null)
                Row(
                  children: [
                    Expanded(
                      child: ProjectAction(
                        label: 'Xem hồ sơ',
                        onPressed: onPreview,
                        outline: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ProjectAction(
                        label: 'Chỉnh sửa',
                        onPressed: onEdit,
                        outline: true,
                      ),
                    ),
                  ],
                ),
            ], 8),
          ),
        ),
      ],
    ),
  );
}

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onSave,
    required this.onSkills,
    required this.onPreview,
    super.key,
  });
  final ProfileViewModel model;
  final VoidCallback onBack, onHome, onSave, onSkills, onPreview;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      if (model.profile == null) return const SizedBox.shrink();
      return ProjectPage(
        title: 'Chỉnh sửa hồ sơ',
        contextHeader: true,
        onBack: onBack,
        onHome: onHome,
        action: ProjectAction(
          label: '✓ Lưu thay đổi',
          onPressed: () async {
            await model.save();
            if (context.mounted) onSave();
          },
        ),
        child: _scroll([
          Text(
            'Dấu ấn chuyên môn',
            style: authText(21, weight: FontWeight.w700),
          ),
          Text(
            'Cập nhật hình ảnh và thông tin để Client hiểu rõ bạn.',
            style: authText(14, color: EmeraldColors.textSecondary),
          ),
          ProjectCard(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const FigmaAsset(
                  '585:5411',
                  'imgCoverPreview',
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  const FigmaAsset(
                    '585:5411',
                    'imgPortraitPhotograph',
                    width: 56,
                    height: 56,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ảnh đại diện', style: authText(13)),
                        const SizedBox(height: 8),
                        Text(
                          'JPG hoặc PNG',
                          style: authText(
                            11,
                            color: EmeraldColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 98,
                    child: ProjectAction(
                      label: 'Thay ảnh',
                      onPressed: null,
                      outline: true,
                    ),
                  ),
                ],
              ),
              const ProjectAction(
                label: 'Thay ảnh bìa',
                onPressed: null,
                outline: true,
              ),
            ],
          ),
          _field(model, 'title', 'Tiêu đề chuyên môn'),
          _field(model, 'bio', 'Giới thiệu bản thân', lines: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _field(model, 'rate', 'Đơn giá theo giờ')),
              const SizedBox(width: 12),
              Expanded(child: _field(model, 'location', 'Địa điểm')),
            ],
          ),
          Text(
            'Đơn giá hiển thị: ${model.fields['rate']}đ/giờ.',
            style: authText(11, color: EmeraldColors.textSecondary),
          ),
          ProjectAction(
            label: 'Kỹ năng & kinh nghiệm',
            onPressed: onSkills,
            outline: true,
          ),
          ProjectAction(
            label: 'Xem trước hồ sơ',
            onPressed: onPreview,
            outline: true,
          ),
        ]),
      );
    },
  );
}

class ProfileSkillsView extends StatelessWidget {
  const ProfileSkillsView({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onSave,
    super.key,
  });
  final ProfileViewModel model;
  final VoidCallback onBack, onHome, onSave;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => ProjectPage(
      title: 'Chỉnh sửa hồ sơ',
      onBack: onBack,
      onHome: onHome,
      action: ProjectAction(
        label: 'Lưu thay đổi',
        solid: true,
        onPressed: () async {
          await model.save();
          if (context.mounted) onSave();
        },
      ),
      child: _scroll([
        Text(
          'Công nghệ & kinh nghiệm',
          style: authText(21, weight: FontWeight.w700),
        ),
        Text(
          'Công nghệ bạn thường dùng',
          style: authText(13, weight: FontWeight.w500),
        ),
        Column(
          children: [
            for (var row = 0; row < 3; row++) ...[
              if (row > 0) const SizedBox(height: 8),
              Row(
                children: [
                  for (var col = 0; col < 2; col++) ...[
                    if (col > 0) const SizedBox(width: 8),
                    Expanded(
                      child: _technology(
                        model,
                        [
                          'Figma',
                          'React',
                          'Java',
                          'PHP',
                          'Flutter',
                          'JavaScript',
                        ][row * 2 + col],
                        [
                          'Figma',
                          'React',
                          'Java',
                          'Php',
                          'Flutter',
                          'Javascript',
                        ][row * 2 + col],
                      ),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 8),
            _technology(model, 'Khác · cập nhật sau', 'More', other: true),
          ],
        ),
        _section('Kinh nghiệm làm việc', action: '+ Thêm'),
        _field(model, 'company', 'Công ty / Studio'),
        _field(model, 'position', 'Vị trí'),
        Row(
          children: [
            Expanded(child: _field(model, 'fromYear', 'Từ năm')),
            const SizedBox(width: 12),
            Expanded(child: _field(model, 'toYear', 'Đến năm')),
          ],
        ),
        _field(model, 'workDescription', 'Mô tả công việc', lines: 3),
      ]),
    ),
  );
}

Widget _technology(
  ProfileViewModel model,
  String label,
  String slot, {
  bool other = false,
}) {
  final selected = model.technologies.contains(label);
  return Material(
    color: selected ? EmeraldColors.surfaceSubtle : Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: selected ? EmeraldColors.primary : ProfileTokens.border,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      onTap: () => model.toggle(label),
      child: SizedBox(
        height: other ? 44 : 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (slot == 'React')
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: .2616,
                      vertical: 1.5192,
                    ),
                    child: FigmaAsset('670:4711', 'imgGroup'),
                  ),
                )
              else
                FigmaAsset(
                  '585:5470',
                  other ? 'imgMessagingIconMore' : 'imgProfileTechnology$slot',
                  width: 24,
                  height: 24,
                ),
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
  );
}

class PortfolioEditView extends StatelessWidget {
  const PortfolioEditView({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onSaved,
    super.key,
  });
  final ProfileViewModel model;
  final VoidCallback onBack, onHome, onSaved;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final d = model.portfolioDraft;
      if (d == null) return const SizedBox.shrink();
      return ProjectPage(
        title: 'Chỉnh sửa Portfolio',
        contextHeader: true,
        onBack: onBack,
        onHome: onHome,
        action: ProjectAction(
          label: '✓ Lưu dự án',
          onPressed: () async {
            if (await model.savePortfolio() && context.mounted) onSaved();
          },
        ),
        child: _scroll([
          Text(
            'Kể câu chuyện dự án',
            style: authText(21, weight: FontWeight.w700),
          ),
          Text(
            'Nêu rõ vai trò, cách giải quyết và kết quả của bạn.',
            style: authText(14, color: EmeraldColors.textSecondary),
          ),
          ProjectCard(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FigmaAsset(
                  d.node,
                  d.slot,
                  height: 154,
                  fit: BoxFit.cover,
                ),
              ),
              ProjectAction(
                label: 'Thay ảnh bìa',
                onPressed: model.changeCover,
                outline: true,
              ),
              Row(
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 9),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FigmaAsset(
                          '585:5606',
                          [
                            'imgPortfolioCover',
                            'imgWorkspaceView',
                            'imgProcessView',
                          ][i],
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                'JPG, PNG · Tối đa 10 ảnh',
                style: authText(11, color: EmeraldColors.textSecondary),
              ),
            ],
          ),
          ProfileInput(
            label: 'Tên dự án',
            value: d.title,
            onChanged: (v) => model.changePortfolio(title: v),
          ),
          ProfileInput(
            label: 'Vai trò của bạn',
            value: d.role,
            onChanged: (v) => model.changePortfolio(role: v),
          ),
          ProfileInput(
            label: 'Mô tả dự án',
            value: d.description,
            onChanged: (v) => model.changePortfolio(description: v),
            lines: 4,
          ),
          _section('Công cụ & kỹ năng'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [_skill('Figma'), _skill('UI/UX'), _skill('Mobile UX')],
          ),
          ProfileInput(
            label: 'Liên kết dự án',
            value: d.link,
            onChanged: (v) => model.changePortfolio(link: v),
          ),
        ]),
      );
    },
  );
}

class ProfilePreviewView extends StatelessWidget {
  const ProfilePreviewView({
    required this.model,
    required this.onBack,
    required this.onHome,
    super.key,
  });
  final ProfileViewModel model;
  final VoidCallback onBack, onHome;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final p = model.profile;
      if (p == null) return const SizedBox.shrink();
      final preview = p.updated(model.fields, model.technologies);
      return ProjectPage(
        title: 'Xem trước hồ sơ',
        contextHeader: true,
        onBack: onBack,
        onHome: onHome,
        action: ProjectAction(label: '← Quay lại chỉnh sửa', onPressed: onBack),
        child: _scroll([
          Text(
            'Hồ sơ hiển thị với Client',
            style: authText(11, color: EmeraldColors.primaryDark),
          ),
          ProfileIdentity(preview),
          _section('Giới thiệu'),
          Text(preview.bio, style: authText(14)),
          _section('Portfolio'),
          for (final e in preview.portfolio)
            ProfilePortfolioCard(e, source: '585:5659'),
          ProjectCard(
            children: [
              Text(
                'Lê Thu Hà · 5,0 ★',
                style: authText(13, weight: FontWeight.w500),
              ),
              Text(
                '“Giao tiếp rõ ràng, chỉn chu và bàn giao đúng hẹn.”',
                style: authText(14),
              ),
              Text(
                'Nội dung đánh giá minh họa',
                style: authText(11, color: EmeraldColors.textSecondary),
              ),
            ],
          ),
        ]),
      );
    },
  );
}

class ProfileInput extends StatelessWidget {
  const ProfileInput({
    required this.label,
    required this.value,
    required this.onChanged,
    this.lines = 1,
    super.key,
  });
  final String label, value;
  final ValueChanged<String> onChanged;
  final int lines;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: authText(
          13,
          weight: FontWeight.w500,
          color: EmeraldColors.textSecondary,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: value,
        onChanged: onChanged,
        minLines: lines,
        maxLines: lines == 1 ? 1 : null,
        style: authText(14),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    ],
  );
}

Widget _field(ProfileViewModel m, String key, String label, {int lines = 1}) =>
    ProfileInput(
      key: ValueKey(key),
      label: label,
      value: m.fields[key] ?? '',
      onChanged: (v) => m.change(key, v),
      lines: lines,
    );
Widget _scroll(List<Widget> children) => ListView(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
  children: _gaps(children, 24),
);
List<Widget> _gaps(List<Widget> children, double gap) => [
  for (var i = 0; i < children.length; i++) ...[
    if (i > 0) SizedBox(height: gap),
    children[i],
  ],
];
Widget _section(String title, {String? action, VoidCallback? onTap}) => Row(
  children: [
    Expanded(
      child: Text(title, style: authText(18, weight: FontWeight.w700)),
    ),
    if (action != null)
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            action,
            style: authText(11, color: EmeraldColors.primaryDark),
          ),
        ),
      ),
  ],
);
Widget _skill(String label) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: ProfileTokens.border),
    borderRadius: BorderRadius.circular(19),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (['Figma', 'UI/UX', 'Mobile UX'].contains(label)) ...[
        FigmaAsset(
          '585:5606',
          label == 'Figma'
              ? 'imgProfileTechnologyFigma'
              : label == 'UI/UX'
              ? 'imgProfileIconLayers'
              : 'imgProfileIconMobile',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 6),
      ],
      Text(label, style: authText(11, weight: FontWeight.w500)),
    ],
  ),
);
