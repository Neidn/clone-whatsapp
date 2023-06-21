import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/user_model.dart';

import '/features/chat/repository/chat_repository.dart';

import '/features/auth/controller/auth_controller.dart';

final Provider<ChatController> chatControllerProvider =
    Provider((ref) => ChatController(
          chatRepository: ref.watch(chatRepositoryProvider),
          ref: ref,
        ));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
  }) async =>
      ref.read(userDataAuthProvider).whenData(
            (UserModel? userModel) => chatRepository.sendTextMessage(
                context: context,
                text: text,
                receiverUserId: receiverUserId,
                senderUserModel: userModel!),
          );
}
