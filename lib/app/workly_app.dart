import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workly/app/app_dependencies.dart';
import 'package:workly/app/router/app_router.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';

class WorklyApp extends StatefulWidget {
  const WorklyApp({required this.dependencies, super.key});
  final AppDependencies dependencies;
  @override
  State<WorklyApp> createState() => _WorklyAppState();
}

class _WorklyAppState extends State<WorklyApp> {
  late final SessionViewModel _session;
  late final GoRouter _router;
  late final AuthFlowViewModel _auth;
  @override
  void initState() {
    super.initState();
    _session = SessionViewModel(widget.dependencies.sessionRepository);
    _auth = AuthFlowViewModel(widget.dependencies.sessionRepository, _session);
    _router = createAppRouter(
      _session,
      _auth,
      widget.dependencies.marketplaceRepository,
    );
    unawaited(_session.initialize());
  }

  @override
  void dispose() {
    _router.dispose();
    _auth.dispose();
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Workly',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: _router,
  );
}
