import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_alive/src/app.dart';

void main() {
  testWidgets('checks in once and disables the home button', (tester) async {
    await tester.pumpWidget(const ImAliveApp());

    expect(find.text("I'm Alive"), findsWidgets);
    expect(find.text('Ready when you are'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Done Today'), findsOneWidget);
    expect(find.text('You already checked in today'), findsOneWidget);
    expect(find.text('Checked in'), findsOneWidget);

    await tester.tap(find.text('Done Today'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Checked in'), findsOneWidget);
  });

  testWidgets('navigates to contacts and settings and toggles dark mode', (
    tester,
  ) async {
    await tester.pumpWidget(const ImAliveApp());

    await tester.tap(find.text('Contacts'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Trusted contacts'), findsOneWidget);
    expect(find.text('Contact setup is coming soon'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);

    final initialTile = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );

    await tester.tap(find.byType(Switch).first);
    await tester.pump(const Duration(milliseconds: 300));

    final updatedTile = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(initialTile.value, isFalse);
    expect(updatedTile.value, isTrue);
  });
}
