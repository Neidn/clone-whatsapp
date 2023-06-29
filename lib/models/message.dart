import '/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageTypeEnum type;
  final DateTime sendTime;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageTypeEnum repliedType;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.sendTime,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedType,
  });

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        senderId: map['senderId'] ?? '',
        receiverId: map['receiverId'] ?? '',
        text: map['text'] ?? '',
        type: MessageTypeEnum.values[map['type'] ?? 0],
        sendTime: DateTime.parse(map['sendTime']),
        messageId: map['messageId'] ?? '',
        isSeen: map['isSeen'] ?? false,
        repliedMessage: map['repliedMessage'] ?? '',
        repliedTo: map['repliedTo'] ?? '',
        repliedType:
            MessageTypeEnum.values[map['repliedType'] ?? MessageTypeEnum.text],
      );

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'type': type.index,
        'sendTime': sendTime.toString(),
        'messageId': messageId,
        'isSeen': isSeen,
        'repliedMessage': repliedMessage,
        'repliedTo': repliedTo,
        'repliedType': repliedType.index,
      };
}
