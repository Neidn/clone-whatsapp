import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageTypeEnum type;

  const DisplayTextImageGIF({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MessageTypeEnum.image:
      case MessageTypeEnum.gif:
        return _displayImageGIF(context);
      case MessageTypeEnum.video:
        return _displayVideo(context);
      case MessageTypeEnum.text:
      default:
        return _displayText(context);
    }
  }

  Widget _displayText(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _displayImageGIF(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: message,
    );
  }

  Widget _displayVideo(BuildContext context) {
    return VideoPlayerItem(
      videoUrl: message,
    );
  }
}
