import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/role_bottom_bar.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/home/domain/marketplace_repository.dart';
import 'package:workly/features/home/presentation/view_models/home_view_model.dart';
import 'package:workly/features/home/presentation/widgets/marketplace_carousel.dart';

/// Source-based home composition. Callbacks are intentionally optional while
/// downstream modules are pending; do not route to fabricated product screens.
class HomeView extends StatelessWidget {
  const HomeView({
    required this.model,
    this.onSearch,
    this.onFilter,
    this.onExplore,
    this.onWorkspace,
    this.onCategory,
    this.onListing,
    this.onTab,
    super.key,
  });
  final HomeViewModel model;
  final VoidCallback? onSearch, onFilter, onExplore, onWorkspace;
  final ValueChanged<String>? onCategory, onListing;
  final ValueChanged<int>? onTab;
  @override
  Widget build(BuildContext context) {
    final client = model.client;
    final node = model.source;
    final preview = AuthDesignPreview.of(context);
    final extra = preview
        ? 0.0
        : math.max(0.0, MediaQuery.viewPaddingOf(context).top - 34);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: EmeraldColors.background,
        body: Column(
          children: [
            SizedBox(
              height: 191 + extra,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 167 + extra,
                    child: const DecoratedBox(
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
                    right: -56,
                    top: -60,
                    child: Container(
                      width: 170,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA3E635).withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(85),
                      ),
                    ),
                  ),
                  if (preview) ...[
                    Positioned(
                      left: 23,
                      top: 10,
                      child: Text(
                        '9:41',
                        style: authText(
                          12,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ).copyWith(height: 1.2),
                      ),
                    ),
                    Positioned(
                      right: 21,
                      top: 11,
                      child: FigmaAsset(
                        node,
                        'imgNavigationVectorSystemStatus',
                        width: 74,
                        height: 14,
                      ),
                    ),
                  ],
                  Positioned(
                    left: 20,
                    top: 49 + extra,
                    right: 86,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHÀO ${model.user.displayName.isEmpty ? (client ? 'HUY' : 'MINH ANH') : model.user.displayName.toUpperCase()} 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: authText(
                            11,
                            weight: FontWeight.w700,
                            color: const Color(0xFFD1FAE5),
                          ).copyWith(height: 1.2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          client ? 'Chợ freelancer' : 'Chợ việc làm',
                          style: authText(
                            25,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ).copyWith(height: 1.2),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          client
                              ? 'Tìm đúng người, hoàn thành đúng hạn'
                              : 'Cơ hội hay, thu nhập xứng đáng',
                          style: authText(
                            11,
                            color: const Color(0xFFD1FAE5),
                          ).copyWith(height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 54 + extra,
                    child: FigmaAsset(
                      node,
                      'imgPersonRealPhotograph',
                      width: 46,
                      height: 46,
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    top: 127 + extra,
                    height: 53,
                    child: Material(
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: EmeraldColors.deep.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(17),
                      child: InkWell(
                        onTap: onSearch,
                        borderRadius: BorderRadius.circular(17),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13, right: 9),
                          child: Row(
                            children: [
                              FigmaAsset(
                                node,
                                'imgLucideSearch',
                                width: 21,
                                height: 21,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  client
                                      ? 'Tìm freelancer, kỹ năng...'
                                      : 'Tìm công việc, công nghệ...',
                                  style: authText(
                                    12,
                                    color: HomeTokens.muted,
                                  ).copyWith(height: 1.2),
                                ),
                              ),
                              Material(
                                color: EmeraldColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: onFilter,
                                  child: SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: Center(
                                      child: FigmaAsset(
                                        node,
                                        'imgLucideSliders',
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                children: [
                  _Section(
                    title: 'Khám phá danh mục',
                    trailing: 'Tất cả →',
                    onTap: onExplore,
                    child: _Categories(
                      client: client,
                      node: node,
                      onTap: onCategory,
                    ),
                  ),
                  const SizedBox(height: 29),
                  _Section(
                    title: client
                        ? 'Khám phá freelancer'
                        : 'Khám phá cơ hội mới',
                    child: MarketplaceCarousel(
                      client: client,
                      node: node,
                      onExplore: onExplore,
                    ),
                  ),
                  const SizedBox(height: 38),
                  _Section(
                    title: client
                        ? 'Kỹ năng đang được săn đón'
                        : 'Công nghệ được tìm nhiều',
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < 4; i++)
                          Material(
                            color: HomeTokens.skillColors[i],
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              onTap: onCategory == null
                                  ? null
                                  : () => onCategory!(
                                      [
                                        'React',
                                        'Flutter',
                                        'Python',
                                        'Figma',
                                      ][i],
                                    ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Text(
                                  ['React', 'Flutter', 'Python', 'Figma'][i],
                                  style: authText(
                                    11,
                                    weight: FontWeight.w700,
                                    color: EmeraldColors.primaryDark,
                                  ).copyWith(height: 1.2),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _Section(
                    title: client
                        ? 'Freelancer dành cho bạn'
                        : 'Việc làm phù hợp',
                    trailing: 'Xem tất cả →',
                    onTap: onExplore,
                    child: Column(
                      children: [
                        for (var i = 0; i < model.listings.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _ListingCard(
                            node: node,
                            client: client,
                            listing: model.listings[i],
                            onTap: onListing == null
                                ? null
                                : () => onListing!(model.listings[i].id),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [EmeraldColors.deep, EmeraldColors.emerald600],
                      ),
                    ),
                    child: InkWell(
                      onTap: client ? onWorkspace : onExplore,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client
                                  ? 'Dự án của bạn, trong tầm tay'
                                  : 'Khám phá thêm hàng trăm dự án',
                              style: authText(
                                17,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              client
                                  ? 'Theo dõi proposal & milestone dễ dàng'
                                  : 'Bộ lọc thông minh giúp bạn tìm nhanh',
                              style: authText(
                                11,
                                color: const Color(0xFFD1FAE5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RoleBottomBar(
              client: client,
              node: node,
              onTab: onTab,
              enabledIndices: client ? const {0, 2} : const {0, 1, 4},
              preview: preview,
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class HomeTokens {
  static const muted = Color(0xFF71857D),
      categoryText = Color(0xFF315347),
      gold = Color(0xFFB7791F);
  static const skillColors = [
    Color(0xFFE9F8F0),
    Color(0xFFE4F4FF),
    Color(0xFFF0EDFF),
    Color(0xFFFFF5E8),
  ];
  static const categoryColors = [
    Color(0xFFD1FAE5),
    Color(0xFFDBF5FC),
    Color(0xFFEDE9FE),
    Color(0xFFF2FCE7),
  ];
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.trailing,
    this.onTap,
  });
  final String title;
  final Widget child;
  final String? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: authText(
                17,
                weight: FontWeight.w700,
              ).copyWith(height: 1.2),
            ),
          ),
          if (trailing != null)
            InkWell(
              onTap: onTap,
              child: Text(
                trailing!,
                style: authText(
                  10,
                  weight: FontWeight.w700,
                  color: EmeraldColors.emerald600,
                ).copyWith(height: 1.2),
              ),
            ),
        ],
      ),
      const SizedBox(height: 14),
      child,
    ],
  );
}

class _Categories extends StatelessWidget {
  const _Categories({required this.client, required this.node, this.onTap});
  final bool client;
  final String node;
  final ValueChanged<String>? onTap;
  static const _names = [
    'Thiết kế',
    'Lập trình',
    'Mobile',
    'AI / Data',
    'Marketing',
    'Video',
    'Content',
    'Dịch thuật',
  ];
  static const _slots = [
    'Palette',
    'Code',
    'Mobile',
    'Ai',
    'Marketing',
    'Video',
    'Pen',
    'Language',
  ];
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var row = 0; row < 2; row++) ...[
        if (row > 0) const SizedBox(height: 6),
        Row(
          children: [
            for (var col = 0; col < 4; col++) ...[
              if (col > 0) const SizedBox(width: 6),
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onTap == null
                        ? null
                        : () => onTap!(_names[row * 4 + col]),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 62),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Container(
                              width: 31,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: HomeTokens.categoryColors[col],
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: FigmaAsset(
                                node,
                                'imgLucide${_slots[row * 4 + col]}',
                                width: 22,
                                height: 22,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              client && row == 0 && col == 0
                                  ? 'UI/UX'
                                  : _names[row * 4 + col],
                              textAlign: TextAlign.center,
                              style: authText(
                                10,
                                weight: FontWeight.w700,
                                color: HomeTokens.categoryText,
                              ).copyWith(height: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    ],
  );
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({
    required this.node,
    required this.client,
    required this.listing,
    this.onTap,
  });
  final String node;
  final bool client;
  final MarketplaceListing listing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    elevation: 2,
    shadowColor: EmeraldColors.deep.withValues(alpha: .1),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: FigmaAsset(
                node,
                listing.imageSlot,
                width: client ? 72 : 88,
                height: client ? 72 : 93,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: authText(
                      client ? 15 : 14,
                      weight: FontWeight.w700,
                    ).copyWith(height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    listing.subtitle,
                    style: authText(
                      11,
                      color: HomeTokens.muted,
                    ).copyWith(height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  if (client) ...[
                    Row(
                      children: [
                        Text(
                          listing.score,
                          style: authText(
                            11,
                            weight: FontWeight.w700,
                            color: HomeTokens.gold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          listing.price,
                          style: authText(
                            11,
                            weight: FontWeight.w700,
                            color: EmeraldColors.emerald600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: EmeraldColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'Sẵn sàng nhận việc',
                        style: authText(
                          11,
                          weight: FontWeight.w700,
                          color: EmeraldColors.primaryDark,
                        ).copyWith(height: 1.2),
                      ),
                    ),
                  ] else ...[
                    Text(
                      listing.price,
                      style: authText(
                        16,
                        weight: FontWeight.w700,
                        color: EmeraldColors.emerald600,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4DA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          listing.score,
                          style: authText(
                            11,
                            weight: FontWeight.w700,
                            color: HomeTokens.gold,
                          ).copyWith(height: 1.2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
