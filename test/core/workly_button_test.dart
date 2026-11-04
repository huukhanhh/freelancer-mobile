import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workly/core/theme/app_theme.dart';
import 'package:workly/core/widgets/workly_button.dart';

void main() {
  testWidgets('all sourced variants keep a working Vietnamese action', (
    tester,
  ) async {
    var taps = 0;
    for (final style in WorklyButtonStyle.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 350,
                child: WorklyButton(
                  label: 'Tiếp tục',
                  style: style,
                  onPressed: () => taps++,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(taps, WorklyButtonStyle.values.length);
  });
}
