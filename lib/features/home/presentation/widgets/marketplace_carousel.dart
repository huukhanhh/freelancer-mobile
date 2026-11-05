import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';

/// Source variants: 3000ms hold, 720ms ease-out slide; repeated first image
/// holds 900ms, then resets seamlessly (source dissolve 30ms).
class MarketplaceCarousel extends StatefulWidget {
  const MarketplaceCarousel({
    required this.client,
    required this.node,
    this.onExplore,
    super.key,
  });
  final bool client;
  final String node;
  final VoidCallback? onExplore;
  @override
  State<MarketplaceCarousel> createState() => _MarketplaceCarouselState();
}

class _MarketplaceCarouselState extends State<MarketplaceCarousel> {
  final _pages = PageController();
  Timer? _timer;
  int _slide = 0;
  bool _reduced = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.disableAnimationsOf(context);
    _timer?.cancel();
    if (!_reduced) _schedule();
  }

  void _schedule() {
    _timer = Timer(Duration(milliseconds: _slide == 3 ? 900 : 3000), () async {
      if (!mounted || !_pages.hasClients) return;
      if (_slide == 3) {
        _pages.jumpToPage(0);
        setState(() => _slide = 0);
      } else {
        await _pages.animateToPage(
          _slide + 1,
          duration: const Duration(milliseconds: 720),
          curve: const Cubic(0, 0, .58, 1),
        );
        if (!mounted) return;
        setState(() => _slide++);
      }
      if (!_reduced) _schedule();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 176,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: PageView.builder(
            controller: _pages,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => _Banner(
              client: widget.client,
              node: widget.node,
              index: index % 3,
              onExplore: widget.onExplore,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Container(
                width: _slide % 3 == i ? 20 : 4,
                height: 4,
                decoration: BoxDecoration(
                  color: i == _slide % 3
                      ? EmeraldColors.deep
                      : EmeraldColors.primaryDark,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.client,
    required this.node,
    required this.index,
    this.onExplore,
  });
  final bool client;
  final String node;
  final int index;
  final VoidCallback? onExplore;
  @override
  Widget build(BuildContext context) {
    final light = client ? index != 1 : index != 0;
    final background = !client && index == 2
        ? const Color(0xFFFFE6D4)
        : light
        ? const Color(0xFFFFF4E3)
        : EmeraldColors.deep;
    final ink = light ? EmeraldColors.deep : Colors.white;
    final headline = client
        ? [
            'Người giỏi.\nDự án tốt.',
            'Tìm dev giỏi.\nBắt đầu ngay.',
            'Ý tưởng lớn.\nCần designer.',
          ][index]
        : [
            'Việc hay\nđang chờ bạn.',
            'Code giỏi.\nViệc xứng tầm.',
            'Sáng tạo hay.\nCơ hội mới.',
          ][index];
    return LayoutBuilder(
      builder: (context, box) => Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: background),
          Positioned(
            left: box.maxWidth * 140 / 354,
            top: 0,
            bottom: 0,
            right: 0,
            child: FigmaAsset(
              node,
              'imgAdvertisementHeroPhotograph${index == 0 ? '' : index}',
              fit: BoxFit.cover,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  background,
                  background,
                  background.withValues(alpha: 0),
                  background.withValues(alpha: 0),
                ],
                stops: const [0, .5, .66, 1],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 28,
            bottom: 28,
            width: box.maxWidth * 210 / 354,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headline,
                  style: authText(
                    26 * (box.maxWidth / 354).clamp(.75, 1.0),
                    weight: FontWeight.w700,
                    color: ink,
                  ).copyWith(height: 30 / 26, letterSpacing: -.52),
                ),
                Material(
                  color: light ? EmeraldColors.deep : const Color(0xFFE0F5AA),
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    onTap: onExplore,
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      width: 148,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              client ? 'Tìm freelancer' : 'Khám phá ngay',
                              style: authText(
                                11,
                                weight: FontWeight.w700,
                                color: light
                                    ? Colors.white
                                    : EmeraldColors.deep,
                              ).copyWith(height: 16 / 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FigmaAsset(
                            node,
                            (client ? light : !light)
                                ? 'imgMarketplaceBannerIconArrowUpRight'
                                : 'imgMarketplaceBannerIconArrowUpRight1',
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
