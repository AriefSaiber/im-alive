import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text:
          "Hi! Just checking in — I haven't confirmed in a while. Please check on me.",
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      helpText: 'Preview reminder time',
    );

    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Keep things simple and comfortable. Placeholders below are UI-only previews for now.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'Appearance',
              subtitle: 'Choose the look that feels easiest to read.',
              child: SegmentedButton<ThemeMode>(
                segments: const <ButtonSegment<ThemeMode>>[
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.brightness_auto_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: <ThemeMode>{widget.themeMode},
                onSelectionChanged: (selection) {
                  widget.onThemeModeChanged(selection.first);
                },
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Daily Reminder Time',
              subtitle: 'Preview only. Real reminders are not active yet.',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('Reminder time'),
                subtitle: Text(MaterialLocalizations.of(context).formatTimeOfDay(_reminderTime)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickReminderTime,
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Emergency Message Template',
              subtitle: 'Template only — this is not sent automatically yet.',
              child: TextField(
                controller: _messageController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add your preferred reassurance message',
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Account & Profile',
              subtitle: 'Preview values only. Login sync is not connected yet.',
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text('Your Name'),
                subtitle: Text('you@example.com'),
                trailing: Text('Coming soon'),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'About App',
              subtitle: 'Friendly info and app details.',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("I'm Alive"),
                  SizedBox(height: 8),
                  Text('Version: 0.1.0-placeholder'),
                  SizedBox(height: 8),
                  Text('A calm daily check-in app for peace of mind.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
