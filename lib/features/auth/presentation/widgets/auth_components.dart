import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/features/auth/presentation/widgets/auth_motion.dart';
export 'package:workly/features/auth/presentation/widgets/auth_feedback.dart';

/// Reference-only chrome for screenshot QA. Real app uses native OS bars.
class AuthDesignPreview extends InheritedWidget {
  const AuthDesignPreview({required super.child, super.key});
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthDesignPreview>() != null;
  @override
  bool updateShouldNotify(AuthDesignPreview oldWidget) => false;
}

TextStyle authText(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = EmeraldColors.textPrimary,
}) => TextStyle(
  fontFamily: 'Plus Jakarta Sans',
  fontSize: size,
  fontWeight: weight,
  height: 1.4,
  color: color,
);

class AuthPage extends StatelessWidget {
  const AuthPage({
    required this.child,
    this.title,
    this.trailing,
    this.contextHeader = false,
    this.onBack,
    this.action,
    this.background,
    this.dark = false,
    this.motion = true,
    super.key,
  });
  final Widget child;
  final String? title;
  final Widget? trailing;
  final bool contextHeader;
  final VoidCallback? onBack;
  final Widget? action;
  final Widget? background;
  final bool dark;
  final bool motion;
  @override
  Widget build(BuildContext context) {
    final preview = AuthDesignPreview.of(context);
    final insets = MediaQuery.viewPaddingOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final color = dark ? EmeraldColors.deep : EmeraldColors.background;
    final content = Column(
      children: [
        if (preview)
          _ReferenceStatus(dark: dark)
        else
          SizedBox(height: math.max(59, insets.top)),
        if (title != null)
          SizedBox(
            height: contextHeader ? 44 : 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      tooltip: 'Quay lại',
                      padding: const EdgeInsets.only(right: 16),
                      onPressed: onBack,
                      icon: const FigmaAsset(
                        '585:4320',
                        'imgEmerald2026NavigationIconBack',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title!,
                      style: authText(
                        contextHeader ? 13 : 18,
                        weight: contextHeader
                            ? FontWeight.w500
                            : FontWeight.w700,
                        color: contextHeader
                            ? EmeraldColors.textSecondary
                            : EmeraldColors.textPrimary,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ),
        Expanded(child: child),
        if (action != null)
          ColoredBox(
            color: dark ? Colors.transparent : EmeraldColors.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: action,
            ),
          ),
        if (preview)
          SizedBox(
            height: 34,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: dark ? Colors.white : EmeraldColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          )
        else
          SizedBox(height: keyboard ? 8 : math.max(34, insets.bottom)),
      ],
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: color,
          ),
      child: Scaffold(
        backgroundColor: color,
        body: Stack(
          fit: StackFit.expand,
          children: [
            ?background,
            motion ? AuthTimeline(child: content) : content,
          ],
        ),
      ),
    );
  }
}

class _ReferenceStatus extends StatelessWidget {
  const _ReferenceStatus({required this.dark});
  final bool dark;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 59,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(32, 14, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: authText(
              16,
              weight: FontWeight.w500,
              color: dark ? Colors.white : EmeraldColors.textPrimary,
            ),
          ),
          FigmaAsset(
            dark ? '584:259' : '585:4320',
            'imgTrngThaiThitB',
            width: 70,
            height: 12,
          ),
        ],
      ),
    ),
  );
}

class AuthScrollBody extends StatelessWidget {
  const AuthScrollBody({required this.children, this.gap = 12, super.key});
  final List<Widget> children;
  final double gap;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
    child: AuthEntrance(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    ),
  );
}

class AuthBrand extends StatelessWidget {
  const AuthBrand({this.node = '585:4320', this.size = 40, super.key});
  final String node;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: EmeraldColors.primary,
      borderRadius: BorderRadius.circular(size * 0.3125),
    ),
    child: FigmaAsset(
      node,
      'imgFrame',
      width: size * 0.65625,
      height: size * 0.65625,
    ),
  );
}

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    required this.title,
    required this.subtitle,
    this.node = '585:4320',
    super.key,
  });
  final String title;
  final String subtitle;
  final String node;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 72,
    child: Row(
      children: [
        AuthBrand(node: node),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: authText(21, weight: FontWeight.w700)),
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

/// Material button instances in auth use 12px radius/13 Medium, distinct from
/// the existing 593:4119 gradient button. These are sourced component variants.
class AuthAction extends StatelessWidget {
  const AuthAction({
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.busy = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final text = Text(
      label,
      style: authText(
        13,
        weight: FontWeight.w500,
        color: outlined
            ? EmeraldColors.primaryDark
            : onPressed == null
            ? EmeraldColors.textSecondary
            : Colors.white,
      ),
    );
    return SizedBox(
      width: double.infinity,
      height: outlined ? 44 : 52,
      child: outlined
          ? OutlinedButton(
              onPressed: busy ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: EmeraldColors.primaryDark,
                shape: shape,
                side: const BorderSide(color: AuthTokens.fieldBorder),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
              ),
              child: text,
            )
          : FilledButton(
              onPressed: busy ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: EmeraldColors.primaryDark,
                disabledBackgroundColor: EmeraldColors.primaryDark,
                shape: shape,
                side: const BorderSide(color: EmeraldColors.emerald600),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
              ),
              child: text,
            ),
    );
  }
}

abstract final class AuthTokens {
  static const fieldFill = Color(0xFFF8FAFC);
  static const fieldBorder = Color(0xFFE2E8F0);
  static const cyan = Color(0xFF22D3EE);
}

class AuthField extends StatelessWidget {
  const AuthField({
    required this.label,
    required this.controller,
    this.password = false,
    this.validator,
    this.keyboardType,
    this.onSubmitted,
    this.autofillHints,
    super.key,
  });
  final String label;
  final TextEditingController controller;
  final bool password;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: authText(
          13,
          weight: FontWeight.w500,
          color: EmeraldColors.textSecondary,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        obscureText: password,
        keyboardType: keyboardType,
        validator: validator,
        autofillHints: autofillHints,
        autocorrect: !password,
        enableSuggestions: !password,
        onFieldSubmitted: (_) => onSubmitted?.call(),
        style: authText(14),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AuthTokens.fieldFill,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AuthTokens.fieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AuthTokens.fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: EmeraldColors.primaryDark),
          ),
        ),
      ),
    ],
  );
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 24,
    child: Row(
      children: [
        const Expanded(child: Divider(color: ProfileTokens.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'hoặc',
            style: authText(14, color: EmeraldColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: ProfileTokens.border)),
      ],
    ),
  );
}

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({required this.onPressed, super.key});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: const BorderSide(color: ProfileTokens.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          const FigmaAsset('585:4320', 'imgRectangle', width: 20, height: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tiếp tục với Google',
              textAlign: TextAlign.center,
              style: authText(13, weight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}
