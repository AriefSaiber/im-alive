import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/trusted_contact.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<TrustedContact> _contacts = <TrustedContact>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trusted Contacts')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Add someone you trust.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'If you miss check-ins, these people can be notified in a future release.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _InviteFlowCard(onEnterInviteCode: _showEnterInviteCodeDialog),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _showAddContactForm,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add trusted contact'),
            ),
            const SizedBox(height: 16),
            if (_contacts.isEmpty)
              const _EmptyContactsState()
            else
              ..._contacts.map(
                (contact) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ContactListTile(
                    contact: contact,
                    onTap: () => _openContactDetail(contact),
                    onDelete: () => _removeContact(contact.id),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddContactForm() async {
    final formResult = await showModalBottomSheet<_AddContactResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AddContactSheet(),
    );

    if (formResult == null) {
      return;
    }

    setState(() {
      _contacts.add(
        TrustedContact(
          id: _generateContactId(),
          name: formResult.name,
          phoneNumber: formResult.phoneNumber,
          relationship: formResult.relationship,
        ),
      );
    });
  }

  void _removeContact(String id) {
    setState(() {
      _contacts.removeWhere((contact) => contact.id == id);
    });
  }

  void _openContactDetail(TrustedContact contact) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ContactDetailPage(contact: contact),
      ),
    );
  }

  Future<void> _showEnterInviteCodeDialog() async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter invite code'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Invite code',
            helperText: 'Placeholder flow only. No backend yet.',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text(
                    controller.text.trim().isEmpty
                        ? 'Please enter an invite code.'
                        : 'Invite code placeholder accepted: ${controller.text.trim().toUpperCase()}',
                  ),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  String _generateContactId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(99999).toString().padLeft(5, '0');
    return 'local_$timestamp$random';
  }
}

class _EmptyContactsState extends StatelessWidget {
  const _EmptyContactsState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.people_outline,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'No trusted contacts yet.',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add trusted contact" to start your local placeholder list.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactListTile extends StatelessWidget {
  const _ContactListTile({
    required this.contact,
    required this.onTap,
    required this.onDelete,
  });

  final TrustedContact contact;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(contact.name.characters.first.toUpperCase()),
        ),
        title: Text(contact.name),
        subtitle: Text(contact.phoneNumber),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
          tooltip: 'Remove contact',
        ),
      ),
    );
  }
}

class _InviteFlowCard extends StatelessWidget {
  const _InviteFlowCard({required this.onEnterInviteCode});

  final VoidCallback onEnterInviteCode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Invite flow (placeholder)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Share this sample code with a trusted person: ALIVE-1234\n'
              'This is a local UI preview. Real code sharing will be wired later.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onEnterInviteCode,
              icon: const Icon(Icons.key_outlined),
              label: const Text('Enter invite code'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddContactSheet extends StatefulWidget {
  const _AddContactSheet();

  @override
  State<_AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<_AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Add trusted contact', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Name is required.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Phone number is required.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _relationshipController,
              decoration: const InputDecoration(labelText: 'Relationship (optional)'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Save contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      _AddContactResult(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        relationship: _relationshipController.text.trim().isEmpty
            ? null
            : _relationshipController.text.trim(),
      ),
    );
  }
}

class _AddContactResult {
  const _AddContactResult({
    required this.name,
    required this.phoneNumber,
    this.relationship,
  });

  final String name;
  final String phoneNumber;
  final String? relationship;
}

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({required this.contact, super.key});

  final TrustedContact contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact detail')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(contact.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(contact.phoneNumber, style: Theme.of(context).textTheme.titleMedium),
            if (contact.relationship != null) ...[
              const SizedBox(height: 8),
              Text('Relationship: ${contact.relationship}'),
            ],
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Placeholder only: invite status, delivery status, and history will appear here in a future iteration.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
