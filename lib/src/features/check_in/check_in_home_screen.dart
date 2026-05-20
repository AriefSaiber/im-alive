import 'package:flutter/material.dart';

import 'models/check_in_record.dart';

class CheckInHomeScreen extends StatefulWidget {
  const CheckInHomeScreen({super.key});

  @override
  State<CheckInHomeScreen> createState() => _CheckInHomeScreenState();
}

class _CheckInHomeScreenState extends State<CheckInHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<CheckInRecord> _history = <CheckInRecord>[];
  bool _checkedInToday = false;

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
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _checkIn() {
    if (_checkedInToday) {
      return;
    }

    final now = DateTime.now();
    setState(() {
      _checkedInToday = true;
      _history.insert(
        0,
        CheckInRecord(
          id: now.microsecondsSinceEpoch.toString(),
          checkedInAt: now,
        ),
      );
    });
    _pulseController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("I'm Alive")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Glad you are here today.',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _checkedInToday
                          ? 'You are checked in for today.'
                          : 'Tap the button once to let your trusted contacts know you are okay.',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: _AliveButton(
                        key: const Key('alive_button'),
                        isCheckedIn: _checkedInToday,
                        pulseAnimation: _pulseAnimation,
                        onPressed: _checkIn,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _checkedInToday
                          ? _StatusCard(
                              key: const ValueKey('checked-in'),
                              icon: Icons.verified_user_outlined,
                              title: 'You already checked in today',
                              message:
                                  'The button is disabled until the next check-in window.',
                              backgroundColor: colorScheme.secondaryContainer,
                              foregroundColor: colorScheme.onSecondaryContainer,
                            )
                          : _StatusCard(
                              key: const ValueKey('ready'),
                              icon: Icons.touch_app_outlined,
                              title: 'Ready when you are',
                              message:
                                  'One calm tap is all this screen needs right now.',
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                            ),
                    ),
                    const SizedBox(height: 24),
                    _RecentCheckIns(history: _history),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AliveButton extends StatelessWidget {
  const _AliveButton({
    super.key,
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
    final enabledGradient = <Color>[
      colorScheme.primary,
      colorScheme.secondary,
    ];
    final disabledGradient = <Color>[
      colorScheme.surfaceContainerHighest,
      colorScheme.surfaceContainerHigh,
    ];
    final foregroundColor =
        isCheckedIn ? colorScheme.onSurfaceVariant : colorScheme.onPrimary;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final buttonSize = (screenWidth * 0.62).clamp(180.0, 260.0);

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final scale = isCheckedIn ? 1.0 : pulseAnimation.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Semantics(
        button: true,
        enabled: !isCheckedIn,
        label: isCheckedIn
            ? "I'm Alive button. Already checked in today."
            : "I'm Alive button. Tap to check in.",
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isCheckedIn ? null : onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCheckedIn ? disabledGradient : enabledGradient,
                ),
                boxShadow: isCheckedIn
                    ? null
                    : <BoxShadow>[
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.24),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    isCheckedIn
                        ? Icons.check_circle_outline
                        : Icons.favorite_outline,
                    size: 46,
                    color: foregroundColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isCheckedIn ? 'Done Today' : "I'm Alive",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: foregroundColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: foregroundColor,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: foregroundColor,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentCheckIns extends StatelessWidget {
  const _RecentCheckIns({required this.history});

  final List<CheckInRecord> history;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Recent check-ins',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (history.isEmpty)
              Text(
                'Your first check-in today will appear here.',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: const Text('Checked in'),
                subtitle: Text(_formatDateTime(history.first.checkedInAt)),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} at $hour:$minute';
  }
}
