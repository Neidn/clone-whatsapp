import 'package:clone_whatsapp/common/providers/message_reply_provider.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/features/chat/widgets/display_text_image_gif.dart';
import 'package:clone_whatsapp/models/message_reply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({
    super.key,
  });

  void _cancelReply(WidgetRef ref) {
    // Clear Message Reply
    ref.read(messageReplyProvider.notifier).update(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final MessageReply? messageReply = ref.watch(messageReplyProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            border: Border(
              left: BorderSide(
                color: messageReply!.isMe
                    ? replyMyBorderColor
                    : replyOtherBorderColor,
                width: 4,
              ),
            ),
          ),
          width: size.width,
          constraints: BoxConstraints(
            minHeight: size.height * 0.075,
          ),
          padding: EdgeInsets.all(size.width * 0.02),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Me Or Other User Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageReply.isMe ? 'Me' : 'Other User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.01),
                  DisplayTextImageGIF(
                    type: messageReply.type,
                    message: messageReply.message,
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {
                  _cancelReply(ref);
                },
                child: Icon(
                  Icons.close,
                  size: size.width * 0.07,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
