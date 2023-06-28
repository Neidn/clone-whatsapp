import 'dart:io';

import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:clone_whatsapp/features/chat/widgets/picker_bottom_sheet.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;
  bool _isShowEmojiContainer = false;

  @override
  void initState() {
    _messageController = TextEditingController();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _checkTyping() {
    _hideEmojiContainer();
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _isTyping = true;
      });
    } else {
      setState(() {
        _isTyping = false;
      });
    }
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

  void _showEmojiContainer() {
    setState(() {
      _isShowEmojiContainer = true;
    });
  }

  void _hideEmojiContainer() {
    setState(() {
      _isShowEmojiContainer = false;
    });
  }

  void _showKeyboard() {
    _hideEmojiContainer();
    _focusNode.requestFocus();
  }

  void _hideKeyboard() {
    _focusNode.unfocus();
  }

  void _toggleEmojiKeyboardContainer() {
    if (_isShowEmojiContainer) {
      _hideEmojiContainer();
      _showKeyboard();
    } else {
      _showEmojiContainer();
      _hideKeyboard();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _hideEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final commonGap = size.width * 0.02;

    return Column(
      children: [
        Container(
          color: bottomBackgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: commonGap,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () async => await showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => PickerBottomSheet(
                    size: size,
                    takePhoto: _takePhoto,
                    selectImage: _selectImage,
                    selectVideo: _selectVideo,
                  ),
                ),
                icon: Icon(
                  Icons.add,
                  color: primaryColor,
                  size: size.width * 0.07,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: commonGap,
                  ),
                  padding: EdgeInsets.only(
                    right: commonGap,
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        focusNode: _focusNode,
                        onChanged: (value) {
                          _checkTyping();
                        },
                        maxLines: chatLines["max"],
                        minLines: chatLines["min"],
                        controller: _messageController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: textFieldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                size.width * 0.05,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(commonGap),
                        ),
                      ),

                      // Emoji
                      IconButton(
                        onPressed: () => _toggleEmojiKeyboardContainer(),
                        icon: const Icon(
                          Icons.sticky_note_2_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ],
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
        ),
        _isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {},
                  onBackspacePressed: () {},
                  textEditingController: _messageController,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
