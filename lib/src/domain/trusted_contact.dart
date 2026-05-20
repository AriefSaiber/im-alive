class TrustedContact {
  const TrustedContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.relationship,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String? relationship;
}
