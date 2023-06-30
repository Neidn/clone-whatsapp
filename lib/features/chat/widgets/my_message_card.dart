import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/features/chat/widgets/display_text_image_gif.dart';
import 'package:flutter/material.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageTypeEnum type;
  final String repliedText;
  final String username;
  final MessageTypeEnum repliedType;
  final VoidCallback onRightSwipe;
  final bool isSeen;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.repliedText,
    required this.username,
    required this.repliedType,
    required this.onRightSwipe,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final isReplying = repliedText.isNotEmpty;

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
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width - 45,
            minWidth: size.width * 0.35,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 5,
                    bottom: 25,
                  ),
                  // Message
                  child: Column(
                    children: [
                      // Reply
                      if (isReplying) ...[
                        Container(
                          height: size.height * 0.05,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // TODO: scale the image when replying
                          child: DisplayTextImageGIF(
                            type: repliedType,
                            message: repliedText,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],

                      // Message
                      DisplayTextImageGIF(
                        type: type,
                        message: message,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: isSeen ? Colors.blue : Colors.white60,
                      ),
                    ],
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
