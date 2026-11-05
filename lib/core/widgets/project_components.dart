import 'package:flutter/material.dart';
import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/workly_button.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/projects/domain/project_repository.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({
    required this.title,
    required this.onBack,
    required this.onHome,
    required this.child,
    this.action,
    this.contextHeader = false,
    super.key,
  });
  final String title;
  final VoidCallback onBack, onHome;
  final Widget child;
  final Widget? action;
  final bool contextHeader;
  @override
  Widget build(BuildContext context) => AuthPage(
    title: title,
    onBack: onBack,
    contextHeader: contextHeader,
    motion: false,
    trailing: IconButton(
      tooltip: 'Trang chủ',
      onPressed: onHome,
      icon: const FigmaAsset(
        '585:4950',
        'imgEmerald2026NavigationIconHome',
        width: 24,
        height: 24,
      ),
    ),
    action: action,
    child: child,
  );
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.children,
    this.gap = 12,
    this.color = Colors.white,
    this.padding = 16,
    super.key,
  });
  final List<Widget> children;
  final double gap, padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: ProfileTokens.border),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    ),
  );
}

class ProjectNotice extends StatelessWidget {
  const ProjectNotice(
    this.message, {
    this.heading,
    this.check = true,
    super.key,
  });
  final String message;
  final String? heading;
  final bool check;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: EmeraldColors.surfaceSubtle,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (heading != null) ...[
          Text(
            heading!,
            style: authText(
              13,
              weight: FontWeight.w500,
              color: EmeraldColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (check) ...[
              const FigmaAsset(
                '585:4950',
                'imgProfileIconCheck',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: authText(
                  heading == null ? 13 : 11,
                  weight: heading == null ? FontWeight.w500 : FontWeight.w400,
                  color: heading == null
                      ? EmeraldColors.primaryDark
                      : EmeraldColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// F17 / F37A solid source action, distinct from the gradient proposal variant.
class ProjectAction extends StatelessWidget {
  const ProjectAction({
    required this.label,
    required this.onPressed,
    this.outline = false,
    this.solid = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool outline, solid;
  @override
  Widget build(BuildContext context) {
    if (!outline && !solid && onPressed != null) {
      return WorklyButton(label: label, onPressed: onPressed!, labelSize: 14);
    }
    return SizedBox(
      width: double.infinity,
      height: outline ? 44 : 52,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: outline ? EmeraldColors.primaryDark : Colors.white,
          backgroundColor: outline ? Colors.white : EmeraldColors.primaryDark,
          disabledForegroundColor: EmeraldColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: outline
                ? const BorderSide(color: Color(0xFFE2E8F0))
                : BorderSide.none,
          ),
          textStyle: authText(13, weight: FontWeight.w500),
        ),
        child: Text(label),
      ),
    );
  }
}

class ProjectIdentity extends StatelessWidget {
  const ProjectIdentity(
    this.project, {
    this.width = 80,
    this.height = 64,
    this.fontSize = 13,
    this.node,
    this.slot,
    super.key,
  });
  final Project project;
  final double width, height, fontSize;
  final String? node, slot;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(width == 112 ? 20 : 12),
        child: FigmaAsset(
          node ?? project.imageNode,
          slot ?? project.imageSlot,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          project.title,
          style: authText(
            fontSize,
            weight: fontSize == 18 ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

String formatDong(int value) => jobMoney(value).replaceAll("₫", "đ");
