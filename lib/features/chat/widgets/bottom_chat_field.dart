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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
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
                      Radius.circular(50),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
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
              : Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    right: 2,
                    left: 2,
                  ),
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
