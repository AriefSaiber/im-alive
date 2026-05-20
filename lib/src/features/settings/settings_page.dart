import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.isDarkMode,
    required this.onDarkModeChanged,
    super.key,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            
            Text(
              'Keep the app comfortable and easy to read. Some items are preview-only.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Dark mode'),
                    subtitle: const Text('Use a darker, high-contrast theme.'),
                    value: isDarkMode,
                    onChanged: onDarkModeChanged,
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Icon(Icons.notifications_outlined),
                    title: Text('Daily reminders'),
                    subtitle: Text('Coming soon (preview only).'),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('Account'),
                    subtitle: Text('Coming soon (preview only).'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "I'm Alive is in its UI foundation phase. Firebase and notifications are not connected yet.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
