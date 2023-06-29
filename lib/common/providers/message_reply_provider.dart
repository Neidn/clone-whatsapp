import 'package:clone_whatsapp/models/message_reply.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageReplyProvider =
    StateNotifierProvider<MessageReplyProvider, MessageReply?>((ref) {
  return MessageReplyProvider(null);
});

class MessageReplyProvider extends StateNotifier<MessageReply?> {
  MessageReplyProvider(super.state);

  update(MessageReply? messageReply) {
    state = messageReply;
  }
}
