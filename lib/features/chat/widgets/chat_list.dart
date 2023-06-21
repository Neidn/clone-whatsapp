import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:clone_whatsapp/features/chat/widgets/sender_message_card.dart';
import 'package:clone_whatsapp/common/widgets/loader.dart';
import 'package:clone_whatsapp/features/chat/widgets/my_message_card.dart';
import 'package:clone_whatsapp/models/message.dart';
import '/features/chat/controller/chat_controller.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId;

  const ChatList({
    super.key,
    required this.receiverUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).messages(
            receiverUserId: receiverUserId,
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final Message message = snapshot.data![index];
            final String sendTime = timeago.format(
              message.sendTime,
              locale: 'ko',
            );

            final bool isMe =
                (message.senderId == FirebaseAuth.instance.currentUser!.uid);

            if (isMe) {
              return MyMessageCard(
                message: message.text,
                date: sendTime,
              );
            }

            return SenderMessageCard(
              message: message.text,
              date: sendTime,
            );
          },
        );
      },
    );
  }
}
