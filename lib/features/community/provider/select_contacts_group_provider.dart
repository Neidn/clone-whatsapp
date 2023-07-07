import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsGroupProvider =
    StateNotifierProvider<SelectContactsGroupProvider, List<Contact>>(
  (ref) => SelectContactsGroupProvider(
    [],
  ),
);

class SelectContactsGroupProvider extends StateNotifier<List<Contact>> {
  SelectContactsGroupProvider(super.state);

  update(Contact contact) {
    state = [...state, contact];
  }

  remove(Contact contact) {
    state = state.where((element) => element != contact).toList();
  }

  reset() {
    state = [];
  }

  getSelectedContacts() {
    return state;
  }
}
