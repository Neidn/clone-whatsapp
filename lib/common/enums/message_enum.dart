enum MessageTypeEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageTypeEnum(this.type);

  final String type;
}

extension ConvertMessageType on String {
  MessageTypeEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageTypeEnum.text;
      case 'image':
        return MessageTypeEnum.image;
      case 'audio':
        return MessageTypeEnum.audio;
      case 'video':
        return MessageTypeEnum.video;
      case 'gif':
        return MessageTypeEnum.gif;
      default:
        throw Exception('Invalid message type');
    }
  }
}
