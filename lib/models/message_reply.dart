import 'package:clone_whatsapp/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageTypeEnum type;

  const MessageReply({
    required this.message,
    required this.isMe,
    required this.type,
  });
}
