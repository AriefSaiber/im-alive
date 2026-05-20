import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_alive/src/app.dart';

void main() {
  testWidgets('checks in once and keeps done state', (tester) async {
    await tester.pumpWidget(const ImAliveApp());

    expect(find.text("I'm Alive"), findsWidgets);
    expect(find.text('Ready when you are'), findsOneWidget);

    await tester.tap(find.byKey(const Key('alive-check-in-button')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Done Today'), findsOneWidget);
    expect(find.text('You already checked in today'), findsOneWidget);
    expect(find.text('Checked in'), findsOneWidget);
  });

  testWidgets('navigates to contacts and settings and toggles dark mode', (
    tester,
  ) async {
    await tester.pumpWidget(const ImAliveApp());

    await tester.tap(find.text('Contacts'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Contact setup is coming soon'), findsOneWidget);
    expect(find.text('UI foundation placeholder'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dark mode'), findsOneWidget);

    final initialTile =
        tester.widget<SwitchListTile>(find.byType(SwitchListTile));

    await tester.tap(find.byType(Switch).first);
    await tester.pump(const Duration(milliseconds: 300));

    final updatedTile =
        tester.widget<SwitchListTile>(find.byType(SwitchListTile));

    expect(updatedTile.value, isNot(initialTile.value));
  });
}
