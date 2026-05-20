import 'trusted_contact.dart';

class SafetyProfile {
  const SafetyProfile({
    required this.userName,
    required this.lastCheckInAt,
    required this.checkInInterval,
    required this.reminderWindow,
    this.contacts = const <TrustedContact>[],
  });

  final String userName;
  final DateTime lastCheckInAt;
  final Duration checkInInterval;
  final Duration reminderWindow;
  final List<TrustedContact> contacts;

  DateTime get nextDueAt => lastCheckInAt.add(checkInInterval);

  SafetyProfile copyWith({
    String? userName,
    DateTime? lastCheckInAt,
    Duration? checkInInterval,
    Duration? reminderWindow,
    List<TrustedContact>? contacts,
  }) {
    return SafetyProfile(
      userName: userName ?? this.userName,
      lastCheckInAt: lastCheckInAt ?? this.lastCheckInAt,
      checkInInterval: checkInInterval ?? this.checkInInterval,
      reminderWindow: reminderWindow ?? this.reminderWindow,
      contacts: contacts ?? this.contacts,
    );
  }
}
