import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:workly/app/router/app_router.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/views/profile_setup_view.dart';
import 'package:workly/features/auth/presentation/views/recovery_view.dart';
import 'package:workly/features/auth/presentation/views/role_selection_view.dart';
import 'package:workly/features/auth/presentation/views/verification_view.dart';
import 'package:workly/features/home/data/mock_marketplace_repository.dart';
import 'package:workly/features/home/presentation/views/home_view.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/domain/user_session.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

class Harness {
  Harness({String initial = AppRoutes.login}) {
    session = SessionViewModel(repo);
    model = AuthFlowViewModel(repo, session);
    router = createAppRouter(
      session,
      model,
      const MockMarketplaceRepository(),
      initialLocation: initial,
    );
  }
  final repo = MockSessionRepository();
  late final SessionViewModel session;
  late final AuthFlowViewModel model;
  late final GoRouter router;
  Future<void> mount(WidgetTester tester) async {
    await session.initialize();
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
    model.dispose();
    session.dispose();
  }
}

Future<void> action(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(FilledButton, label));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader(AppTheme.fontFamily)
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans.ttf'));
    await font.load();
  });
  testWidgets(
    'Google demo completes Freelancer setup and stores chosen technologies',
    (tester) async {
      final h = Harness();
      await h.mount(tester);
      await tester.ensureVisible(find.text('Tiếp tục với Google'));
      await tester.tap(find.text('Tiếp tục với Google'));
      await tester.pumpAndSettle();
      await action(tester, 'Tiếp tục với Minh Anh');
      expect(find.byType(RoleSelectionView), findsOneWidget);
      await tester.tap(find.text('Tôi là Freelancer'));
      await tester.pumpAndSettle();
      await action(tester, 'Tiếp tục');
      final flutter = find.text('Flutter');
      await tester.ensureVisible(flutter);
      await tester.tap(flutter);
      await tester.pumpAndSettle();
      await action(tester, 'Hoàn tất hồ sơ');
      expect(find.text('Chợ việc làm'), findsOneWidget);
      expect(h.repo.profileFor(h.session.session!.userId)?.technologies, {
        'Flutter',
      });
      expect(tester.takeException(), isNull);
      await h.close(tester);
    },
  );
  testWidgets(
    'both demo roles enter correct home; wrong role deep link is guarded',
    (tester) async {
      for (final user in [DemoAccounts.client, DemoAccounts.freelancer]) {
        final h = Harness();
        await h.mount(tester);
        await tester.enterText(find.byType(TextFormField).at(0), user.email);
        await action(tester, 'Đăng nhập');
        expect(find.byType(HomeView), findsOneWidget);
        expect(
          find.text(
            user.role == UserRole.client ? 'Chợ freelancer' : 'Chợ việc làm',
          ),
          findsOneWidget,
        );
        h.router.go(
          user.role == UserRole.client
              ? AppRoutes.freelancerHome
              : AppRoutes.clientHome,
        );
        await tester.pumpAndSettle();
        expect(
          h.router.routeInformationProvider.value.uri.path,
          signedInDestination(h.session),
        );
        expect(tester.takeException(), isNull);
        await h.close(tester);
      }
    },
  );
  testWidgets(
    'register, paste OTP, first login, choose Client and complete company profile',
    (tester) async {
      final h = Harness(initial: AppRoutes.register);
      await h.mount(tester);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'new@workly.example',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        DemoAccounts.password,
      );
      await action(tester, 'Tạo tài khoản');
      expect(find.byType(VerificationView), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('otp-0')),
        MockSessionRepository.demoCode,
      );
      await action(tester, 'Xác minh email');
      expect(find.text('Đăng ký thành công'), findsOneWidget);
      await action(tester, 'Đăng nhập lần đầu');
      await action(tester, 'Đăng nhập');
      expect(find.byType(RoleSelectionView), findsOneWidget);
      await tester.tap(find.text('Tôi là Client'));
      await tester.pumpAndSettle();
      await action(tester, 'Tiếp tục');
      expect(find.byType(ProfileSetupView), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(0), 'Client Demo');
      await tester.tap(find.text('Đại diện doanh nghiệp'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(1), 'Demo Studio');
      await action(tester, 'Hoàn tất & khám phá');
      expect(find.text('Chợ freelancer'), findsOneWidget);
      final user = h.session.session!;
      expect(h.repo.profileFor(user.userId)?.companyName, 'Demo Studio');
      expect(tester.takeException(), isNull);
      await h.close(tester);
    },
  );
  testWidgets(
    'recovery form validates confirmation and updates login credentials',
    (tester) async {
      final h = Harness();
      await h.mount(tester);
      await tester.tap(find.text('Quên mật khẩu?'));
      await tester.pumpAndSettle();
      expect(find.byType(RecoveryView), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField).first,
        DemoAccounts.clientEmail,
      );
      await action(tester, 'Gửi liên kết khôi phục');
      await tester.enterText(find.byType(TextFormField).at(0), 'NewDemo123!');
      await tester.enterText(find.byType(TextFormField).at(1), 'Different123!');
      await action(tester, 'Cập nhật mật khẩu');
      expect(find.text('Mật khẩu nhập lại chưa khớp.'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(1), 'NewDemo123!');
      await action(tester, 'Cập nhật mật khẩu');
      expect(find.byType(RecoverySuccessView), findsOneWidget);
      await action(tester, 'Quay lại đăng nhập');
      await tester.enterText(find.byType(TextFormField).at(1), 'NewDemo123!');
      await action(tester, 'Đăng nhập');
      expect(find.byType(HomeView), findsOneWidget);
      expect(tester.takeException(), isNull);
      await h.close(tester);
    },
  );
  testWidgets(
    'unauthenticated deep link returns login; invalid login remains editable',
    (tester) async {
      final h = Harness(initial: AppRoutes.clientHome);
      await h.mount(tester);
      expect(h.router.routeInformationProvider.value.uri.path, AppRoutes.login);
      await tester.enterText(find.byType(TextFormField).at(0), 'bad-email');
      await action(tester, 'Đăng nhập');
      expect(find.text('Email chưa đúng định dạng.'), findsOneWidget);
      expect(h.repo.session, isNull);
      expect(tester.takeException(), isNull);
      await h.close(tester);
    },
  );
}
