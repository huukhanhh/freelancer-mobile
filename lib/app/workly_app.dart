import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workly/app/app_dependencies.dart';
import 'package:workly/app/router/app_router.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

class WorklyApp extends StatefulWidget {
  const WorklyApp({required this.dependencies, super.key});
  final AppDependencies dependencies;
  @override
  State<WorklyApp> createState() => _WorklyAppState();
}

class _WorklyAppState extends State<WorklyApp> {
  late final SessionViewModel _session;
  late final GoRouter _router;
  @override
  void initState() {
    super.initState();
    _session = SessionViewModel(widget.dependencies.sessionRepository);
    _router = createAppRouter(_session);
    unawaited(_session.initialize());
  }

  @override
  void dispose() {
    _router.dispose();
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
