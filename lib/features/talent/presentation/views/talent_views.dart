import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/core/widgets/workly_button.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/discovery/presentation/widgets/discovery_components.dart';
import 'package:workly/features/talent/domain/talent_repository.dart';
import 'package:workly/features/talent/presentation/view_models/talent_view_model.dart';

class TalentBrowseView extends StatelessWidget {
  const TalentBrowseView({
    required this.model,
    required this.onHome,
    required this.onInvite,
    required this.onCompare,
    required this.onOpen,
    super.key,
  });
  final TalentViewModel model;
  final VoidCallback onHome, onInvite, onCompare;
  final ValueChanged<String> onOpen;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => DiscoveryScaffold(
      node: '585:5196',
      title: 'Chợ Freelancer',
      subtitle: 'Tìm người phù hợp với dự án',
      onBack: onHome,
      onHome: onHome,
      client: true,
      selectedIndex: 2,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 13, 18, 12),
        children: [
          Material(
            color: Colors.white,
            elevation: 3,
            shadowColor: EmeraldColors.deep.withValues(alpha: .11),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onInvite,
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    const FigmaAsset(
                      '585:5196',
                      'imgLucideSearch',
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Tìm kỹ năng, tên Freelancer...',
                        style: discoveryText(12, color: DiscoveryColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Chuyên môn', style: discoveryText(17, weight: FontWeight.w700)),
          const SizedBox(height: 17),
          Row(
            children: [
              for (final c in ['Tất cả', 'UI/UX', 'Flutter', 'AI / Data']) ...[
                if (c != 'Tất cả') const SizedBox(width: 8),
                Expanded(
                  child: DiscoveryChip(
                    label: c,
                    selected: model.category == c,
                    onTap: () => model.selectCategory(c),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Freelancer nổi bật',
            style: discoveryText(18, weight: FontWeight.w700),
          ),
          const SizedBox(height: 22),
          for (final t in model.results) ...[
            TalentShopCard(t, onOpen: () => onOpen(t.id)),
            const SizedBox(height: 12),
          ],
          ProjectAction(
            label: 'So sánh freelancer',
            outline: true,
            onPressed: onCompare,
          ),
        ],
      ),
    ),
  );
}

class TalentShopCard extends StatelessWidget {
  const TalentShopCard(this.talent, {required this.onOpen, super.key});
  final Talent talent;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 3,
    shadowColor: EmeraldColors.deep.withValues(alpha: .11),
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(19),
      child: SizedBox(
        height: 129,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 10,
              width: 104,
              height: 104,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FigmaAsset(
                  '585:5196',
                  talent.photoSlot,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 129,
              right: 12,
              top: 14,
              child: Text(
                talent.name,
                style: discoveryText(15, weight: FontWeight.w700),
              ),
            ),
            Positioned(
              left: 129,
              right: 12,
              top: 40,
              child: Text(
                talent.specialty,
                style: discoveryText(11, color: EmeraldColors.textSecondary),
              ),
            ),
            Positioned(
              left: 129,
              right: 12,
              top: 64,
              child: Text(
                '★ ${talent.rating}   •   ${talent.rate ~/ 1000}k/giờ',
                style: discoveryText(
                  12,
                  weight: FontWeight.w700,
                  color: const Color(0xFFC18B19),
                ),
              ),
            ),
            Positioned(
              left: 129,
              top: 90,
              width: 104,
              height: 29,
              child: DiscoveryChip(label: 'Top Rated', onTap: onOpen),
            ),
          ],
        ),
      ),
    ),
  );
}

