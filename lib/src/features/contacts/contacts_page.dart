import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Add someone you trust.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.people_outline, size: 36, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Contact setup is coming soon', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'This UI preview will later support invite codes and contact status. No contacts are sent yet.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      avatar: const Icon(Icons.hourglass_top_outlined, size: 18),
                      label: const Text('UI foundation placeholder'),
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
