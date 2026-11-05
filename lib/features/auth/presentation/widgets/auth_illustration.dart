import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    required this.node,
    this.confirmed = false,
    this.recovery = false,
    super.key,
  });
  final String node;
  final bool confirmed, recovery;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: confirmed
        ? 144
        : recovery
        ? 112
        : 104,
    child: Center(
      child: Container(
        width: confirmed
            ? 112
            : recovery
            ? 96
            : 88,
        height: confirmed
            ? 112
            : recovery
            ? 96
            : 88,
        decoration: BoxDecoration(
          color: EmeraldColors.surfaceSubtle,
          shape: BoxShape.circle,
          boxShadow: confirmed
              ? [
                  BoxShadow(
                    color: EmeraldColors.primary.withValues(alpha: .12),
                    offset: const Offset(0, 6),
                    blurRadius: 32,
                  ),
                  BoxShadow(
                    color: EmeraldColors.primary.withValues(alpha: .28),
                    blurRadius: 18,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: confirmed
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: EmeraldColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FigmaAsset(
                      node,
                      'imgProfileIconCheck',
                      width: 44,
                      height: 44,
                    ),
                  ),
                )
              : FigmaAsset(
                  node,
                  'imgFrame',
                  width: recovery ? 48 : 44,
                  height: recovery ? 48 : 44,
                ),
        ),
      ),
    ),
  );
}
