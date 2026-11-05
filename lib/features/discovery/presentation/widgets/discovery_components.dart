import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/role_bottom_bar.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';

abstract final class DiscoveryColors {
  static const muted = Color(0xFF71857D),
      metadata = Color(0xFFF3FAF6),
      metadataText = Color(0xFF506E62);
}

TextStyle discoveryText(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = EmeraldColors.textPrimary,
}) => authText(size, weight: weight, color: color).copyWith(height: 1.2);

class DiscoveryScaffold extends StatelessWidget {
  const DiscoveryScaffold({
    required this.node,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.child,
    required this.onHome,
    this.search,
    super.key,
  });
  final String node, title, subtitle;
  final VoidCallback onBack, onHome;
  final Widget child;
  final Widget? search;
  @override
  Widget build(BuildContext context) {
    final preview = AuthDesignPreview.of(context);
    final extra = preview
        ? 0.0
        : math.max(0.0, MediaQuery.viewPaddingOf(context).top - 34);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: EmeraldColors.background,
        body: Column(
          children: [
            ColoredBox(
              color: Colors.white,
              child: SizedBox(
                height: 116 + extra,
                child: Stack(
                  children: [
                    if (preview) ...[
                      Positioned(
                        left: 20,
                        top: 11,
                        child: Text(
                          '9:41',
                          style: discoveryText(12, weight: FontWeight.w700),
                        ),
                      ),
                      Positioned(
                        right: 20,
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
                      left: 10,
                      top: 48 + extra,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          tooltip: 'Quay lại',
                          onPressed: onBack,
                          icon: FigmaAsset(
                            node,
                            'imgLucideBack',
                            width: 23,
                            height: 23,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 56,
                      right: 18,
                      top: 60 + extra,
                      child: Text(
                        title,
                        style: discoveryText(18, weight: FontWeight.w700),
                      ),
                    ),
                    Positioned(
                      left: 56,
                      right: 18,
                      top: 87 + extra,
                      child: Text(
                        subtitle,
                        style: discoveryText(11, color: DiscoveryColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (search != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 5, 18, 0),
                child: search,
              ),
            Expanded(child: child),
            RoleBottomBar(
              client: false,
              node: node,
              preview: preview,
              selectedIndex: 1,
              onTab: (index) {
                if (index == 0) onHome();
              },
              enabledIndices: const {0},
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverySearchBar extends StatelessWidget {
  const DiscoverySearchBar({
    required this.node,
    required this.hint,
    required this.onFilter,
    this.controller,
    this.onOpen,
    this.onSubmit,
    super.key,
  });
  final String node, hint;
  final VoidCallback onFilter;
  final TextEditingController? controller;
  final VoidCallback? onOpen;
  final ValueChanged<String>? onSubmit;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 4,
    shadowColor: EmeraldColors.deep.withValues(alpha: .11),
    borderRadius: BorderRadius.circular(17),
    child: SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 7),
        child: Row(
          children: [
            InkWell(
              onTap: controller == null
                  ? onOpen
                  : () => onSubmit?.call(controller!.text),
              child: FigmaAsset(node, 'imgLucideSearch', width: 22, height: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: controller == null
                  ? InkWell(
                      onTap: onOpen,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: discoveryText(
                            12,
                            color: DiscoveryColors.muted,
                          ),
                        ),
                      ),
                    )
                  : TextField(
                      controller: controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: onSubmit,
                      style: discoveryText(12),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: discoveryText(
                          12,
                          color: DiscoveryColors.muted,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
            ),
            Material(
              color: EmeraldColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onFilter,
                child: SizedBox(
                  width: 38,
                  height: 36,
                  child: Center(
                    child: FigmaAsset(
                      node,
                      'imgLucideFilter',
                      width: 20,
                      height: 20,
                    ),
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

class DiscoveryChip extends StatelessWidget {
  const DiscoveryChip({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.width,
    super.key,
  });
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final double? width;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: onTap != null,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? null : EmeraldColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(15),
        gradient: selected
            ? const LinearGradient(
                colors: [EmeraldColors.primary, EmeraldColors.teal],
              )
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: width,
            constraints: const BoxConstraints(minHeight: 30),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            child: Text(
              label,
              style: discoveryText(
                10,
                weight: FontWeight.w700,
                color: selected ? Colors.white : EmeraldColors.primaryDark,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class DiscoveryJobCard extends StatelessWidget {
  const DiscoveryJobCard({
    required this.job,
    required this.saved,
    required this.onSave,
    this.onOpen,
    super.key,
  });
  final Job job;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback? onOpen;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 3,
    shadowColor: EmeraldColors.deep.withValues(alpha: .11),
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 96),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: FigmaAsset(
                      job.imageNode,
                      job.imageSlot,
                      width: 104,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            job.title,
                            style: discoveryText(14, weight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          job.client,
                          style: discoveryText(
                            11,
                            color: const Color(0xFF6B7D74),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          jobMoney(job.budget),
                          style: discoveryText(
                            15,
                            weight: FontWeight.w700,
                            color: EmeraldColors.emerald600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    child: Semantics(
                      excludeSemantics: true,
                      container: true,
                      onTap: onSave,
                      label: saved ? 'Bỏ lưu ${job.title}' : 'Lưu ${job.title}',
                      toggled: saved,
                      button: true,
                      child: InkWell(
                        onTap: onSave,
                        child: Text(
                          saved ? '♥' : '♡',
                          style:
                              discoveryText(
                                21,
                                weight: FontWeight.w700,
                                color: EmeraldColors.emerald600,
                              ).copyWith(
                                fontFamily: 'Noto Sans Symbols 2',
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 11),
            Container(
              constraints: const BoxConstraints(minHeight: 35),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: DiscoveryColors.metadata,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${job.skills.join(' • ')} • ${job.days} ngày',
                style: discoveryText(11, color: DiscoveryColors.metadataText),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
