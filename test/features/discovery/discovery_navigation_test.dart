import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:workly/app/router/app_router.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/discovery/data/mock_job_repository.dart';
import 'package:workly/features/discovery/presentation/view_models/discovery_view_model.dart';
import 'package:workly/features/discovery/presentation/views/job_discovery_view.dart';
import 'package:workly/features/discovery/presentation/views/job_filter_view.dart';
import 'package:workly/features/home/data/mock_marketplace_repository.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

class Fixture {
  Fixture({bool client = false, String initial = AppRoutes.jobs}) {
    final repo = MockSessionRepository(
      session: client ? DemoAccounts.client : DemoAccounts.freelancer,
    );
    session = SessionViewModel(repo);
    auth = AuthFlowViewModel(repo, session);
    jobs = DiscoveryViewModel(MockJobRepository());
    router = createAppRouter(
      session,
      auth,
      const MockMarketplaceRepository(),
      initialLocation: initial,
      discovery: jobs,
    );
  }
  late final SessionViewModel session;
  late final AuthFlowViewModel auth;
  late final DiscoveryViewModel jobs;
  late final GoRouter router;
  Future<void> mount(WidgetTester tester) async {
    await session.initialize();
    await jobs.initialize();
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    auth.dispose();
    session.dispose();
    jobs.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader(AppTheme.fontFamily)
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans.ttf'));
    await font.load();
    final symbols = FontLoader('Noto Sans Symbols 2')
      ..addFont(rootBundle.load('assets/fonts/NotoSansSymbols2-Regular.ttf'));
    await symbols.load();
  });
  testWidgets(
    'home search submits real input, displays source empty state and recovers through suggestions',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final f = Fixture(initial: AppRoutes.freelancerHome);
      await f.mount(tester);
      await tester.tap(find.text('Tìm công việc, công nghệ...'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Python');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.byType(EmptyDiscoveryView), findsOneWidget);
      await tester.ensureVisible(find.text('React'));
      await tester.tap(find.text('React'));
      await tester.pumpAndSettle();
      expect(
        f.router.routeInformationProvider.value.uri.path,
        AppRoutes.jobResults,
      );
      expect(find.byType(JobDiscoveryView), findsOneWidget);
      expect(f.jobs.results.every((j) => j.skills.contains('React')), isTrue);
      expect(tester.takeException(), isNull);
      await f.close(tester);
    },
  );
  testWidgets(
    'filter reset/apply count agrees with data and favorites persist across routes',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final f = Fixture(initial: AppRoutes.jobFilter);
        await f.mount(tester);
        await tester.tap(find.text('Đặt lại'));
        await tester.pumpAndSettle();
        final apply = find.text('Xem 24 dự án phù hợp');
        await tester.ensureVisible(apply);
        await tester.tap(apply);
        await tester.pumpAndSettle();
        expect(f.jobs.results.length, 24);
        final save = find.bySemanticsLabel('Lưu Flutter E-commerce App');
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(f.jobs.saved, {'job-demo-1'});
        f.router.go(AppRoutes.jobs);
        await tester.pumpAndSettle();
        f.router.go(AppRoutes.jobResults);
        await tester.pumpAndSettle();
        expect(
          find.bySemanticsLabel('Bỏ lưu Flutter E-commerce App'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await f.close(tester);
      } finally {
        semantics.dispose();
      }
    },
  );
  testWidgets('Client cannot enter Freelancer discovery deep links', (
    tester,
  ) async {
    final f = Fixture(client: true);
    await f.mount(tester);
    expect(
      f.router.routeInformationProvider.value.uri.path,
      AppRoutes.clientHome,
    );
    expect(tester.takeException(), isNull);
    await f.close(tester);
  });
  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('discovery views fit $size and scroll with keyboard visible', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final f = Fixture();
      await f.session.initialize();
      await f.jobs.initialize();
      void noop() {}
      final views = [
        for (final mode in JobDiscoveryMode.values)
          JobDiscoveryView(
            model: f.jobs,
            mode: mode,
            onBack: noop,
            onHome: noop,
            onSearch: noop,
            onFilter: noop,
            onResults: noop,
          ),
        JobFilterView(model: f.jobs, onBack: noop, onApply: noop),
        EmptyDiscoveryView(
          onBack: noop,
          onHome: noop,
          onSearch: (_) {},
          onExplore: noop,
        ),
      ];
      for (var i = 0; i < views.length; i++) {
        for (final keyboard in [0.0, 250.0]) {
          await tester.pumpWidget(
            MaterialApp(
              key: ValueKey('$i-$keyboard'),
              theme: AppTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  disableAnimations: true,
                  viewInsets: EdgeInsets.only(bottom: keyboard),
                ),
                child: child!,
              ),
              home: views[i],
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '$i keyboard=$keyboard',
          );
          for (final element in find.byType(Scrollable).evaluate().toList()) {
            if (element.mounted) {
              final scroll =
                  (element as StatefulElement).state as ScrollableState;
              if (scroll.position.hasContentDimensions) {
                scroll.position.jumpTo(scroll.position.maxScrollExtent);
              }
              await tester.pumpAndSettle();
            }
          }
          expect(tester.takeException(), isNull, reason: 'scrolled $i');
        }
      }
      await f.close(tester);
    });
  }
}
