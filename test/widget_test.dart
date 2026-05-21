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

  testWidgets('navigates to settings and updates theme placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(const ImAliveApp());

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Notification Preferences'), findsOneWidget);
    expect(find.text('Emergency Message Template'), findsOneWidget);
    expect(find.text('Account & Profile'), findsOneWidget);
    expect(find.text('About App'), findsOneWidget);

    expect(find.text('System'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.text('Preview reminder time'), findsNothing);
  });
}
