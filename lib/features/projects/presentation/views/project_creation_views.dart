import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/core/widgets/role_bottom_bar.dart';
import 'package:workly/core/widgets/workly_button.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/discovery/presentation/widgets/discovery_components.dart';
import 'package:workly/features/profiles/presentation/views/profile_views.dart'
    show ProfileInput;
import 'package:workly/features/projects/domain/project_repository.dart';
import 'package:workly/features/projects/presentation/view_models/projects_view_model.dart';
import 'package:workly/features/proposals/presentation/views/proposal_flow_view.dart'
    show ProposalProjectSummary;

enum ProjectCreationStage {
  basic,
  description,
  budget,
  roles,
  attachments,
  preview,
  success,
}

class ProjectEntryView extends StatelessWidget {
  const ProjectEntryView({
    required this.onHome,
    required this.onCreate,
    super.key,
  });
  final VoidCallback onHome;
  final ValueChanged<String?> onCreate;
  @override
  Widget build(BuildContext context) => DiscoveryScaffold(
    node: '585:5031',
    title: 'Đăng việc tìm freelancer',
    subtitle: 'Lựa chọn nhanh theo nhu cầu',
    onBack: onHome,
    onHome: onHome,
    showBottomBar: false,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(18, 21, 18, 20),
      children: [
        SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: LayoutBuilder(
              builder: (context, box) => Stack(
                children: [
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            EmeraldColors.deep,
                            EmeraldColors.emerald600,
                            Color(0xFF34D399),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: box.maxWidth * .5,
                    right: 8,
                    top: 8,
                    bottom: 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: const FigmaAsset(
                        '585:5031',
                        'imgEditorialRealPhotography',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: box.maxWidth * .528,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            EmeraldColors.deep,
                            EmeraldColors.primaryDark,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 24,
                    child: Text(
                      'BẮT ĐẦU TỪ Ý TƯỞNG',
                      style: discoveryText(
                        11,
                        weight: FontWeight.w700,
                        color: const Color(0xFFD1FAE5),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 61,
                    width: box.maxWidth * .47,
                    child: Text(
                      'Đăng việc\nchỉ 2 phút',
                      style: discoveryText(
                        23,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 141,
                    width: box.maxWidth * .47,
                    child: Text(
                      'Nhận đề xuất phù hợp\ntừ freelancer uy tín.',
                      style: discoveryText(12, color: const Color(0xFFE1FFF1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 31),
        Text(
          'Bạn cần tìm ai?',
          style: discoveryText(19, weight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        for (var row = 0; row < 2; row++) ...[
          if (row > 0) const SizedBox(height: 14),
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                if (col > 0) const SizedBox(width: 9),
                Expanded(
                  child: _ServiceCategory(
                    index: row * 2 + col,
                    onTap: () => onCreate(
                      row == 0 && col == 0 ? 'Thiết kế' : 'Lập trình',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
        const SizedBox(height: 52),
        WorklyButton(
          label: '＋  Tạo dự án mới',
          onPressed: () => onCreate(null),
          style: WorklyButtonStyle.warm,
          height: 60,
          labelSize: 16,
        ),
        const SizedBox(height: 24),
        Text(
          'Đã có tài khoản? Dự án được lưu tự động.',
          textAlign: TextAlign.center,
          style: discoveryText(11, color: DiscoveryColors.muted),
        ),
      ],
    ),
  );
}

class _ServiceCategory extends StatelessWidget {
  const _ServiceCategory({required this.index, required this.onTap});
  final int index;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 3,
    shadowColor: EmeraldColors.deep.withValues(alpha: .11),
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 95,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 14, 4, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: [
                    const Color(0xFFEAFBF3),
                    const Color(0xFFE6F3FF),
                    const Color(0xFFF0EDFF),
                    const Color(0xFFFFF3E8),
                  ][index],
                  borderRadius: BorderRadius.circular(13),
                ),
                child: FigmaAsset(
                  '585:5031',
                  [
                    'imgIconThitKuiux',
                    'imgIconLpTrinhWeb',
                    'imgIconngDngMobile',
                    'imgIconMarketingSeo',
                  ][index],
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                [
                  'Thiết kế UI/UX',
                  'Lập trình Web',
                  'Ứng dụng Mobile',
                  'Marketing / SEO',
                ][index],
                style: discoveryText(12, weight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ClientProjectsListView extends StatelessWidget {
  const ClientProjectsListView({
    required this.model,
    required this.onCreate,
    required this.onOpen,
    required this.onTab,
    super.key,
  });
  final ProjectsViewModel model;
  final VoidCallback onCreate;
  final ValueChanged<String> onOpen;
  final ValueChanged<int> onTab;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => Scaffold(
      backgroundColor: EmeraldColors.background,
      body: Column(
        children: [
          SizedBox(height: math.max(59, MediaQuery.viewPaddingOf(context).top)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: _gaps([
                Text(
                  'Quản lý dự án',
                  style: authText(21, weight: FontWeight.w700),
                ),
                Text(
                  'Theo dõi tuyển dụng và các đề xuất tại một nơi.',
                  style: authText(14, color: EmeraldColors.textSecondary),
                ),
                ProjectAction(label: 'Đăng dự án mới', onPressed: onCreate),
                Row(
                  children: [
                    for (final state in [
                      'Đang tuyển',
                      'Đang thực hiện',
                      'Hoàn tất',
                    ])
                      Expanded(
                        child: InkWell(
                          onTap: () => model.selectStatus(state),
                          child: Container(
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: model.projectStatus == state
                                  ? EmeraldColors.surfaceSubtle
                                  : null,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              state == 'Đang tuyển'
                                  ? '$state · ${model.owned.length}'
                                  : state,
                              style: authText(
                                11,
                                color: model.projectStatus == state
                                    ? EmeraldColors.primaryDark
                                    : EmeraldColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (model.projectStatus == 'Đang tuyển')
                  for (final p in model.owned)
                    ProposalProjectSummary(
                      project: p,
                      node: '585:5813',
                      slot: 'imgProjectCoverThumbnail',
                      budget: p.budget,
                      days: p.days,
                      action: ProjectAction(
                        label: 'Quản lý dự án',
                        onPressed: () => onOpen(p.id),
                        outline: true,
                      ),
                    ),
                const ProjectNotice(
                  'Xem hồ sơ và so sánh đề xuất trước khi chọn freelancer phù hợp.',
                  heading: 'Quản lý đề xuất',
                  check: false,
                ),
              ], 20),
            ),
          ),
          RoleBottomBar(
            client: true,
            node: '585:5813',
            preview: AuthDesignPreview.of(context),
            selectedIndex: 1,
            enabledIndices: const {0, 1, 2},
            onTab: onTab,
          ),
        ],
      ),
    ),
  );
}

class ProjectCreationView extends StatelessWidget {
  const ProjectCreationView({
    required this.model,
    required this.stage,
    required this.onBack,
    required this.onHome,
    required this.onNext,
    required this.onEdit,
    required this.onMine,
    super.key,
  });
  final ProjectsViewModel model;
  final ProjectCreationStage stage;
  final VoidCallback onBack, onHome, onNext, onMine;
  final ValueChanged<ProjectCreationStage> onEdit;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final d = model.draft;
      if (d == null) return const SizedBox.shrink();
      final title = stage == ProjectCreationStage.roles
          ? 'Nhu cầu tuyển dụng'
          : stage == ProjectCreationStage.preview
          ? 'Xem trước dự án'
          : stage == ProjectCreationStage.success
          ? 'Dự án của tôi'
          : 'Đăng dự án';
      final label = switch (stage) {
        ProjectCreationStage.budget => 'Chọn nhu cầu tuyển',
        ProjectCreationStage.roles => 'Lưu nhu cầu tuyển',
        ProjectCreationStage.attachments => 'Xem trước dự án',
        ProjectCreationStage.preview => 'Đăng dự án',
        ProjectCreationStage.success => 'Quản lý dự án',
        _ => 'Tiếp tục',
      };
      return ProjectPage(
        title: title,
        contextHeader: stage != ProjectCreationStage.roles,
        onBack: onBack,
        onHome: onHome,
        action: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (model.error != null) ...[
              Text(
                model.error!,
                style: authText(12, color: const Color(0xFFBA1A1A)),
              ),
              const SizedBox(height: 8),
            ],
            ProjectAction(
              label: label,
              solid: stage == ProjectCreationStage.roles,
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (model.validate()) onNext();
              },
            ),
          ],
        ),
        child: ListView(
          key: PageStorageKey(stage),
          padding: EdgeInsets.fromLTRB(
            20,
            stage == ProjectCreationStage.roles ? 16 : 20,
            20,
            28,
          ),
          children: _gaps([
            if (stage.index < 5) ProjectCreationStepper(stage.index + 1),
            ...switch (stage) {
              ProjectCreationStage.basic => _basic(d),
              ProjectCreationStage.description => _description(d),
              ProjectCreationStage.budget => _budget(d),
              ProjectCreationStage.roles => _roles(context, d),
              ProjectCreationStage.attachments => _attachments(d),
              ProjectCreationStage.preview => _preview(d),
              ProjectCreationStage.success => _success(d),
            },
          ], stage == ProjectCreationStage.roles ? 16 : 20),
        ),
      );
    },
  );
  List<Widget> _basic(ProjectDraft d) => [
    _heading('Bạn cần làm dự án gì?'),
    _body('Bắt đầu với tên dự án và chuyên môn bạn cần.'),
    _field(d, 'title', 'Tên dự án *'),
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ảnh đại diện dự án',
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ProjectCard(
          children: [
            if (d.cover) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const FigmaAsset(
                  '692:5436',
                  'imgSelectedProjectCover169',
                  height: 179,
                  fit: BoxFit.cover,
                ),
              ),
              _caption('Ảnh đại diện đã chọn'),
              Row(
                children: [
                  Expanded(
                    child: ProjectAction(
                      label: 'Thay ảnh',
                      outline: true,
                      onPressed: () => model.cover(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProjectAction(
                      label: 'Xóa ảnh',
                      outline: true,
                      onPressed: () => model.cover(false),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  const FigmaAsset(
                    '585:5899',
                    'imgProfileIconImage',
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Thêm ảnh giới thiệu dự án',
                      style: authText(
                        13,
                        weight: FontWeight.w500,
                        color: EmeraldColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              ProjectAction(
                label: 'Chọn ảnh',
                outline: true,
                onPressed: () => model.cover(true),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _caption(
          'Hiển thị trên thẻ và trang chi tiết dự án.\nJPG, PNG, WEBP · Tối đa 5 MB · Gợi ý 16:9',
        ),
      ],
    ),
    _heading('Chuyên môn', size: 18),
    Row(
      children: [
        for (final category in ['Thiết kế', 'Lập trình']) ...[
          if (category == 'Lập trình') const SizedBox(width: 12),
          Expanded(
            child: Material(
              color: d.category == category
                  ? EmeraldColors.surfaceSubtle
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: d.category == category
                      ? EmeraldColors.primaryDark
                      : ProfileTokens.border,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () => model.category(category),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category == 'Thiết kế')
                        const FigmaAsset(
                          '585:5899',
                          'imgProfileIconLayers',
                          width: 28,
                          height: 28,
                        )
                      else
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: .3052,
                              vertical: 1.7724,
                            ),
                            child: FigmaAsset('585:5899', 'imgGroup'),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        category,
                        style: authText(
                          13,
                          weight: FontWeight.w500,
                          color: d.category == category
                              ? EmeraldColors.primaryDark
                              : EmeraldColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _caption(
                        category == 'Thiết kế'
                            ? 'UI/UX · Thương hiệu'
                            : 'Web · Mobile App',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
    _field(d, 'summary', 'Mô tả ngắn', lines: 3),
  ];
  List<Widget> _description(ProjectDraft d) => [
    _heading('Mô tả & kỹ năng'),
    _body('Cho freelancer biết phạm vi và kết quả bạn mong đợi.'),
    _field(d, 'description', 'Mô tả công việc *', lines: 5),
    _heading('Kỹ năng yêu cầu', size: 18),
    _skills(d),
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thêm kỹ năng',
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onFieldSubmitted: model.addSkill,
          style: authText(14),
          decoration: InputDecoration(
            hintText: 'Tìm kỹ năng hoặc công nghệ…',
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    ),
    _caption('Đã chọn ${d.skills.length}/8 kỹ năng · ${d.skills.join(', ')}'),
    _field(d, 'deliverables', 'Sản phẩm bàn giao *', lines: 3),
    _field(d, 'priority', 'Ghi chú ưu tiên', lines: 3),
  ];
  List<Widget> _budget(ProjectDraft d) => [
    _heading('Ngân sách & thời hạn'),
    _body('Đặt kỳ vọng rõ ràng để nhận báo giá phù hợp.'),
    _field(d, 'billing', 'Hình thức thanh toán *'),
    _field(d, 'budget', 'Tổng ngân sách dự án (VNĐ) *'),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _field(d, 'start', 'Ngày bắt đầu *')),
        const SizedBox(width: 12),
        Expanded(child: _field(d, 'end', 'Ngày kết thúc *')),
      ],
    ),
    ProjectNotice(
      'Bạn có thể điều chỉnh mốc công việc khi thống nhất hợp đồng.',
      heading: 'Thời gian thực hiện · ${d.days} ngày',
      check: false,
    ),
    const ProjectNotice(
      'Tiếp theo, chọn số người và ngân sách cho từng vai trò. Mỗi người có một hợp đồng riêng.',
      heading: 'Phân bổ theo vai trò',
      check: false,
    ),
    _caption(
      'Tiền được ký quỹ theo hợp đồng và giải ngân khi sản phẩm được nghiệm thu.',
    ),
  ];
  List<Widget> _roles(BuildContext context, ProjectDraft d) => [
    _heading('Tuyển đúng người, rõ phạm vi'),
    _body('P-DEMO · Tổng ngân sách ${formatDong(d.budget)}'),
    for (var i = 0; i < d.roles.length; i++)
      ProjectCard(
        children: [
          _heading(d.roles[i].title, size: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ProfileInput(
                  label: 'Số người',
                  value: d.roles[i].count,
                  onChanged: (v) => model.roleChange(i, count: v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: ProfileInput(
                  label: 'Ngân sách / người',
                  value: d.roles[i].price,
                  onChanged: (v) => model.roleChange(i, price: v),
                ),
              ),
            ],
          ),
          _caption(d.roles[i].scope),
          if (i >= 3)
            ProjectAction(
              label: 'Xóa vị trí bổ sung',
              onPressed: () => model.removeRole(i),
              outline: true,
            ),
        ],
      ),
    ProjectAction(
      label: '+ Thêm vai trò',
      onPressed: () => showDialog<void>(
        context: context,
        barrierColor: EmeraldColors.textPrimary,
        builder: (context) => _AddRoleDialog(
          onAdd: (name, count, price) {
            model.addRole(name, count, price);
            Navigator.pop(context);
          },
        ),
      ),
      outline: true,
    ),
    ProjectNotice(
      'Tổng ${d.count} vị trí · ${d.allocated ~/ 1000000} triệu. Mỗi người được thuê có một hợp đồng riêng.',
    ),
  ];
  List<Widget> _attachments(ProjectDraft d) => [
    _heading('Tệp đính kèm'),
    _body('Ảnh đại diện chọn ở bước 1. Thêm brief và tài liệu dự án tại đây.'),
    ProjectCard(
      color: EmeraldColors.surfaceSubtle,
      children: [
        const Center(
          child: FigmaAsset(
            '585:6109',
            'imgProfileIconImage',
            width: 28,
            height: 28,
          ),
        ),
        Text(
          'Thêm tài liệu dự án',
          textAlign: TextAlign.center,
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.primaryDark,
          ),
        ),
        Text(
          'PDF, ZIP, PNG, JPG · Tối đa 10 MB/tệp',
          textAlign: TextAlign.center,
          style: authText(11, color: EmeraldColors.textSecondary),
        ),
        ProjectAction(
          label: 'Chọn tệp',
          onPressed: model.addFile,
          outline: true,
        ),
      ],
    ),
    _heading('Đã tải lên · ${d.files.length} tệp', size: 18),
    for (var i = 0; i < d.files.length; i++)
      _file(d.files[i], onRemove: () => model.removeFile(i)),
    _caption(
      'Tổng dung lượng: ${d.files.length == 2
          ? '9,2'
          : d.files.isEmpty
          ? '0'
          : d.files.first.$3.split(' ').first} MB',
    ),
    const ProjectNotice(
      'Tệp đính kèm sẽ hiển thị với freelancer khi dự án được đăng.',
      heading: 'Ai có thể xem tệp?',
      check: false,
    ),
  ];
  List<Widget> _preview(ProjectDraft d) => [
    _heading('Kiểm tra lần cuối'),
    _body('Bạn có thể chỉnh sửa từng mục trước khi đăng.'),
    _owner(),
    _editSection('Thông tin dự án', ProjectCreationStage.basic),
    ProposalProjectSummary(
      project: model.draftProject(),
      node: '585:6187',
      slot: 'imgProjectCoverThumbnail',
      budget: d.budget,
      days: d.days,
    ),
    _editSection('Mô tả & bàn giao', ProjectCreationStage.description),
    ProjectCard(
      children: [
        Text(d.fields['description']!, style: authText(14)),
        Text('Sản phẩm bàn giao', style: authText(13, weight: FontWeight.w500)),
        _body(d.fields['deliverables']!),
      ],
    ),
    _skills(d),
    _editSection('Ngân sách & thời hạn', ProjectCreationStage.budget),
    ProjectCard(
      children: [
        Text(
          'Tổng dự án · ${formatDong(d.budget)}',
          style: authText(18, weight: FontWeight.w700),
        ),
        Text(
          '${d.fields['start']} – ${d.fields['end']} · ${d.days} ngày',
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.textSecondary,
          ),
        ),
        _caption(
          '${d.count} vị trí · ${d.roles.map((r) => '${r.count} ${r.title} / ${r.price}').join(' · ')}',
        ),
      ],
    ),
    _editSection('Tệp đính kèm', ProjectCreationStage.attachments),
    for (final file in d.files) _file(file),
  ];
  List<Widget> _success(ProjectDraft d) => [
    const SizedBox(
      height: 172,
      child: Center(
        child: SizedBox(
          width: 200,
          height: 172,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -24,
                top: -32,
                width: 248,
                height: 248,
                child: FigmaAsset('585:6256', 'imgProjectsSuccessGlowingCheck'),
              ),
            ],
          ),
        ),
      ),
    ),
    Text(
      'Đăng dự án thành công!',
      textAlign: TextAlign.center,
      style: authText(21, weight: FontWeight.w700),
    ),
    Text(
      'Dự án đã hiển thị với cộng đồng freelancer và sẵn sàng nhận đề xuất.',
      textAlign: TextAlign.center,
      style: authText(14, color: EmeraldColors.textSecondary),
    ),
    ProposalProjectSummary(
      project: model.published ?? model.draftProject(),
      node: '585:6256',
      slot: 'imgProjectCoverThumbnail',
      budget: d.budget,
      days: d.days,
    ),
    TextButton(
      onPressed: onMine,
      child: Text(
        'Về dự án của tôi',
        style: authText(
          13,
          weight: FontWeight.w500,
          color: EmeraldColors.primaryDark,
        ),
      ),
    ),
  ];
  Widget _field(ProjectDraft d, String key, String label, {int lines = 1}) =>
      ProfileInput(
        key: ValueKey(key),
        label: label,
        value: d.fields[key] ?? '',
        onChanged: (v) => model.change(key, v),
        lines: lines,
      );
  Widget _editSection(String title, ProjectCreationStage to) => Row(
    children: [
      Expanded(child: _heading(title, size: 18)),
      TextButton(
        onPressed: () => onEdit(to),
        child: Text(
          'Sửa',
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.primaryDark,
          ),
        ),
      ),
    ],
  );
  Widget _skills(ProjectDraft d) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final skill in d.skills)
        InkWell(
          onTap: () => model.removeSkill(skill),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ProfileTokens.border),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (['Figma', 'UI/UX', 'Mobile UX'].contains(skill)) ...[
                  FigmaAsset(
                    '585:5951',
                    skill == 'Figma'
                        ? 'imgProfileTechnologyFigma'
                        : skill == 'UI/UX'
                        ? 'imgProfileIconLayers'
                        : 'imgProfileIconMobile',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(skill, style: authText(11, weight: FontWeight.w500)),
              ],
            ),
          ),
        ),
    ],
  );
  Widget _owner() => ProjectCard(
    children: [
      _caption('CLIENT ĐĂNG DỰ ÁN'),
      Row(
        children: [
          const FigmaAsset('585:4950', 'imgEllipse', width: 44, height: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trần Quốc Huy',
                  style: authText(13, weight: FontWeight.w500),
                ),
                _caption('Client độc lập'),
              ],
            ),
          ),
        ],
      ),
      _caption('Người liên hệ và quản lý dự án: Trần Quốc Huy'),
    ],
  );
  Widget _file((String, String, String) file, {VoidCallback? onRemove}) =>
      ProjectCard(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: EmeraldColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  file.$1,
                  style: authText(11, color: EmeraldColors.primaryDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(file.$2, style: authText(13, weight: FontWeight.w500)),
                    _caption(
                      '${file.$3}${onRemove == null ? '' : ' · Đã tải lên'}',
                    ),
                  ],
                ),
              ),
              if (onRemove != null)
                SizedBox(
                  width: 24,
                  height: 40,
                  child: InkWell(
                    onTap: onRemove,
                    child: const Center(
                      child: FigmaAsset(
                        '585:6109',
                        'imgEmerald2026NavigationIconClose',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                )
              else
                const FigmaAsset(
                  '585:6187',
                  'imgProfileIconCheck',
                  width: 20,
                  height: 20,
                ),
            ],
          ),
        ],
      );
}

class ProjectCreationStepper extends StatelessWidget {
  const ProjectCreationStepper(this.step, {super.key});
  final int step;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(
            'Bước $step/5',
            style: authText(
              13,
              weight: FontWeight.w500,
              color: EmeraldColors.primaryDark,
            ),
          ),
          Expanded(
            child: Text(
              [
                'Thông tin cơ bản',
                'Mô tả & kỹ năng',
                'Ngân sách & thời hạn',
                'Vai trò & ngân sách',
                'Tệp đính kèm',
              ][step - 1],
              textAlign: TextAlign.right,
              style: authText(
                13,
                weight: FontWeight.w500,
                color: EmeraldColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          for (var i = 1; i <= 5; i++) ...[
            if (i > 1) const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: i <= step
                      ? EmeraldColors.primary
                      : EmeraldColors.surfaceSubtle,
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

class _AddRoleDialog extends StatefulWidget {
  const _AddRoleDialog({required this.onAdd});
  final void Function(String, String, String) onAdd;
  @override
  State<_AddRoleDialog> createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<_AddRoleDialog> {
  String name = 'QA / Kiểm thử', count = '1', price = 'Thỏa thuận';
  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(20),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _gaps([
          _heading('Thêm vị trí tuyển dụng'),
          _body('Mỗi freelancer được chọn sẽ có hợp đồng và milestone riêng.'),
          ProfileInput(
            label: 'Tên vị trí',
            value: name,
            onChanged: (v) => name = v,
          ),
          ProfileInput(
            label: 'Số người',
            value: count,
            onChanged: (v) => count = v,
          ),
          ProfileInput(
            label: 'Ngân sách / người',
            value: price,
            onChanged: (v) => price = v,
          ),
          ProjectAction(
            label: 'Thêm vị trí',
            solid: true,
            onPressed: () => widget.onAdd(name, count, price),
          ),
          ProjectAction(
            label: 'Hủy',
            outline: true,
            onPressed: () => Navigator.pop(context),
          ),
        ], 12),
      ),
    ),
  );
}

Widget _heading(String text, {double size = 21}) =>
    Text(text, style: authText(size, weight: FontWeight.w700));
Widget _body(String text) =>
    Text(text, style: authText(14, color: EmeraldColors.textSecondary));
Widget _caption(String text) =>
    Text(text, style: authText(11, color: EmeraldColors.textSecondary));
List<Widget> _gaps(List<Widget> children, double gap) => [
  for (var i = 0; i < children.length; i++) ...[
    if (i > 0) SizedBox(height: gap),
    children[i],
  ],
];
