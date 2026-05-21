import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_check_in_store.dart';

class CheckInHomeScreen extends StatefulWidget {
  const CheckInHomeScreen({super.key});

  @override
  State<CheckInHomeScreen> createState() => _CheckInHomeScreenState();
}

class _CheckInHomeScreenState extends State<CheckInHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  LocalCheckInStore? _store;
  DateTime? _lastCheckInAt;
  late TimeOfDay _reminderTime;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final store = LocalCheckInStore(prefs);
    final reminder = store.readReminderTime();
    if (!mounted) return;
    setState(() {
      _store = store;
      _lastCheckInAt = store.readLastCheckInAt();
      _reminderTime = TimeOfDay(hour: reminder.hour, minute: reminder.minute);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool get _checkedInToday {
    final last = _lastCheckInAt;
    if (last == null) return false;
    final now = DateTime.now();
    return now.year == last.year && now.month == last.month && now.day == last.day;
  }

  DateTime get _nextReminderAt {
    final now = DateTime.now();
    final todayReminder = DateTime(
      now.year,
      now.month,
      now.day,
      _reminderTime.hour,
      _reminderTime.minute,
    );
    if (_checkedInToday || now.isAfter(todayReminder)) {
      return todayReminder.add(const Duration(days: 1));
    }
    return todayReminder;
  }

  bool get _contactsShouldBeNotified {
    final last = _lastCheckInAt;
    if (last == null) return false;
    return DateTime.now().difference(last) >= const Duration(days: 2);
  }

  Future<void> _checkIn({String source = 'button'}) async {
    if (_checkedInToday || _store == null) return;
    final now = DateTime.now();
    await _store!.saveLastCheckInAt(now);
    if (!mounted) return;
    setState(() => _lastCheckInAt = now);
    _pulseController.stop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checked in from $source. Timer refreshed.')),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.month}/${local.day}/${local.year} at $hour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_store == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("I'm Alive")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Glad you are here today.', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                _checkedInToday
                    ? 'You are checked in for today.'
                    : 'Tap once to check in for today.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Center(
                child: _AliveButton(
                  isCheckedIn: _checkedInToday,
                  pulseAnimation: _pulseAnimation,
                  onPressed: () => _checkIn(source: 'button'),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _lastCheckInAt == null
                            ? 'No check-in yet.'
                            : 'Last check-in: ${_formatDateTime(_lastCheckInAt!)}',
                      ),
                      const SizedBox(height: 8),
                      Text('Next reminder: ${_formatDateTime(_nextReminderAt)}'),
                      if (_contactsShouldBeNotified) ...[
                        const SizedBox(height: 12),
                        Text(
                          '2 days passed without check-in. Trusted contacts should be notified via app notification.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AliveButton extends StatelessWidget {
  const _AliveButton({
    required this.isCheckedIn,
    required this.pulseAnimation,
    required this.onPressed,
  });

  final bool isCheckedIn;
  final Animation<double> pulseAnimation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabledGradient = <Color>[colorScheme.primary, colorScheme.secondary];
    final disabledGradient = <Color>[
      colorScheme.surfaceContainerHighest,
      colorScheme.surfaceContainerHigh,
    ];

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final scale = isCheckedIn ? 1.0 : pulseAnimation.value;
        return Transform.scale(scale: scale, child: child);
      },
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: isCheckedIn ? null : onPressed,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: isCheckedIn ? disabledGradient : enabledGradient),
            ),
            child: Center(
              child: Text(
                isCheckedIn ? 'Done Today' : "I'm Alive",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isCheckedIn ? colorScheme.onSurfaceVariant : colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
