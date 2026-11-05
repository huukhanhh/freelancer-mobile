import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/discovery/presentation/view_models/discovery_view_model.dart';
import 'package:workly/features/discovery/presentation/widgets/discovery_components.dart';

class SavedJobsView extends StatefulWidget {
  const SavedJobsView({
    required this.model,
    required this.onHome,
    required this.onDiscover,
    required this.onProfile,
    required this.onJob,
    super.key,
  });
  final DiscoveryViewModel model;
  final VoidCallback onHome, onDiscover, onProfile;
  final ValueChanged<String> onJob;
  @override
  State<SavedJobsView> createState() => _SavedJobsViewState();
}

class _SavedJobsViewState extends State<SavedJobsView> {
  String category = 'Tất cả';
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) => DiscoveryScaffold(
      node: '585:5092',
      title: 'Việc làm đã lưu',
      subtitle: 'Danh sách yêu thích của bạn',
      onBack: widget.onHome,
      onHome: widget.onHome,
      onDiscover: widget.onDiscover,
      onProfile: widget.onProfile,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 25, 18, 12),
        children: [
          Text(
            '${widget.model.saved.length} dự án đã lưu',
            style: discoveryText(19, weight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              for (final c in ['Tất cả', 'UI/UX', 'Lập trình'])
                DiscoveryChip(
                  label: c,
                  selected: category == c,
                  width: c == 'Tất cả'
                      ? 80
                      : c == 'UI/UX'
                      ? 85
                      : 103,
                  onTap: () => setState(() => category = c),
                ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Sắp xếp: Mới lưu gần đây  ▾',
            style: discoveryText(11, color: DiscoveryColors.muted),
          ),
          const SizedBox(height: 32),
          for (final job in widget.model.savedJobs(category)) ...[
            SavedJobCard(
              job: job,
              onOpen: () => widget.onJob(job.id),
              onRemove: () => widget.model.toggleSaved(job.id),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    ),
  );
}

class SavedJobCard extends StatelessWidget {
  const SavedJobCard({
    required this.job,
    required this.onOpen,
    required this.onRemove,
    super.key,
  });
  final Job job;
  final VoidCallback onOpen, onRemove;
  @override
  Widget build(BuildContext context) {
    final sourceIndex = [
      'job-demo-4',
      'job-demo-5',
      'job-demo-6',
    ].indexOf(job.id);
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: EmeraldColors.deep.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 146,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                width: 109,
                height: 104,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: FigmaAsset(
                    sourceIndex >= 0 ? '585:5092' : job.imageNode,
                    sourceIndex >= 0
                        ? 'imgEditorialRealPhotography${sourceIndex == 0 ? '' : sourceIndex}'
                        : job.imageSlot,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 132,
                right: 12,
                top: 16,
                child: Text(
                  job.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: discoveryText(14, weight: FontWeight.w700),
                ),
              ),
              Positioned(
                left: 132,
                right: 12,
                top: 43,
                child: Text(
                  job.client.split(' · ').first,
                  style: discoveryText(11, color: EmeraldColors.textSecondary),
                ),
              ),
              Positioned(
                left: 132,
                right: 12,
                top: 72,
                child: Text(
                  jobMoney(job.budget),
                  style: discoveryText(
                    16,
                    weight: FontWeight.w700,
                    color: EmeraldColors.emerald600,
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 120,
                child: Text(
                  '${job.days} ngày  ·  ${job.hourly ? 'Theo giờ' : 'Trọn gói'}',
                  style: discoveryText(11, color: DiscoveryColors.muted),
                ),
              ),
              Positioned(
                right: 12,
                top: 100,
                height: 44,
                width: 90,
                child: InkWell(
                  onTap: onRemove,
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: '♥ ',
                            style: TextStyle(fontFamily: 'Noto Sans Symbols 2'),
                          ),
                          const TextSpan(text: 'Đã lưu'),
                        ],
                      ),
                      style: discoveryText(11, color: const Color(0xFFE47751)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
