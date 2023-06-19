import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/select_contact/repository/select_contact_repository.dart';

final FutureProvider<List<Contact>> getContactsProvider =
    FutureProvider<List<Contact>>(
  (ref) => ref.watch(selectContactRepositoryProvider).getContacts(),
);
