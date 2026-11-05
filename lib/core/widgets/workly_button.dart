import 'package:flutter/material.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/core/theme/design_tokens.dart';

enum WorklyButtonStyle { primary, warm, secondary, dark }

/// Figma 593:4119: four observed Default-state variants.
/// Disabled/loading designs await source verification.
class WorklyButton extends StatelessWidget {
  const WorklyButton({
    required this.label,
    required this.onPressed,
    this.style = WorklyButtonStyle.primary,
    this.height = ButtonTokens.height,
    this.labelSize = ButtonTokens.labelSize,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final WorklyButtonStyle style;
  final double height, labelSize;
  @override
  Widget build(BuildContext context) {
    final colors = switch (style) {
      WorklyButtonStyle.primary => [EmeraldColors.primary, EmeraldColors.teal],
      WorklyButtonStyle.warm => [EmeraldColors.coral, EmeraldColors.amber],
      WorklyButtonStyle.dark => [EmeraldColors.deep, EmeraldColors.emerald600],
      WorklyButtonStyle.secondary => <Color>[],
    };
    final secondary = style == WorklyButtonStyle.secondary;
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: secondary ? EmeraldColors.surfaceSubtle : null,
          borderRadius: BorderRadius.circular(ButtonTokens.radius),
          gradient: secondary
              ? null
              : LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: colors,
                  transform: const _FigmaButtonGradient(),
                ),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(0, height),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ButtonTokens.radius),
            ),
            foregroundColor: secondary
                ? EmeraldColors.primaryDark
                : EmeraldColors.surface,
            textStyle: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: labelSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

/// Figma normalized gradientTransform from component 593:4111.
/// Convert it to pixel coordinates and invert for Flutter's shader transform.
class _FigmaButtonGradient extends GradientTransform {
  const _FigmaButtonGradient();

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final width = bounds.width;
    final height = bounds.height;
    if (width <= 0 || height <= 0) return Matrix4.identity();
    final crossX = -0.7070000171661377 * width / height;
    final crossY = 0.7070000171661377 * height / width;
    final matrix = Matrix4.identity()
      ..setEntry(0, 0, 0.7070000171661377)
      ..setEntry(0, 1, crossX)
      ..setEntry(
        0,
        3,
        bounds.left * (1 - 0.7070000171661377) -
            crossX * bounds.top +
            0.5 * width,
      )
      ..setEntry(1, 0, crossY)
      ..setEntry(1, 1, 0.7070000171661377)
      ..setEntry(
        1,
        3,
        bounds.top * (1 - 0.7070000171661377) -
            crossY * bounds.left -
            0.20000000298023224 * height,
      );
    matrix.invert();
    return matrix;
  }
}
