import 'package:flutter/material.dart';

import '/common/utils/colors.dart';

class BottomChatField extends StatefulWidget {
  final TextEditingController textEditingController;

  const BottomChatField({
    super.key,
    required this.textEditingController,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bottomBackgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: primaryColor,
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
                controller: widget.textEditingController,
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
                      onPressed: () {},
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
                    onPressed: () {},
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