class TalentCompareView extends StatelessWidget {
  const TalentCompareView({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onChoose,
    super.key,
  });
  final TalentViewModel model;
  final VoidCallback onBack, onHome;
  final ValueChanged<String> onChoose;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final ts = model.compared;
      if (ts.length < 2) return const SizedBox.shrink();
      return DiscoveryScaffold(
        node: '585:5252',
        title: 'So sánh Freelancer',
        subtitle: 'Chọn người phù hợp nhất',
        onBack: onBack,
        onHome: onHome,
        showBottomBar: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(19, 30, 19, 19),
          children: [
            Text(
              '2 Freelancer được chọn',
              style: discoveryText(18, weight: FontWeight.w700),
            ),
            const SizedBox(height: 21),
            Material(
              color: Colors.white,
              elevation: 3,
              shadowColor: EmeraldColors.deep.withValues(alpha: .11),
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 169,
                child: Row(
                  children: [
                    for (var i = 0; i < 2; i++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 11, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: FigmaAsset(
                                  '585:5252',
                                  'imgAvatarReal${i == 0 ? '' : i}',
                                  width: 72,
                                  height: 72,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ts[i].name,
                                style: discoveryText(
                                  15,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                i == 0 ? 'UI/UX Designer' : 'Flutter Developer',
                                style: discoveryText(
                                  11,
                                  color: DiscoveryColors.muted,
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
            const SizedBox(height: 21),
            for (var i = 0; i < 5; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              Container(
                height: 58,
                padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.white : const Color(0xFFF1FBF7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [
                        'Đánh giá',
                        'Giá/giờ',
                        'Dự án hoàn thành',
                        'Thành thạo',
                        'Trạng thái',
                      ][i],
                      style: discoveryText(
                        11,
                        weight: FontWeight.w700,
                        color: EmeraldColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        for (var j = 0; j < 2; j++)
                          Expanded(
                            child: Text(
                              switch (i) {
                                0 => '★ ${ts[j].rating}',
                                1 => jobMoney(ts[j].rate),
                                2 => '${ts[j].completed}',
                                3 => ts[j].skills.take(2).join(' / '),
                                _ => '● Sẵn sàng',
                              },
                              style: discoveryText(
                                13,
                                weight: FontWeight.w700,
                                color: j == 0
                                    ? EmeraldColors.primaryDark
                                    : EmeraldColors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 26),
            WorklyButton(
              label: 'Xem hồ sơ & mời hợp tác',
              onPressed: () => onChoose(ts.first.id),
              style: WorklyButtonStyle.warm,
              height: 56,
            ),
          ],
        ),
      );
    },
  );
}

class TalentInviteView extends StatelessWidget {
  const TalentInviteView({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onSent,
    super.key,
  });
  final TalentViewModel model;
  final VoidCallback onBack, onHome, onSent;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) => ProjectPage(
      title: 'Mời freelancer',
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
            label: 'Gửi lời mời',
            solid: true,
            onPressed: () async {
              if (await model.sendInvites() && context.mounted) onSent();
            },
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: _gaps([
          const TalentProjectContext(
            node: '585:7952',
            title: 'Thiết kế UI/UX ứng dụng GreenPay',
            subtitle: 'P-024 · Trần Quốc Huy',
          ),
          TextFormField(
            onChanged: model.searchInvite,
            style: authText(14),
            decoration: _input('Tìm theo tên hoặc kỹ năng…'),
          ),
          Row(
            children: [
              for (final c in ['UI/UX', 'Figma', 'Branding']) ...[
                if (c != 'UI/UX') const SizedBox(width: 8),
                Expanded(
                  child: TalentPill(
                    c,
                    selected: model.inviteSkill == c,
                    onTap: () => model.skillInvite(c),
                  ),
                ),
              ],
            ],
          ),
          Text(
            'Freelancer phù hợp với dự án',
            style: authText(16, weight: FontWeight.w500),
          ),
          for (final t in model.inviteResults)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => model.toggleInvite(t.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: EmeraldColors.surfaceSubtle,
                            child: Text(
                              t.initials,
                              style: authText(
                                12,
                                color: EmeraldColors.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.fullName,
                                  style: authText(16, weight: FontWeight.w500),
                                ),
                                Text(
                                  t.skills.join(' · '),
                                  style: authText(
                                    12,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            height: 44,
                            child: Checkbox(
                              value: model.selected.contains(t.id),
                              onChanged: (_) => model.toggleInvite(t.id),
                              activeColor: EmeraldColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '★ ${t.rating.replaceAll('.', ',')} · ${t.reviews} đánh giá',
                        style: authText(12, color: const Color(0xFF475569)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Từ ${formatDong(t.projectPrice)} / dự án',
                        style: authText(
                          14,
                          weight: FontWeight.w500,
                          color: EmeraldColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 40),
        ], 16),
      ),
    ),
  );
}

class TalentQuickProfile extends StatefulWidget {
  const TalentQuickProfile({
    required this.talent,
    required this.onInvite,
    this.onMessage,
    super.key,
  });
  final Talent talent;
  final VoidCallback onInvite;
  final VoidCallback? onMessage;
  @override
  State<TalentQuickProfile> createState() => _TalentQuickProfileState();
}

class _TalentQuickProfileState extends State<TalentQuickProfile> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final t = widget.talent;
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: .8,
        widthFactor: 1,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              SizedBox(
                height: 24,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: EmeraldColors.surfaceSubtle,
                          child: Text(
                            t.initials,
                            style: authText(
                              20,
                              weight: FontWeight.w700,
                              color: EmeraldColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.fullName,
                                style: authText(20, weight: FontWeight.w700),
                              ),
                              Text(
                                '${t.specialty} · 3 năm kinh nghiệm',
                                style: authText(
                                  12,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 132,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '✓ Đã xác minh',
                                  style: authText(
                                    12,
                                    color: const Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '★ ${t.rating.replaceAll('.', ',')}/5 · 12 đánh giá  |  Hoàn thành 98%',
                      style: authText(12, color: const Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < 3; i++)
                        Expanded(
                          child: TextButton(
                            onPressed: () => setState(() => tab = i),
                            style: TextButton.styleFrom(
                              backgroundColor: tab == i
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              ['Tổng quan', 'Dự án đã làm', 'Đánh giá'][i],
                              style: authText(
                                12,
                                color: tab == i
                                    ? EmeraldColors.primaryDark
                                    : const Color(0xFF475569),
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
                  children: tab == 0
                      ? _overview(t)
                      : tab == 1
                      ? _projects()
                      : _reviews(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: widget.onMessage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: EmeraldColors.primaryDark,
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Nhắn tin',
                            style: authText(
                              14,
                              weight: FontWeight.w500,
                              color: EmeraldColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: widget.onInvite,
                          style: FilledButton.styleFrom(
                            backgroundColor: EmeraldColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Mời / Chọn',
                            style: authText(
                              14,
                              weight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: math.max(34, MediaQuery.viewPaddingOf(context).bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _overview(Talent t) => _gaps([
    const TalentProjectContext(
      node: '585:8006',
      title: 'Mây · Ứng dụng tài chính',
      subtitle: 'DỰ ÁN TIÊU BIỂU · UI/UX',
    ),
    Text('Giới thiệu', style: authText(16, weight: FontWeight.w500)),
    Text(
      'Tôi thiết kế sản phẩm mobile dễ dùng, từ nghiên cứu người dùng đến UI và prototype. Tôi ưu tiên trao đổi rõ ràng, bàn giao đúng hẹn và tài liệu dễ triển khai.',
      style: authText(14, weight: FontWeight.w500),
    ),
    Text('Kỹ năng', style: authText(16, weight: FontWeight.w500)),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final skill in t.skills) TalentPill(skill)],
    ),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EmeraldColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final stat in [
            ('${t.completed}', 'Dự án hoàn tất'),
            ('98%', 'Hoàn thành'),
            ('43%', 'Khách quay lại'),
          ])
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.$1,
                    style: authText(
                      20,
                      weight: FontWeight.w700,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                  Text(
                    stat.$2,
                    style: authText(12, color: const Color(0xFF475569)),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  ], 16);
  List<Widget> _projects() => [
    for (var row = 0; row < 2; row++) ...[
      if (row > 0) const SizedBox(height: 16),
      SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var col = 0; col < 2; col++) ...[
              if (col > 0) const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FigmaAsset(
                        '494:2841',
                        'imgProjectCoverThumbnail${row * 2 + col == 0 ? '' : row * 2 + col}',
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      [
                        'Mây · App tài chính',
                        'FoodGo · Đặt món',
                        'Mộc Studio · Website',
                        'An Nhiên · Đặt lịch',
                      ][row * 2 + col],
                      style: authText(14, weight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  ];
  List<Widget> _reviews() => _gaps([
    for (final review in [
      (
        'Trần Hoàng Nam · 18/10/2026',
        'Thiết kế rõ ràng, bàn giao đầy đủ component. Tôi rất hài lòng với cách Minh Anh phối hợp.',
      ),
      (
        'Lê Thu Hà · 05/09/2026',
        'Chủ động đề xuất giải pháp, phản hồi nhanh và hoàn thành đúng thời hạn.',
      ),
    ])
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              review.$1,
              style: authText(
                12,
                weight: FontWeight.w500,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '★★★★★',
              style: authText(16, color: EmeraldColors.primaryDark),
            ),
            const SizedBox(height: 8),
            Text(review.$2, style: authText(14)),
          ],
        ),
      ),
    Text(
      '12 đánh giá · Điểm trung bình 4,9/5',
      style: authText(12, color: const Color(0xFF475569)),
    ),
  ], 16);
}

class TalentProjectContext extends StatelessWidget {
  const TalentProjectContext({
    required this.node,
    required this.title,
    required this.subtitle,
    super.key,
  });
  final String node, title, subtitle;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: ProfileTokens.border),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FigmaAsset(
            node,
            'imgProjectCoverThumbnail',
            width: 80,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: authText(13, weight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: authText(11, color: EmeraldColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TalentPill extends StatelessWidget {
  const TalentPill(this.label, {this.selected = false, this.onTap, super.key});
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: selected ? EmeraldColors.surfaceSubtle : Colors.white,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(999),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: authText(
            14,
            weight: FontWeight.w500,
            color: EmeraldColors.primaryDark,
          ),
        ),
      ),
    ),
  );
}

InputDecoration _input(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: authText(14, color: const Color(0xFF475569)),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.all(16),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
  ),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
);
List<Widget> _gaps(List<Widget> children, double gap) => [
  for (var i = 0; i < children.length; i++) ...[
    if (i > 0) SizedBox(height: gap),
    children[i],
  ],
];
