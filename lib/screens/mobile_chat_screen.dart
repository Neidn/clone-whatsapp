import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:clone_whatsapp/features/chat/widgets/bottom_chat_field.dart';
import 'package:clone_whatsapp/features/chat/widgets/chat_list.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';

  final String name;
  final String uid;
  final bool isGroupChat;
  final String groupId;

  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    this.groupId = '',
    this.isGroupChat = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    print(uid);
    print(name);
    print(groupId);
    print(isGroupChat);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream:
                    ref.read(authControllerProvider).userDataById(userId: uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Text(name),
                      Text(
                        snapshot.data!.isOnline ? 'Online' : 'Offline',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
              groupId: groupId,
            ),
          ),
          BottomChatField(
            receiverUserId: uid,
            isGroupChat: isGroupChat,
            groupId: groupId,
          ),
          Container(
            height: size.height * 0.02,
            color: bottomBackgroundColor,
          ),
        ],
      ),
    );
  }
}
