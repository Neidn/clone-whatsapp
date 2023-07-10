import 'dart:io';
import 'dart:math';

import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/common/providers/message_reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clone_whatsapp/models/group.dart' as model;

import '/models/user_model.dart';
import '/models/chat_contact.dart';
import 'package:clone_whatsapp/models/message.dart';

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

  Stream<List<ChatContact>> chatContacts() => chatRepository.getChatContacts();

  Stream<List<model.Group>> chatGroups() => chatRepository.getChatGroups();

  Stream<List<Message>> messages({
    required String receiverUserId,
  }) =>
      chatRepository.getChats(
        receiverUserId: receiverUserId,
      );

  Stream<List<Message>> groupMessages({
    required String communityId,
    required String groupId,
  }) =>
      chatRepository.getGroupChats(
        communityId: communityId,
        groupId: groupId,
      );

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required bool isGroupChat,
    required String groupId,
  }) async {
    ref.read(userDataAuthProvider).whenData(
          (UserModel? userModel) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUserModel: userModel!,
            messageReply: ref.read(messageReplyProvider),
            isGroupChat: isGroupChat,
            groupId: groupId,
          ),
        );

    ref.read(messageReplyProvider.notifier).update(null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageTypeEnum messageType,
    required bool isGroupChat,
    required String groupId,
  }) async {
    ref.read(userDataAuthProvider).whenData(
          (UserModel? senderUserModel) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserModel: senderUserModel!,
            ref: ref,
            messageType: messageType,
            messageReply: ref.read(messageReplyProvider),
            isGroupChat: isGroupChat,
            groupId: groupId,
          ),
        );
    ref.read(messageReplyProvider.notifier).update(null);
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required bool isGroupChat,
    required String groupId,
  }) async {
    // gifUrl = https://giphy.com/embed/dK0somWWBmQEyvZSrI
    // realGifUrl = https://media.giphy.com/media/dK0somWWBmQEyvZSrI/giphy.webp
    int gifUrlPartIndex = gifUrl.lastIndexOf('/') + 1;

    String gifPartUrl = gifUrl.substring(gifUrlPartIndex);

    // random int of [1 , 2 , 3]
    int randomInt = Random().nextInt(3) + 1;

    gifUrl = 'https://media$randomInt.giphy.com/media/$gifPartUrl/giphy.webp';

    ref.read(userDataAuthProvider).whenData(
          (UserModel? senderUserModel) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: gifUrl,
            receiverUserId: receiverUserId,
            senderUserModel: senderUserModel!,
            messageReply: ref.read(messageReplyProvider),
            isGroupChat: isGroupChat,
            groupId: groupId,
          ),
        );

    ref.read(messageReplyProvider.notifier).update(null);
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
    required bool isGroupChat,
    required String groupId,
  }) =>
      chatRepository.setChatMessageSeen(
        context: context,
        receiverUserId: receiverUserId,
        messageId: messageId,
        isGroupChat: isGroupChat,
        groupId: groupId,
      );
}
