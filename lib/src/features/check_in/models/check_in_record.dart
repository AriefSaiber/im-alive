class CheckInRecord {
  const CheckInRecord({
    required this.id,
    required this.checkedInAt,
    this.note,
  });

  final String id;
  final DateTime checkedInAt;
  final String? note;
}
