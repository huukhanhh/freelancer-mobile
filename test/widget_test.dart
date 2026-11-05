import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workly/app/app_dependencies.dart';
import 'package:workly/app/workly_app.dart';
import 'package:workly/features/auth/presentation/views/splash_view.dart';
import 'package:workly/features/auth/presentation/views/onboarding_view.dart';
import 'package:workly/features/auth/presentation/views/email_auth_view.dart';

void main() {
  testWidgets(
    'composition root boots splash and reaches login through onboarding',
    (tester) async {
      await tester.pumpWidget(WorklyApp(dependencies: AppDependencies.mock()));
      expect(find.byType(SplashView), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(OnboardingView), findsOneWidget);
      await tester.tap(find.text('Bỏ qua'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(EmailAuthView), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
