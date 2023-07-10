import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/widgets/error.dart';
import 'package:clone_whatsapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '/features/select_contact/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';

  const SelectContactScreen({super.key});

  void _selectContact({
    required BuildContext context,
    required WidgetRef ref,
    required Contact selectedContact,
  }) {
    ref.read(selectedContactControllerProvider).selectContact(
          context: context,
          selectedContact: selectedContact,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.read(getContactsProvider).when(
            data: (List<Contact> data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final Contact contact = data[index];

                return InkWell(
                  onTap: () => _selectContact(
                    context: context,
                    ref: ref,
                    selectedContact: contact,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: contact.photo == null
                          ? const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(defaultImage),
                            )
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 20,
                            ),
                    ),
                  ),
                );
              },
            ),
            error: (error, stackTrace) => ErrorScreen(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
