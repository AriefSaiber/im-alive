import 'package:flutter/material.dart';

import '../../domain/check_in_record.dart';
import '../../domain/safety_profile.dart';
import '../../domain/trusted_contact.dart';
import '../../services/check_in_status_service.dart';

class CheckInHomeScreen extends StatefulWidget {
  const CheckInHomeScreen({super.key});

  @override
  State<CheckInHomeScreen> createState() => _CheckInHomeScreenState();
}

class _CheckInHomeScreenState extends State<CheckInHomeScreen> {
  final CheckInStatusService _statusService = const CheckInStatusService();
  final List<CheckInRecord> _history = <CheckInRecord>[];

  late SafetyProfile _profile = SafetyProfile(
    userName: 'Arief',
    lastCheckInAt: DateTime.now().subtract(const Duration(hours: 6)),
    checkInInterval: const Duration(days: 2),
    reminderWindow: const Duration(hours: 6),
    contacts: const <TrustedContact>[
      TrustedContact(
        id: 'contact-1',
        name: 'Trusted contact',
        relationship: 'Emergency contact',
        phoneNumber: '+60 12-345 6789',
      ),
    ],
  );

  void _checkIn() {
    final now = DateTime.now();
    setState(() {
      _profile = _profile.copyWith(lastCheckInAt: now);
      _history.insert(
        0,
        CheckInRecord(
          id: now.microsecondsSinceEpoch.toString(),
          checkedInAt: now,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final snapshot = _statusService.evaluate(profile: _profile, now: now);
    final statusStyle = _StatusStyle.from(snapshot.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text("I'm Alive"),
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Hi ${_profile.userName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your next check-in is due ${_formatDateTime(_profile.nextDueAt)}.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: statusStyle.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: statusStyle.borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(statusStyle.icon, color: statusStyle.foregroundColor),
                    const SizedBox(height: 16),
                    Text(
                      statusStyle.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: statusStyle.foregroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage(snapshot),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: statusStyle.foregroundColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _checkIn,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("I'm alive"),
              ),
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              title: 'Trusted contacts',
              trailing: '${_profile.contacts.length}',
            ),
            const SizedBox(height: 8),
            for (final contact in _profile.contacts)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(contact.name),
                subtitle: Text('${contact.relationship ?? 'Contact'} - ${contact.phoneNumber}'),
              ),
            const SizedBox(height: 20),
            const _SectionHeader(title: 'Recent check-ins'),
            const SizedBox(height: 8),
            if (_history.isEmpty)
              const Text('No check-ins in this session yet.')
            else
              for (final record in _history.take(5))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: const Text('Checked in'),
                  subtitle: Text(_formatDateTime(record.checkedInAt)),
                ),
          ],
        ),
      ),
    );
  }

  String _statusMessage(CheckInStatusSnapshot snapshot) {
    if (snapshot.status == CheckInStatus.overdue) {
      return 'Your check-in is overdue by ${_formatDuration(snapshot.timeRemaining.abs())}.';
    }

    return '${_formatDuration(snapshot.timeRemaining)} remaining.';
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      final hours = duration.inHours.remainder(24);
      return '${duration.inDays}d ${hours}h';
    }

    if (duration.inHours > 0) {
      final minutes = duration.inMinutes.remainder(60);
      return '${duration.inHours}h ${minutes}m';
    }

    return '${duration.inMinutes.clamp(0, 59)}m';
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} at $hour:$minute';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
      ],
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
  });

  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  factory _StatusStyle.from(CheckInStatus status) {
    switch (status) {
      case CheckInStatus.safe:
        return const _StatusStyle(
          title: 'Marked safe',
          icon: Icons.verified_user_outlined,
          backgroundColor: Color(0xFFE9F7EF),
          borderColor: Color(0xFFB8E1C8),
          foregroundColor: Color(0xFF155D3B),
        );
      case CheckInStatus.dueSoon:
        return const _StatusStyle(
          title: 'Check-in due soon',
          icon: Icons.schedule_outlined,
          backgroundColor: Color(0xFFFFF6DE),
          borderColor: Color(0xFFEBCB78),
          foregroundColor: Color(0xFF6F4B00),
        );
      case CheckInStatus.overdue:
        return const _StatusStyle(
          title: 'Check-in overdue',
          icon: Icons.error_outline,
          backgroundColor: Color(0xFFFFECE8),
          borderColor: Color(0xFFE7A59A),
          foregroundColor: Color(0xFF8D2C1D),
        );
    }
  }
}
