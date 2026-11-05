import 'package:flutter/material.dart';

/// Shared 2000ms cohort from the auth Figma motion context.
class AuthTimeline extends StatefulWidget {
  const AuthTimeline({required this.child, super.key});
  final Widget child;
  @override
  State<AuthTimeline> createState() => _AuthTimelineState();
}

class _AuthTimelineState extends State<AuthTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.75;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: widget.child,
    builder: (_, child) =>
        AuthMotionFrame(value: _controller.value, child: child!),
  );
}

class AuthMotionFrame extends InheritedWidget {
  const AuthMotionFrame({required this.value, required super.child, super.key});
  final double value;
  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthMotionFrame>()?.value ??
      0.75;
  @override
  bool updateShouldNotify(AuthMotionFrame oldWidget) =>
      value != oldWidget.value;
}

/// CSS ease-out is cubic-bezier(0,0,0.58,1), not Flutter's default easeOut.
abstract final class AuthMotionValues {
  static const easeOut = Cubic(0, 0, 0.58, 1);
  static const easeInOut = Cubic(0.42, 0, 0.58, 1);
  static double progress(double t, double end) =>
      easeOut.transform((t / end).clamp(0.0, 1.0));
  static double halo(double t) => t <= 0.325
      ? 0.92 + 0.13 * easeInOut.transform((t / 0.325).clamp(0.0, 1.0))
      : t <= 0.6
      ? 1.05 - 0.05 * easeInOut.transform(((t - 0.325) / 0.275).clamp(0.0, 1.0))
      : 1;
}

class AuthEntrance extends StatelessWidget {
  const AuthEntrance({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final t = AuthMotionFrame.of(context);
    return Opacity(
      opacity: AuthMotionValues.progress(t, 0.16),
      child: Transform.translate(
        offset: Offset(0, 12 * (1 - AuthMotionValues.progress(t, 0.18))),
        child: child,
      ),
    );
  }
}
