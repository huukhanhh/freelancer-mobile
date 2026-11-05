import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/views/email_auth_view.dart';
import 'package:workly/features/auth/presentation/views/onboarding_view.dart';
import 'package:workly/features/auth/presentation/views/profile_setup_view.dart';
import 'package:workly/features/auth/presentation/views/verification_view.dart';
import 'package:workly/features/auth/presentation/views/role_selection_view.dart';
import 'package:workly/features/auth/presentation/views/google_auth_view.dart';
import 'package:workly/features/auth/presentation/views/recovery_view.dart';
import 'package:workly/features/home/data/mock_marketplace_repository.dart';
import 'package:workly/features/home/presentation/view_models/home_view_model.dart';
import 'package:workly/features/home/presentation/views/home_view.dart';
import 'package:workly/features/session/data/mock_session_repository.dart';
import 'package:workly/features/session/domain/demo_accounts.dart';
import 'package:workly/features/session/domain/user_session.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final f = FontLoader(AppTheme.fontFamily)
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans.ttf'));
    await f.load();
  });
  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets(
      'auth forms and home layouts fit $size, including visible keyboard',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final session = SessionViewModel(
          MockSessionRepository(session: DemoAccounts.freelancer),
        );
        await session.initialize();
        final model = AuthFlowViewModel(MockSessionRepository(), session)
          ..email = 'demo@workly.example';
        void noop() {}
        final views = <Widget>[
          for (var i = 0; i < 3; i++)
            OnboardingView(index: i, onNext: noop, onSkip: noop),
          for (final register in [false, true])
            EmailAuthView(
              model: model,
              register: register,
              onBack: noop,
              onAlternate: noop,
              onGoogle: noop,
              onRecovery: noop,
              onComplete: noop,
            ),
          VerificationView(model: model, onBack: noop, onLogin: noop),
          RoleSelectionView(model: model, onBack: noop, onContinue: noop),
          for (final role in UserRole.values)
            ProfileSetupView(
              model: model,
              role: role,
              onBack: noop,
              onComplete: noop,
            ),
          GoogleAuthView(model: model, onBack: noop, onComplete: noop),
          RecoveryView(model: model, onBack: noop, onSuccess: noop),
          RecoverySuccessView(email: model.email, onLogin: noop),
          for (final user in [DemoAccounts.client, DemoAccounts.freelancer])
            HomeView(
              model: HomeViewModel(
                user: user,
                repository: const MockMarketplaceRepository(),
              ),
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
              reason: '${views[i].runtimeType}, keyboard=$keyboard',
            );
            final scrolls = find.byType(Scrollable);
            for (final scroll in scrolls.evaluate().toList()) {
              if (scroll.mounted && scroll.widget is Scrollable) {
                final state =
                    (scroll as StatefulElement).state as ScrollableState;
                if (state.position.hasContentDimensions &&
                    state.position.maxScrollExtent > 0) {
                  state.position.jumpTo(state.position.maxScrollExtent);
                  await tester.pumpAndSettle();
                }
              }
            }
            expect(
              tester.takeException(),
              isNull,
              reason: 'scrolled ${views[i].runtimeType}',
            );
          }
        }
        await tester.pumpWidget(const SizedBox.shrink());
        model.dispose();
        session.dispose();
      },
    );
  }
}
