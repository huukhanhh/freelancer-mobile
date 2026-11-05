import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';

class RoleBottomBar extends StatelessWidget {
  const RoleBottomBar({
    required this.client,
    required this.node,
    required this.preview,
    this.onTab,
    this.selectedIndex = 0,
    this.enabledIndices = const {0, 1},
    super.key,
  });
  final bool client, preview;
  final int selectedIndex;
  final Set<int> enabledIndices;
  final String node;
  final ValueChanged<int>? onTab;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      border: Border.fromBorderSide(
        BorderSide(color: EmeraldColors.surfaceSubtle),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              for (var i = 0; i < 5; i++)
                Expanded(
                  child: InkWell(
                    onTap: onTab == null || !enabledIndices.contains(i)
                        ? null
                        : () => onTab!(i),
                    child: SizedBox(
                      height: 64,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: i == selectedIndex
                                  ? EmeraldColors.surfaceSubtle
                                  : null,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: FigmaAsset(
                              node,
                              i == 0
                                  ? 'imgEmerald2026NavigationIconHome'
                                  : 'imgIcon${i == 1 ? '' : i - 1}',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (client
                                ? [
                                    'Trang chủ',
                                    'Dự án',
                                    'Freelancer',
                                    'Tin nhắn',
                                    'Cá nhân',
                                  ]
                                : [
                                    'Trang chủ',
                                    'Tìm việc',
                                    'Công việc',
                                    'Tin nhắn',
                                    'Cá nhân',
                                  ])[i],
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: i == selectedIndex
                                  ? EmeraldColors.primaryDark
                                  : EmeraldColors.textSecondary,
                            ).copyWith(height: 16 / 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: math.max(34, MediaQuery.viewPaddingOf(context).bottom),
          child: preview
              ? Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: EmeraldColors.textPrimary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                )
              : null,
        ),
      ],
    ),
  );
}
