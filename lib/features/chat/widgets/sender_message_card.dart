import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/features/chat/widgets/display_text_image_gif.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageTypeEnum type;
  final String repliedText;
  final String username;
  final MessageTypeEnum repliedType;
  final VoidCallback onRightSwipe;

  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.repliedText,
    required this.username,
    required this.repliedType,
    required this.onRightSwipe,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SwipeTo(
      rightSwipeWidget: Container(
        padding: EdgeInsets.only(left: size.width * 0.1),
        child: Icon(
          Icons.reply,
          size: size.width * 0.07,
        ),
      ),
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width - 45,
            minWidth: size.width * 0.35,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageTypeEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 20,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                          bottom: 25,
                        ),
                  child: DisplayTextImageGIF(
                    type: type,
                    message: message,
                    date: date,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
