import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/widgets/error.dart';
import 'package:clone_whatsapp/common/widgets/loader.dart';
import 'package:clone_whatsapp/features/select_contact/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsGroup extends ConsumerWidget {
  final Function onSelected;
  final Function onRemoved;
  final Function onIndexExisted;

  const SelectContactsGroup({
    super.key,
    required this.onSelected,
    required this.onRemoved,
    required this.onIndexExisted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getContactsProvider).when(
          data: (List<Contact> contacts) {
            return Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final Contact contact = contacts[index];
                  return InkWell(
                    onTap: () {
                      if (onIndexExisted(index: index)) {
                        onRemoved(
                          index: index,
                          contact: contact,
                        );
                      } else {
                        onSelected(
                          index: index,
                          contact: contact,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          contact.displayName ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: onIndexExisted(index: index)
                            ? const Icon(
                                Icons.check_circle,
                                color: primaryColor,
                              )
                            : const Icon(
                                Icons.circle,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (Object? error, StackTrace? stackTrace) => ErrorScreen(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
