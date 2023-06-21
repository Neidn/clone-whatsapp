import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '/common/utils/utils.dart';
import '/common/utils/constants.dart';

import '/models/user_model.dart';
import '/models/chat_contact.dart';
import '/models/message.dart';

import '/common/enums/message_enum.dart';

final Provider<ChatRepository> chatRepositoryProvider =
    Provider((ref) => ChatRepository(
          firestore: FirebaseFirestore.instance,
          firebaseAuth: FirebaseAuth.instance,
        ));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({
    required this.firestore,
    required this.firebaseAuth,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserModel,
  }) async {
    try {
      final DateTime sendTime = DateTime.now();

      if (firebaseAuth.currentUser == null) {
        throw Exception('User not found');
      }

      var userDateMap = await firestore
          .collection(usersPath)
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      if (userDateMap.data() == null) {
        throw Exception('User data not found');
      }

      final UserModel receiverUserModel = UserModel.fromMap(
        userDateMap.data()!,
      );

      final String messageId = const Uuid().v4();

      _saveDataToContactsSubCollection(
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        text: text,
        sendTime: sendTime,
        receiverUserId: receiverUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        sendTime: sendTime,
        messageId: messageId,
        name: senderUserModel.name,
        receiverUserName: receiverUserModel.name,
        messageType: MessageTypeEnum.text,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }

  void _saveDataToContactsSubCollection({
    required UserModel senderUserModel,
    required UserModel receiverUserModel,
    required String text,
    required DateTime sendTime,
    required String receiverUserId,
  }) async {
    // save data to sender user contacts sub collection
    final ChatContact receiverChatContact = ChatContact(
      name: senderUserModel.name,
      profilePic: senderUserModel.profilePic,
      contactId: senderUserModel.uid,
      sendTime: sendTime,
      lastMessage: text,
    );

    await firestore
        .collection(usersPath)
        .doc(receiverUserId)
        .collection(chatsPath)
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );

    // save data to receiver user contacts sub collection
    final ChatContact senderChatContact = ChatContact(
      name: receiverUserModel.name,
      profilePic: receiverUserModel.profilePic,
      contactId: receiverUserModel.uid,
      sendTime: sendTime,
      lastMessage: text,
    );

    await firestore
        .collection(usersPath)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatsPath)
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime sendTime,
    required String messageId,
    required String name,
    required String receiverUserName,
    required MessageTypeEnum messageType,
  }) async {
    final Message message = Message(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      sendTime: sendTime,
      messageId: messageId,
      isSeen: false, // default value
    );

    // save message to sender user message sub collection
    await firestore
        .collection(usersPath)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatsPath)
        .doc(receiverUserId)
        .collection(messagesPath)
        .doc(messageId)
        .set(
          message.toMap(),
        );

    // save message to receiver user message sub collection
    await firestore
        .collection(usersPath)
        .doc(receiverUserId)
        .collection(chatsPath)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(messagesPath)
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }
}
