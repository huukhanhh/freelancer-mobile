import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_motion.dart';

class SplashView extends StatefulWidget {
  const SplashView({
    required this.onReady,
    this.delay = const Duration(milliseconds: 1600),
    super.key,
  });
  final VoidCallback onReady;
  final Duration delay;
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, widget.onReady);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthPage(
    dark: true,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Center(
        child: SingleChildScrollView(child: const _SplashContent()),
      ),
    ),
  );
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();
  @override
  Widget build(BuildContext context) {
    final t = AuthMotionFrame.of(context);
    return AuthEntrance(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 188,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: AuthMotionValues.halo(t),
                  child: const FigmaAsset(
                    '584:259',
                    'imgSplashBreathingHalo',
                    width: 176,
                    height: 176,
                  ),
                ),
                Transform.scale(
                  scale: 0.84 + 0.16 * AuthMotionValues.progress(t, 0.325),
                  child: const AuthBrand(node: '584:259', size: 112),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'workly',
            style: authText(32, weight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Kết nối tài năng. Mở lối cơ hội.',
            textAlign: TextAlign.center,
            style: authText(14, color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 24,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final part in <(double, Color)>[
                    (52, EmeraldColors.primary),
                    (28, AuthTokens.cyan),
                    (24, EmeraldColors.primaryDark),
                  ]) ...[
                    if (part.$1 != 52) const SizedBox(width: 4),
                    Container(
                      width: part.$1,
                      height: 4,
                      decoration: BoxDecoration(
                        color: part.$2,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
