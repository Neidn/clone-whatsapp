import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/models/chat_contact.dart';

import '/features/chat/controller/chat_controller.dart';

import '/screens/mobile_chat_screen.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContact>>(
      stream: ref.watch(chatControllerProvider).chatContacts(),
      builder: (context, snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final ChatContact chatContact = snapshot.data![index];

            return ListTile(
              onTap: () async => await Navigator.of(context).pushNamed(
                MobileChatScreen.routeName,
                arguments: {
                  'name': chatContact.name,
                  'uid': chatContact.contactId,
                },
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chatContact.profilePic),
              ),
              title: Text(chatContact.name),
              subtitle: Text(chatContact.lastMessage),
              trailing: Text(
                timeago.format(
                  chatContact.sendTime,
                  locale: 'ko',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
