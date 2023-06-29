import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/common/providers/message_reply_provider.dart';
import 'package:clone_whatsapp/models/message_reply.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:clone_whatsapp/features/chat/widgets/sender_message_card.dart';
import 'package:clone_whatsapp/common/widgets/loader.dart';
import 'package:clone_whatsapp/features/chat/widgets/my_message_card.dart';
import 'package:clone_whatsapp/models/message.dart';
import '/features/chat/controller/chat_controller.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;

  const ChatList({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late final ScrollController _messageScrollController;

  @override
  void initState() {
    _messageScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _messageScrollController.dispose();
    super.dispose();
  }

  void _onMessageSwipe({
    required String message,
    required bool isMe,
    required MessageTypeEnum type,
  }) =>
      ref.read(messageReplyProvider.notifier).update(
            MessageReply(
              message: message,
              isMe: isMe,
              type: type,
            ),
          );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).messages(
            receiverUserId: widget.receiverUserId,
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          _messageScrollController.animateTo(
            _messageScrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        });

        return ListView.builder(
          controller: _messageScrollController,
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
                type: message.type,
                repliedText: message.repliedMessage,
                username: message.repliedTo,
                repliedType: message.repliedType,
                onRightSwipe: () => _onMessageSwipe(
                  message: message.text,
                  isMe: isMe,
                  type: message.type,
                ),
              );
            }

            return SenderMessageCard(
              message: message.text,
              date: sendTime,
              type: message.type,
              repliedText: message.repliedMessage,
              username: message.repliedTo,
              repliedType: message.repliedType,
              onRightSwipe: () => _onMessageSwipe(
                message: message.text,
                isMe: isMe,
                type: message.type,
              ),
            );
          },
        );
      },
    );
  }
}
