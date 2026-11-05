import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/projects/domain/project_repository.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({
    required this.project,
    required this.onBack,
    required this.onHome,
    required this.onApply,
    super.key,
  });
  final Project project;
  final VoidCallback onBack, onHome, onApply;
  @override
  Widget build(BuildContext context) => ProjectPage(
    title: 'Chi tiết dự án',
    onBack: onBack,
    onHome: onHome,
    action: ProjectAction(
      label: 'Chọn vị trí ứng tuyển',
      onPressed: onApply,
      solid: true,
    ),
    child: AuthScrollBody(
      gap: 16,
      children: [
        Text(project.title, style: authText(21, weight: FontWeight.w700)),
        Text(
          '${project.code} · ${project.owner} · Client độc lập',
          style: authText(14, color: EmeraldColors.textSecondary),
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
                        project.owner,
                        style: authText(13, weight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Client độc lập',
                        style: authText(11, color: EmeraldColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'Người liên hệ và quản lý dự án: ${project.owner}',
              style: authText(11, color: EmeraldColors.textSecondary),
            ),
          ],
        ),
        SizedBox(
          height: 180,
          child: FigmaAsset(
            project.imageNode,
            project.imageSlot,
            fit: BoxFit.contain,
          ),
        ),
        ProjectCard(
          children: [
            Text(
              'TỔNG NGÂN SÁCH DỰ ÁN',
              style: authText(11, color: EmeraldColors.textSecondary),
            ),
            Text(
              formatDong(project.budget),
              style: authText(
                25,
                weight: FontWeight.w700,
                color: EmeraldColors.primaryDark,
              ),
            ),
            Text(
              '${project.vacancies.fold<int>(0, (n, v) => n + v.count)} vị trí · Hợp đồng và thanh toán riêng',
              style: authText(13, weight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          project.vacancies
              .map((v) => '${v.title} · ${v.budget ~/ 1000000} triệu / người')
              .join('\n'),
          style: authText(14, color: EmeraldColors.textSecondary),
        ),
        Text(project.description, style: authText(14)),
        const ProjectNotice(
          'Client có thể thuê nhiều người. Freelancer chỉ chịu trách nhiệm với hợp đồng của mình.',
        ),
      ],
    ),
  );
}

class VacancySelectionView extends StatelessWidget {
  const VacancySelectionView({
    required this.project,
    required this.onBack,
    required this.onHome,
    required this.onSelect,
    super.key,
  });
  final Project project;
  final VoidCallback onBack, onHome;
  final ValueChanged<Vacancy> onSelect;
  @override
  Widget build(BuildContext context) => ProjectPage(
    title: 'Chọn vị trí ứng tuyển',
    onBack: onBack,
    onHome: onHome,
    action: ProjectAction(
      label: 'Tiếp tục ứng tuyển',
      solid: true,
      onPressed: () => onSelect(project.vacancies.first),
    ),
    child: AuthScrollBody(
      gap: 16,
      children: [
        Text(
          'Bạn muốn đảm nhận phần nào?',
          style: authText(21, weight: FontWeight.w700),
        ),
        Text(
          '${project.code} · Tổng dự án ${formatDong(project.budget)}',
          style: authText(14, color: EmeraldColors.textSecondary),
        ),
        ProjectIdentity(
          project,
          node: project.code == 'P-024' ? '813:6762' : null,
          slot: project.code == 'P-024' ? 'imgProjectCoverThumbnail' : null,
        ),
        for (final v in project.vacancies)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelect(v),
              child: ProjectCard(
                children: [
                  Text(
                    '${v.title} · ${v.count} vị trí',
                    style: authText(18, weight: FontWeight.w700),
                  ),
                  Text(
                    '${formatDong(v.budget)} / người',
                    style: authText(
                      18,
                      weight: FontWeight.w700,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                  Text(
                    v.scope,
                    style: authText(11, color: EmeraldColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        const ProjectNotice(
          'Ứng tuyển cho một vai trò. Giá bạn đề xuất và hợp đồng chỉ áp dụng phần công việc đó.',
        ),
      ],
    ),
  );
}
