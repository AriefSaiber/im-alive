import 'package:flutter_test/flutter_test.dart';
import 'package:im_alive/src/domain/safety_profile.dart';
import 'package:im_alive/src/services/check_in_status_service.dart';

void main() {
  const service = CheckInStatusService();
  final lastCheckInAt = DateTime(2026, 5, 20, 8);

  SafetyProfile profile() {
    return SafetyProfile(
      userName: 'Test user',
      lastCheckInAt: lastCheckInAt,
      checkInInterval: const Duration(days: 2),
      reminderWindow: const Duration(hours: 6),
    );
  }

  test('returns safe before reminder window', () {
    final snapshot = service.evaluate(
      profile: profile(),
      now: DateTime(2026, 5, 21, 8),
    );

    expect(snapshot.status, CheckInStatus.safe);
    expect(snapshot.nextDueAt, DateTime(2026, 5, 22, 8));
  });

  test('returns due soon inside reminder window', () {
    final snapshot = service.evaluate(
      profile: profile(),
      now: DateTime(2026, 5, 22, 4),
    );

    expect(snapshot.status, CheckInStatus.dueSoon);
  });

  test('returns overdue at due time', () {
    final snapshot = service.evaluate(
      profile: profile(),
      now: DateTime(2026, 5, 22, 8),
    );

    expect(snapshot.status, CheckInStatus.overdue);
    expect(snapshot.isOverdue, isTrue);
  });
}
