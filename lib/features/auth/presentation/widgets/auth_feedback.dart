import 'package:flutter/material.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';

/// Accessible validation copy. No toast, overlay or new product destination.
class AuthFeedback extends StatelessWidget {
  const AuthFeedback({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Text(
      message,
      style: authText(11, color: Theme.of(context).colorScheme.error),
    ),
  );
}
