import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/projects/presentation/view_models/projects_view_model.dart';

class ClientProjectView extends StatelessWidget {
  const ClientProjectView({
    required this.model,
    required this.onHome,
    required this.onBack,
    this.sentInvites = 0,
    this.projectId = "job-demo-4",
    this.onProposals,
    this.onEdit,
    this.onContracts,
    super.key,
  });
  final ProjectsViewModel model;
  final VoidCallback onHome, onBack;
  final VoidCallback? onProposals, onEdit, onContracts;
  final int sentInvites;
  final String projectId;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final p = model.find(projectId), m = model.management;
      if (p == null || m == null) return const SizedBox.shrink();
      return ProjectPage(
        title: 'Quản lý dự án',
        contextHeader: true,
        onBack: onBack,
        onHome: onHome,
        action: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProjectAction(
              label: 'Xem ${m.received} đề xuất',
              onPressed: onProposals,
            ),
            const SizedBox(height: 8),
            ProjectAction(
              label: 'Chỉnh sửa dự án',
              onPressed: onEdit,
              outline: true,
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: _gaps([
            if (sentInvites > 0)
              ProjectNotice('Đã gửi lời mời đến $sentInvites freelancer'),
            SizedBox(
              height: 197,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const FigmaAsset(
                      '585:6319',
                      'imgProjectCoverManagementDetail',
                      fit: BoxFit.cover,
                    ),
                    const Positioned(
                      right: 16,
                      bottom: 16,
                      width: 98,
                      child: ProjectAction(
                        label: 'Thay ảnh',
                        outline: true,
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: EmeraldColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${p.code} · Đang tuyển',
                  style: authText(11, color: EmeraldColors.primaryDark),
                ),
              ),
            ),
            Text(p.title, style: authText(21, weight: FontWeight.w700)),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EmeraldColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${p.vacancies.fold<int>(0, (n, v) => n + v.count)} vị trí cần tuyển',
                    style: authText(
                      13,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mỗi vị trí được ký hợp đồng riêng. Chấp nhận một đề xuất không tự đóng tuyển các vị trí còn lại.',
                    style: authText(11, color: EmeraldColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ProjectAction(
                    label: 'Xem hợp đồng của dự án',
                    onPressed: onContracts,
                    outline: true,
                  ),
                ],
              ),
            ),
            ProjectCard(
              children: [
                Text(
                  'CLIENT ĐĂNG DỰ ÁN',
                  style: authText(11, color: EmeraldColors.textSecondary),
                ),
                Row(
                  children: [
                    const FigmaAsset(
                      '585:4950',
                      'imgEllipse',
                      width: 44,
                      height: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.owner,
                            style: authText(13, weight: FontWeight.w500),
                          ),
                          Text(
                            'Client độc lập',
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
                Text(
                  'Người liên hệ và quản lý dự án: ${p.owner}',
                  style: authText(11, color: EmeraldColors.textSecondary),
                ),
              ],
            ),
            Text(
              '${p.owner} · Client độc lập',
              style: authText(11, color: EmeraldColors.textSecondary),
            ),
            Row(
              children: [
                Expanded(
                  child: ProjectCard(
                    gap: 4,
                    children: [
                      Text(
                        '${m.received}'.padLeft(2, '0'),
                        style: authText(
                          21,
                          weight: FontWeight.w700,
                          color: EmeraldColors.primaryDark,
                        ),
                      ),
                      Text('Đề xuất đã nhận', style: authText(11)),
                      Text(
                        '${m.newProposals} đề xuất mới',
                        style: authText(11, color: EmeraldColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProjectCard(
                    gap: 4,
                    children: [
                      Text(
                        '${m.candidates.length}'.padLeft(2, '0'),
                        style: authText(
                          21,
                          weight: FontWeight.w700,
                          color: EmeraldColors.primaryDark,
                        ),
                      ),
                      Text('Ứng viên đã chọn', style: authText(11)),
                      Text(
                        'Danh sách rút gọn',
                        style: authText(11, color: EmeraldColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ProjectNotice(
              'Bạn đã chọn ${m.candidates.length} ứng viên từ ${m.received} đề xuất. Xem chi tiết để so sánh phạm vi, báo giá và thời gian.',
              heading: 'Sẵn sàng trao đổi với ứng viên',
              check: false,
            ),
            ProjectCard(
              children: [
                Text(
                  'Ngân sách & thời hạn',
                  style: authText(13, weight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDong(p.budget),
                        style: authText(
                          18,
                          weight: FontWeight.w700,
                          color: EmeraldColors.primaryDark,
                        ),
                      ),
                    ),
                    Text(
                      '${p.days} ngày',
                      style: authText(13, weight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  'Tổng dự án · ${p.vacancies.map((v) => '${v.title} ${v.budget ~/ 1000000}tr').join(' · ')}',
                  style: authText(11, color: EmeraldColors.textSecondary),
                ),
              ],
            ),
            Text(
              '${p.startDate} – ${p.endDate} · ${p.billing}',
              style: authText(11, color: EmeraldColors.textSecondary),
            ),
            Text(
              'Kỹ năng yêu cầu',
              style: authText(18, weight: FontWeight.w700),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ProfileTokens.border),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FigmaAsset(
                          '585:6319',
                          [
                            'imgProfileTechnologyFigma',
                            'imgProfileIconLayers',
                            'imgProfileIconMobile',
                          ][i],
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ['Figma', 'UI/UX', 'Mobile UX'][i],
                          style: authText(11, weight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Text(
              'Tài liệu dự án',
              style: authText(18, weight: FontWeight.w700),
            ),
            for (final a in p.attachments)
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
                          a.$1,
                          style: authText(11, color: EmeraldColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.$2,
                              style: authText(13, weight: FontWeight.w500),
                            ),
                            Text(
                              a.$3,
                              style: authText(
                                11,
                                color: EmeraldColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const FigmaAsset(
                        '585:6319',
                        'imgProfileIconCheck',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            Text(
              'Ứng viên đã chọn',
              style: authText(18, weight: FontWeight.w700),
            ),
            for (final c in m.candidates)
              ProjectCard(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: EmeraldColors.surfaceSubtle,
                        child: Text(
                          c.$6,
                          style: authText(13, color: EmeraldColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.$1,
                              style: authText(13, weight: FontWeight.w500),
                            ),
                            Text(
                              c.$2,
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
                  Text(
                    c.$3,
                    style: authText(14, color: EmeraldColors.textSecondary),
                  ),
                  Text(
                    '${formatDong(c.$4)} · ${c.$5} ngày',
                    style: authText(
                      13,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                  ProjectAction(
                    label: 'Xem đề xuất',
                    onPressed: onProposals,
                    outline: true,
                  ),
                ],
              ),
          ], 12),
        ),
      );
    },
  );
}

List<Widget> _gaps(List<Widget> children, double gap) => [
  for (var i = 0; i < children.length; i++) ...[
    if (i > 0) SizedBox(height: gap),
    children[i],
  ],
];
