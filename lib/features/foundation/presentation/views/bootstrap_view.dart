import 'package:flutter/material.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

/// Blank foundation host, not F01 or a redesigned product screen.
/// Product views and loading/error UI await structure review.
class BootstrapView extends StatelessWidget {
  const BootstrapView({required this.session, super.key});
  final SessionViewModel session;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: session,
    builder: (_, _) => Scaffold(
      body: SizedBox.expand(key: ValueKey('bootstrap-${session.status.name}')),
    ),
  );
}
