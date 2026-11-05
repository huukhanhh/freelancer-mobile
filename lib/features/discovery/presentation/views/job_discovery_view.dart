import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/workly_button.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/discovery/presentation/view_models/discovery_view_model.dart';
import 'package:workly/features/discovery/presentation/widgets/discovery_components.dart';

enum JobDiscoveryMode { browse, search, results }

class JobDiscoveryView extends StatefulWidget {
  const JobDiscoveryView({
    required this.model,
    required this.mode,
    required this.onBack,
    required this.onHome,
    required this.onSearch,
    required this.onFilter,
    required this.onResults,
    this.onJob,
    this.onProfile,
    super.key,
  });
  final DiscoveryViewModel model;
  final JobDiscoveryMode mode;
  final ValueChanged<String>? onJob;
  final VoidCallback? onProfile;
  final VoidCallback onBack, onHome, onSearch, onFilter, onResults;
  @override
  State<JobDiscoveryView> createState() => _JobDiscoveryViewState();
}

class _JobDiscoveryViewState extends State<JobDiscoveryView> {
  late final _query = TextEditingController(text: widget.model.query);
  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _search(String text) {
    FocusScope.of(context).unfocus();
    widget.model.search(text);
    widget.onResults();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) {
      final m = widget.model, mode = widget.mode;
      final node = switch (mode) {
        JobDiscoveryMode.browse => '585:4648',
        JobDiscoveryMode.search => '585:4731',
        JobDiscoveryMode.results => '585:4873',
      };
      return DiscoveryScaffold(
        node: node,
        onProfile: widget.onProfile,
        title: switch (mode) {
          JobDiscoveryMode.browse => 'Khám phá công việc',
          JobDiscoveryMode.search => 'Tìm kiếm công việc',
          JobDiscoveryMode.results => 'Kết quả lọc',
        },
        subtitle: switch (mode) {
          JobDiscoveryMode.browse => 'Chọn công việc phù hợp với bạn',
          JobDiscoveryMode.search => 'Tìm nhanh theo tên, kỹ năng',
          JobDiscoveryMode.results =>
            'Tìm thấy ${m.results.length} công việc phù hợp',
        },
        onBack: widget.onBack,
        onHome: widget.onHome,
        search: DiscoverySearchBar(
          node: node,
          hint: mode == JobDiscoveryMode.browse
              ? 'Tên dự án, kỹ năng, công nghệ...'
              : mode == JobDiscoveryMode.search
              ? 'Flutter developer, Figma, React...'
              : m.query.isEmpty
              ? m.applied.technology
              : m.query,
          controller: mode == JobDiscoveryMode.search ? _query : null,
          onOpen: widget.onSearch,
          onSubmit: _search,
          onFilter: widget.onFilter,
        ),
        child: m.loading
            ? const Center(child: CircularProgressIndicator())
            : m.error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthFeedback(message: m.error!),
                    TextButton(
                      onPressed: m.initialize,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            : mode == JobDiscoveryMode.search
            ? _SearchContent(model: m, onSearch: _search)
            : LayoutBuilder(
                builder: (context, box) {
                  final header = Padding(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      mode == JobDiscoveryMode.browse ? 28 : 30,
                      18,
                      mode == JobDiscoveryMode.browse ? 18 : 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (mode == JobDiscoveryMode.browse) ...[
                          Text(
                            'Danh mục hot',
                            style: discoveryText(16, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              for (var i = 0; i < 4; i++) ...[
                                if (i > 0) const SizedBox(width: 8),
                                Expanded(
                                  child: DiscoveryChip(
                                    label: [
                                      'Tất cả',
                                      'UI/UX',
                                      'Lập trình',
                                      'AI/Data',
                                    ][i],
                                    selected: i == 0,
                                    onTap: () {
                                      m.category(
                                        [
                                          'Tất cả',
                                          'UI/UX',
                                          'Lập trình',
                                          'AI/Data',
                                        ][i],
                                      );
                                      widget.onResults();
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 30),
                        ] else ...[
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              if (m.applied.technology.isNotEmpty ||
                                  m.query.isNotEmpty)
                                DiscoveryChip(
                                  label:
                                      '${m.applied.technology.isNotEmpty ? m.applied.technology : m.query} ×',
                                  selected: true,
                                  onTap: () {
                                    if (m.applied.technology.isNotEmpty) {
                                      m.removeTechnology();
                                    } else {
                                      m.search('');
                                    }
                                  },
                                ),
                              if (m.applied.remote)
                                DiscoveryChip(
                                  label: 'Remote ×',
                                  selected: true,
                                  onTap: m.removeRemote,
                                ),
                              if (m.applied.minimum > 0 ||
                                  m.applied.maximum < 50000000)
                                DiscoveryChip(
                                  label:
                                      '${m.applied.minimum ~/ 1000000}tr - ${m.applied.maximum ~/ 1000000}tr ×',
                                  onTap: m.removeBudget,
                                ),
                            ],
                          ),
                          const SizedBox(height: 22),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                mode == JobDiscoveryMode.browse
                                    ? 'Kết quả dành cho bạn'
                                    : '${m.results.length} kết quả',
                                style: discoveryText(
                                  18,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (mode == JobDiscoveryMode.browse)
                              Text(
                                'Gợi ý 96%',
                                style: discoveryText(
                                  11,
                                  weight: FontWeight.w700,
                                  color: EmeraldColors.emerald600,
                                ),
                              )
                            else
                              InkWell(
                                onTap: m.sortNewest,
                                child: Row(
                                  children: [
                                    FigmaAsset(
                                      node,
                                      'imgLucideSort',
                                      width: 22,
                                      height: 22,
                                    ),
                                    Text(
                                      'Mới',
                                      style: discoveryText(
                                        11,
                                        color: EmeraldColors.emerald600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                  final jobs = mode == JobDiscoveryMode.browse
                      ? m.featured
                      : m.results;
                  final cards = [
                    for (final job in jobs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DiscoveryJobCard(
                          job: job,
                          onOpen: widget.onJob == null
                              ? null
                              : () => widget.onJob!(job.id),
                          saved: m.saved.contains(job.id),
                          onSave: () => m.toggleSaved(job.id),
                        ),
                      ),
                  ];
                  if (box.maxHeight < 230) {
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 12),
                      children: [
                        header,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(children: cards),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      header,
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          children: cards,
                        ),
                      ),
                    ],
                  );
                },
              ),
      );
    },
  );
}

class _SearchContent extends StatelessWidget {
  const _SearchContent({required this.model, required this.onSearch});
  final DiscoveryViewModel model;
  final ValueChanged<String> onSearch;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 37, 18, 24),
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Lịch sử tìm kiếm',
              style: discoveryText(17, weight: FontWeight.w700),
            ),
          ),
          InkWell(
            onTap: model.clearHistory,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'Xóa',
                style: discoveryText(11, color: EmeraldColors.emerald600),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      for (var i = 0; i < model.history.length; i++) ...[
        if (i > 0) const SizedBox(height: 6),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: () => onSearch(model.history[i]),
            child: SizedBox(
              height: 42,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const FigmaAsset(
                      '585:4731',
                      'imgLucideClock',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(model.history[i], style: discoveryText(12)),
                    ),
                    Text(
                      '↗',
                      style: discoveryText(14, color: EmeraldColors.emerald600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      const SizedBox(height: 40),
      Text(
        'Công nghệ xu hướng',
        style: discoveryText(17, weight: FontWeight.w700),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          for (var i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: DiscoveryChip(
                label: ['React', 'Flutter', 'Python', 'Figma'][i],
                selected: i == 1,
                onTap: () =>
                    onSearch(['React', 'Flutter', 'Python', 'Figma'][i]),
              ),
            ),
          ],
        ],
      ),
      const SizedBox(height: 25),
      Text('Cơ hội nổi bật', style: discoveryText(17, weight: FontWeight.w700)),
      const SizedBox(height: 22),
      Material(
        color: Colors.white,
        elevation: 3,
        shadowColor: EmeraldColors.deep.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            const FigmaAsset(
              '585:4731',
              'imgGenuineWorkspacePhoto',
              width: 133,
              height: 151,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 12, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer ReactJS',
                      style: discoveryText(16, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '8 triệu • Remote',
                      style: discoveryText(
                        13,
                        weight: FontWeight.w700,
                        color: EmeraldColors.emerald600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Thiết kế dashboard quản trị',
                      style: discoveryText(
                        11,
                        color: EmeraldColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DiscoveryChip(
                      label: 'Xem công việc →',
                      width: 172,
                      onTap: () => onSearch('React'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class EmptyDiscoveryView extends StatelessWidget {
  const EmptyDiscoveryView({
    required this.onBack,
    required this.onHome,
    required this.onSearch,
    required this.onExplore,
    super.key,
  });
  final VoidCallback onBack, onHome, onExplore;
  final ValueChanged<String> onSearch;
  @override
  Widget build(BuildContext context) => DiscoveryScaffold(
    node: '585:5144',
    title: 'Không tìm thấy kết quả',
    subtitle: 'Hãy thử tìm lại một lần nữa',
    onBack: onBack,
    onHome: onHome,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(18, 50, 18, 12),
      children: [
        Material(
          color: Colors.white,
          elevation: 3,
          shadowColor: EmeraldColors.deep.withValues(alpha: .11),
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 261,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  left: 13,
                  right: 13,
                  top: 12,
                  height: 223,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const FigmaAsset(
                      '585:5144',
                      'imgEditorialRealPhotography',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 187,
                  child: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: EmeraldColors.surfaceSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: const FigmaAsset(
                      '585:5144',
                      'imgLucideSearch',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Chưa có việc làm phù hợp',
            style: discoveryText(22, weight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Thử thay đổi bộ lọc, ngân sách hoặc chọn công nghệ khác để khám phá thêm dự án.',
            style: discoveryText(13, color: DiscoveryColors.muted),
          ),
        ),
        const SizedBox(height: 60),
        Text(
          'Từ khóa gợi ý',
          style: discoveryText(15, weight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final keyword in ['React', 'Flutter', 'UI/UX'])
              DiscoveryChip(
                label: keyword,
                width: keyword == 'React' ? 74 : 84,
                onTap: () => onSearch(keyword),
              ),
          ],
        ),
        const SizedBox(height: 11),
        WorklyButton(
          label: 'Xem việc nổi bật →',
          height: 56,
          labelSize: 14,
          onPressed: onExplore,
        ),
      ],
    ),
  );
}
