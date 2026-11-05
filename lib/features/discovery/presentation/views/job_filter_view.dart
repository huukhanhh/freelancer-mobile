import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/workly_button.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/discovery/presentation/view_models/discovery_view_model.dart';
import 'package:workly/features/discovery/presentation/widgets/discovery_components.dart';

class JobFilterView extends StatelessWidget {
  const JobFilterView({
    required this.model,
    required this.onBack,
    required this.onApply,
    super.key,
  });
  final DiscoveryViewModel model;
  final VoidCallback onBack, onApply;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final f = model.draft;
      final preview = AuthDesignPreview.of(context);
      final extra = preview
          ? 0.0
          : math.max(0.0, MediaQuery.viewPaddingOf(context).top - 34);
      Widget title(String label) =>
          Text(label, style: discoveryText(16, weight: FontWeight.w700));
      Widget options(
        List<String> labels,
        String selected,
        ValueChanged<String> onSelect,
      ) => Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: DiscoveryChip(
                label: labels[i],
                selected: labels[i] == selected,
                onTap: () => onSelect(labels[i] == selected ? '' : labels[i]),
              ),
            ),
          ],
        ],
      );
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [EmeraldColors.deep, EmeraldColors.primary],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 179 + extra,
                  child: InkWell(
                    onTap: onBack,
                    child: Stack(
                      children: [
                        if (preview) ...[
                          Positioned(
                            left: 20,
                            top: 11,
                            child: Text(
                              '9:41',
                              style: discoveryText(
                                12,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Positioned(
                            right: 20,
                            top: 12,
                            child: FigmaAsset(
                              '585:4812',
                              'imgNavigationVectorSystemStatus',
                              width: 74,
                              height: 14,
                            ),
                          ),
                        ],
                        Positioned(
                          left: 22,
                          top: 66 + extra,
                          right: 20,
                          child: Text(
                            'Khám phá dự án',
                            style: discoveryText(
                              21,
                              weight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 22,
                          top: 108 + extra,
                          right: 20,
                          child: Text(
                            'Lọc theo sở thích của bạn',
                            style: discoveryText(
                              13,
                              color: const Color(0xFFD1FAE5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(27),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        math.max(38, MediaQuery.viewPaddingOf(context).bottom),
                      ),
                      children: [
                        Center(
                          child: Container(
                            width: 52,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD3E4DA),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Bộ lọc tìm việc',
                                style: discoveryText(
                                  21,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: model.resetDraft,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  'Đặt lại',
                                  style: discoveryText(
                                    11,
                                    weight: FontWeight.w700,
                                    color: EmeraldColors.emerald600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 33),
                        title('Chuyên môn'),
                        const SizedBox(height: 13),
                        options(
                          ['Thiết kế', 'Web', 'Mobile', 'AI/Data'],
                          f.category,
                          (s) => model.updateDraft(f.copyWith(category: s)),
                        ),
                        const SizedBox(height: 28),
                        title('Khoảng ngân sách'),
                        const SizedBox(height: 15),
                        Text(
                          '${jobMoney(f.minimum)}  —  ${jobMoney(f.maximum)}',
                          style: discoveryText(
                            13,
                            weight: FontWeight.w700,
                            color: EmeraldColors.emerald600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 48,
                          child: LayoutBuilder(
                            builder: (context, box) {
                              final start = DiscoveryViewModel.fractionAt(
                                    f.minimum,
                                  ),
                                  end = DiscoveryViewModel.fractionAt(
                                    f.maximum,
                                  );
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDBEEE4),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Positioned(
                                    left: box.maxWidth * start,
                                    right: box.maxWidth * (1 - end),
                                    height: 7,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            EmeraldColors.primary,
                                            EmeraldColors.teal,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 7,
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      thumbColor: Colors.white,
                                      overlayColor: Colors.transparent,
                                      rangeThumbShape:
                                          const RoundRangeSliderThumbShape(
                                            enabledThumbRadius: 11.5,
                                            elevation: 4,
                                          ),
                                    ),
                                    child: RangeSlider(
                                      padding: EdgeInsets.zero,
                                      values: RangeValues(start, end),
                                      divisions: 100,
                                      semanticFormatterCallback: (t) =>
                                          jobMoney(
                                            DiscoveryViewModel.budgetAt(t),
                                          ),
                                      onChanged: (v) => model.updateDraft(
                                        f.copyWith(
                                          minimum: DiscoveryViewModel.budgetAt(
                                            v.start,
                                          ),
                                          maximum: DiscoveryViewModel.budgetAt(
                                            v.end,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        title('Công nghệ'),
                        const SizedBox(height: 17),
                        options(
                          ['React', 'Flutter', 'Python', 'Figma'],
                          f.technology,
                          (s) => model.updateDraft(f.copyWith(technology: s)),
                        ),
                        const SizedBox(height: 27),
                        title('Hình thức công việc'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            for (var i = 0; i < 3; i++) ...[
                              if (i > 0) const SizedBox(width: 10),
                              Expanded(
                                child: DiscoveryChip(
                                  label: ['Trọn gói', 'Theo giờ', 'Remote'][i],
                                  selected: i == 2
                                      ? f.remote
                                      : f.billing ==
                                            ['Trọn gói', 'Theo giờ'][i],
                                  onTap: () => model.updateDraft(
                                    i == 2
                                        ? f.copyWith(remote: !f.remote)
                                        : f.copyWith(
                                            billing:
                                                f.billing ==
                                                    ['Trọn gói', 'Theo giờ'][i]
                                                ? ''
                                                : ['Trọn gói', 'Theo giờ'][i],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 38),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: EmeraldColors.background,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Chỉ xem Client đã xác minh thanh toán',
                                  style: discoveryText(12),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Semantics(
                                label: 'Chỉ xem Client đã xác minh thanh toán',
                                toggled: f.verified,
                                child: InkWell(
                                  onTap: () => model.updateDraft(
                                    f.copyWith(verified: !f.verified),
                                  ),
                                  child: Container(
                                    width: 38,
                                    height: 22,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: f.verified
                                          ? EmeraldColors.primary
                                          : const Color(0xFFDBEEE4),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Align(
                                      alignment: f.verified
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 57,
                          child: WorklyButton(
                            label:
                                'Xem ${model.matching(f).length} dự án phù hợp',
                            onPressed: () {
                              model.applyDraft();
                              onApply();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
