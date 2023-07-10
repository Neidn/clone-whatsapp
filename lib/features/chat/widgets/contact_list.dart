import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clone_whatsapp/models/group.dart' as model;
import 'package:clone_whatsapp/models/chat_contact.dart';
import 'package:clone_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:clone_whatsapp/screens/mobile_chat_screen.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<model.Group>>(
            stream: ref.watch(chatControllerProvider).chatGroups(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final model.Group chatGroup = snapshot.data![index];

                  return ListTile(
                    onTap: () async => await Navigator.of(context).pushNamed(
                      MobileChatScreen.routeName,
                      arguments: {
                        'name': chatGroup.name,
                        'uid': chatGroup.communityId,
                        'isGroupChat': true,
                        'groupId': chatGroup.groupId,
                      },
                    ),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        chatGroup.groupPic,
                      ),
                    ),
                    title: Text(chatGroup.name),
                    subtitle: Text(
                      chatGroup.lastMessage,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Text(
                      timeago.format(
                        chatGroup.lastMessageTime,
                        locale: 'ko',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          StreamBuilder<List<ChatContact>>(
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
                        'isGroupChat': false,
                        'groupId': '',
                      },
                    ),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        chatContact.profilePic,
                      ),
                    ),
                    title: Text(chatContact.name),
                    subtitle: Text(
                      chatContact.lastMessage,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
          ),
        ],
      ),
    );
  }
}
