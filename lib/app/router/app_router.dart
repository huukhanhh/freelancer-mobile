import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workly/features/foundation/presentation/views/bootstrap_view.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

abstract final class AppRoutes {
  static const bootstrap = '/bootstrap';
}

/// Add product routes and role guards per approved Figma module.
GoRouter createAppRouter(SessionViewModel session) => GoRouter(
  initialLocation: AppRoutes.bootstrap,
  refreshListenable: session,
  routes: [
    GoRoute(path: '/', redirect: (_, _) => AppRoutes.bootstrap),
    GoRoute(
      path: AppRoutes.bootstrap,
      name: 'bootstrap',
      builder: (_, _) => BootstrapView(session: session),
    ),
  ],
  // No invented system error screen before its module is implemented.
  errorBuilder: (_, _) => const Scaffold(body: SizedBox.expand()),
);
