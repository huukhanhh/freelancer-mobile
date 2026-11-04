import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workly/app/app_dependencies.dart';
import 'package:workly/app/workly_app.dart';

void main() {
  testWidgets('composition root resolves mock session through router', (
    tester,
  ) async {
    await tester.pumpWidget(WorklyApp(dependencies: AppDependencies.mock()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('bootstrap-ready')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
