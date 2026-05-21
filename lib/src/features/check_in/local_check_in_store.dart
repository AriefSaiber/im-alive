import 'package:shared_preferences/shared_preferences.dart';

class LocalCheckInStore {
  LocalCheckInStore(this._prefs);

  static const _lastCheckInAtKey = 'checkin.last_check_in_at';
  static const _reminderHourKey = 'checkin.reminder_hour';
  static const _reminderMinuteKey = 'checkin.reminder_minute';

  final SharedPreferences _prefs;

  DateTime? readLastCheckInAt() {
    final iso = _prefs.getString(_lastCheckInAtKey);
    if (iso == null) return null;
    return DateTime.tryParse(iso)?.toLocal();
  }

  Future<void> saveLastCheckInAt(DateTime dateTime) {
    return _prefs.setString(_lastCheckInAtKey, dateTime.toUtc().toIso8601String());
  }

  ({int hour, int minute}) readReminderTime() {
    final hour = _prefs.getInt(_reminderHourKey) ?? 9;
    final minute = _prefs.getInt(_reminderMinuteKey) ?? 0;
    return (hour: hour, minute: minute);
  }

  Future<void> saveReminderTime({required int hour, required int minute}) async {
    await _prefs.setInt(_reminderHourKey, hour);
    await _prefs.setInt(_reminderMinuteKey, minute);
  }
}
