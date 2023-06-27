import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/enums/message_enum.dart';
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
    return type == MessageTypeEnum.text
        ? _displayText(context)
        : _displayImageGIF(context);
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
}
