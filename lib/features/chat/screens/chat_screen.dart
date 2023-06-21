import 'package:flutter/material.dart';

import '/common/utils/colors.dart';

import '../widgets/contact_list.dart';

import '/features/select_contact/screens/select_contact_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: const Text(
          '편집',
          style: TextStyle(
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () async => await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SelectContactScreen(),
                ),
              ),
            icon: const Icon(
              Icons.edit_outlined,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const Text(
              '대화',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ContactList(),
        ],
      ),
    );
  }
}
