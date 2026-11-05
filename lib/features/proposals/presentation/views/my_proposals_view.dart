import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/projects/domain/project_repository.dart';
import 'package:workly/features/proposals/presentation/view_models/proposal_view_model.dart';
import 'package:workly/features/proposals/presentation/views/proposal_flow_view.dart';

class MyProposalsView extends StatelessWidget {
  const MyProposalsView({required this.model, required this.onHome, super.key});
  final ProposalViewModel model;
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => ProjectPage(
      title: 'Proposal của tôi',
      onBack: onHome,
      onHome: onHome,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final label in [
                    'Đang chờ',
                    'Shortlist',
                    'Được chọn',
                    'Bị từ chối',
                    'Đã rút',
                    'Nháp',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: SizedBox(
                        width: 106,
                        child: TextButton(
                          onPressed: () => model.selectStatus(label),
                          style: TextButton.styleFrom(
                            backgroundColor: model.status == label
                                ? Colors.white
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            label,
                            style: authText(
                              16,
                              weight: FontWeight.w500,
                              color: model.status == label
                                  ? EmeraldColors.primaryDark
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${model.filtered.length} Proposal · ${model.status}',
                  style: authText(12, color: EmeraldColors.textSecondary),
                ),
                const SizedBox(height: 16),
                for (final p in model.filtered) ...[
                  ProjectCard(
                    gap: 12,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FigmaAsset(
                              p.imageNode,
                              p.imageSlot,
                              width: 80,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p.title,
                              style: authText(
                                16,
                                weight: FontWeight.w500,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formatDong(p.price),
                        style: authText(
                          20,
                          weight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Gửi ngày ${p.sentDate}',
                            style: authText(12, color: const Color(0xFF475569)),
                          ),
                          Container(
                            width: 120,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              p.status,
                              style: authText(
                                12,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class SentProposalsView extends StatelessWidget {
  const SentProposalsView({
    required this.model,
    required this.onHome,
    required this.onMine,
    super.key,
  });
  final ProposalViewModel model;
  final VoidCallback onHome, onMine;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final sent = model.sent;
      final d = model.draft;
      final recent = model.proposals
          .where((p) => p.projectId.startsWith('job-demo-'))
          .toList();
      return ProjectPage(
        title: 'Đề xuất đã gửi',
        contextHeader: true,
        onBack: onMine,
        onHome: onHome,
        child: AuthScrollBody(
          children: [
            Text(
              'Cơ hội của bạn',
              style: authText(21, weight: FontWeight.w700),
            ),
            Text(
              'Theo dõi phản hồi và các cuộc trao đổi đang diễn ra.',
              style: authText(14, color: EmeraldColors.textSecondary),
            ),
            Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i == 0
                            ? EmeraldColors.surfaceSubtle
                            : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${['Chờ phản hồi', 'Đang trao đổi', 'Từ chối'][i]} · ${i == 0 ? recent.length : 0}',
                        style: authText(11, color: EmeraldColors.primaryDark),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (sent != null)
              ProjectNotice(
                'Hợp đồng riêng cho vị trí ${sent.vacancy} · Nguyễn Minh Anh · Báo giá ${formatDong(sent.price)}.',
                heading: 'Ứng tuyển theo vai trò',
                check: false,
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Đề xuất gần đây',
                    style: authText(18, weight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: onMine,
                  child: Text(
                    'Quản lý',
                    style: authText(13, color: EmeraldColors.primaryDark),
                  ),
                ),
              ],
            ),
            for (final p in recent)
              ProposalProjectSummary(
                project: Project(
                  id: p.projectId,
                  code: d?.project.id == p.projectId
                      ? d!.project.code
                      : p.projectId,
                  title: p.title,
                  owner: '',
                  description: '',
                  budget: p.price,
                  days: p.days,
                  vacancies: const [],
                  imageNode: p.imageNode,
                  imageSlot: p.imageSlot,
                ),
                node: p.imageNode,
                slot: p.imageSlot,
                status: 'Chờ phản hồi',
                code: p.id,
                budget: p.price,
                days: p.days,
              ),
          ],
        ),
      );
    },
  );
}
