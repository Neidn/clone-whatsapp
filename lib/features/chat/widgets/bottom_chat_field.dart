import 'dart:io';

import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:clone_whatsapp/features/chat/widgets/picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  late final TextEditingController _messageController;

  bool _isTyping = false;

  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_isTyping) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text,
            receiverUserId: widget.receiverUserId,
          );
      _messageController.clear();
    }
  }

  void _sendFileMessage({
    required File file,
    required MessageTypeEnum messageType,
  }) =>
      ref.read(chatControllerProvider).sendFileMessage(
            context: context,
            file: file,
            receiverUserId: widget.receiverUserId,
            messageType: messageType,
          );

  void _selectImage() async {
    final File? image = await pickImageFromGallery(context: context);
    if (image == null) {
      return;
    }

    _sendFileMessage(
      file: image,
      messageType: MessageTypeEnum.image,
    );
  }

  void _takePhoto() async {
    final File? image = await pickImageFromCamera(context: context);
    if (image == null) {
      return;
    }

    _sendFileMessage(
      file: image,
      messageType: MessageTypeEnum.image,
    );
  }

  void _selectVideo() async {
    final File? video = await pickVideoFromGallery(context: context);
    if (video == null) {
      return;
    }

    _sendFileMessage(
      file: video,
      messageType: MessageTypeEnum.video,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: bottomBackgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => PickerBottomSheet(
                  size: size,
                  takePhoto: _takePhoto,
                  selectImage: _selectImage,
                  selectVideo: _selectVideo,
                ),
              );
            },
            icon: Icon(
              Icons.add,
              color: primaryColor,
              size: size.width * 0.07,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: TextFormField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _isTyping = true;
                    });
                  } else {
                    setState(() {
                      _isTyping = false;
                    });
                  }
                },
                maxLines: 5,
                minLines: 1,
                controller: _messageController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: textFieldBackgroundColor,
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          !_isTyping
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () => _takePhoto(),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mic_none_outlined,
                        color: primaryColor,
                      ),
                    ),
                  ],
                )
              : CircleAvatar(
                  backgroundColor: primaryColor,
                  child: IconButton(
                    onPressed: () => _sendMessage(),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
