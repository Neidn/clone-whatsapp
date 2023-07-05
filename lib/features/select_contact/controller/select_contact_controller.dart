import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/select_contact/repository/select_contact_repository.dart';

final FutureProvider<List<Contact>> getContactsProvider =
    FutureProvider<List<Contact>>(
  (ref) => ref.watch(selectContactRepositoryProvider).getContacts(),
);

final Provider<SelectContactController> selectedContactControllerProvider =
    Provider<SelectContactController>((ref) => SelectContactController(
          ref: ref,
          selectContactRepository: ref.watch(selectContactRepositoryProvider),
        ));

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact({
    required BuildContext context,
    required Contact selectedContact,
  }) async {
    await selectContactRepository.selectContact(
      context: context,
      selectedContact: selectedContact,
    );
  }

  Future<List<Contact>> getContacts() async {
    return await selectContactRepository.getContacts();
  }
}
