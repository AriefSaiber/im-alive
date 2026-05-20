import '../../domain/safety_profile.dart';

enum CheckInStatus { safe, dueSoon, overdue }

class CheckInStatusSnapshot {
  const CheckInStatusSnapshot({
    required this.status,
    required this.nextDueAt,
    required this.timeRemaining,
  });

  final CheckInStatus status;
  final DateTime nextDueAt;
  final Duration timeRemaining;

  bool get isOverdue => status == CheckInStatus.overdue;
}

class CheckInStatusService {
  const CheckInStatusService();

  CheckInStatusSnapshot evaluate({
    required SafetyProfile profile,
    required DateTime now,
  }) {
    final nextDueAt = profile.nextDueAt;
    final dueSoonAt = nextDueAt.subtract(profile.reminderWindow);
    final timeRemaining = nextDueAt.difference(now);

    if (!now.isBefore(nextDueAt)) {
      return CheckInStatusSnapshot(
        status: CheckInStatus.overdue,
        nextDueAt: nextDueAt,
        timeRemaining: timeRemaining,
      );
    }

    if (!now.isBefore(dueSoonAt)) {
      return CheckInStatusSnapshot(
        status: CheckInStatus.dueSoon,
        nextDueAt: nextDueAt,
        timeRemaining: timeRemaining,
      );
    }

    return CheckInStatusSnapshot(
      status: CheckInStatus.safe,
      nextDueAt: nextDueAt,
      timeRemaining: timeRemaining,
    );
  }
}
