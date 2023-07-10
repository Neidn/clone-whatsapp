import 'dart:io';

import 'package:clone_whatsapp/common/repositories/common_firebase_storage_repository.dart';
import 'package:clone_whatsapp/models/community.dart';
import 'package:clone_whatsapp/models/message_reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:clone_whatsapp/models/group.dart' as model;

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

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection(usersPath)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatsPath)
        .snapshots()
        .asyncMap((event) async {
      final List<ChatContact> chatContacts = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
        final ChatContact chatContact = ChatContact.fromMap(doc.data());

        final DocumentSnapshot<Map<String, dynamic>> userData = await firestore
            .collection(usersPath)
            .doc(chatContact.contactId)
            .get();

        final UserModel userModel = UserModel.fromMap(userData.data()!);

        chatContacts.add(
          ChatContact(
            name: userModel.name,
            profilePic: userModel.profilePic,
            contactId: chatContact.contactId,
            sendTime: chatContact.sendTime,
            lastMessage: chatContact.lastMessage,
            otherName: chatContact.otherName,
          ),
        );
      }

      return chatContacts;
    });
  }

  Stream<List<Message>> getChats({
    required String receiverUserId,
  }) {
    return firestore
        .collection(usersPath)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatsPath)
        .doc(receiverUserId)
        .collection(messagesPath)
        .orderBy('sendTime', descending: true)
        .snapshots()
        .map(
      (event) {
        final List<Message> messages = [];

        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
          final Message message = Message.fromMap(doc.data());

          messages.add(message);
        }

        return messages;
      },
    );
  }

  Stream<List<model.Group>> getChatGroups() {
    return firestore
        .collection(communityPath)
        .where(
          'members',
          arrayContains: firebaseAuth.currentUser!.uid,
        )
        .snapshots()
        .asyncMap((event) async {
      final List<model.Group> chatGroups = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
        final Community community = Community.fromMap(doc.data());

        for (var groupId in community.groups) {
          var groupData = await firestore
              .collection(communityPath)
              .doc(community.communityId)
              .collection(groupsPath)
              .doc(groupId)
              .get();

          if (groupData.data() == null) {
            continue;
          }

          final model.Group group = model.Group.fromMap(groupData.data()!);
          chatGroups.add(group);
        }
      }

      return chatGroups;
    });
  }

  Stream<List<Message>> getGroupChats({
    required String communityId,
    required String groupId,
  }) {
    return firestore
        .collection(communityPath)
        .doc(communityId)
        .collection(groupsPath)
        .doc(groupId)
        .collection(chatsPath)
        .orderBy('sendTime', descending: true)
        .snapshots()
        .map(
      (event) {
        final List<Message> messages = [];

        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
          final Message message = Message.fromMap(doc.data());

          messages.add(message);
        }

        return messages;
      },
    );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserModel,
    required MessageReply? messageReply,
    required bool isGroupChat,
    required String groupId,
  }) async {
    try {
      final DateTime sendTime = DateTime.now();

      if (firebaseAuth.currentUser == null) {
        throw Exception('User not found');
      }

      UserModel? receiverUserModel;

      if (!isGroupChat) {
        var receiverUserDataMap =
            await firestore.collection(usersPath).doc(receiverUserId).get();

        if (receiverUserDataMap.data() == null) {
          throw Exception('User data not found');
        }

        receiverUserModel = UserModel.fromMap(
          receiverUserDataMap.data()!,
        );
      }

      final String messageId = const Uuid().v4();

      _saveDataToContactsSubCollection(
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        text: text,
        sendTime: sendTime,
        receiverUserId: receiverUserId,
        isGroupChat: isGroupChat,
        groupId: groupId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        sendTime: sendTime,
        messageId: messageId,
        name: senderUserModel.name,
        receiverUserName: receiverUserModel?.name,
        messageType: MessageTypeEnum.text,
        messageReply: messageReply,
        replyReceiverUserName: receiverUserModel?.name,
        replySenderUserName: senderUserModel.name,
        isGroupChat: isGroupChat,
        groupId: groupId,
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
    required UserModel? receiverUserModel,
    required String text,
    required DateTime sendTime,
    required String receiverUserId,
    required bool isGroupChat,
    required String groupId,
  }) async {
    if (isGroupChat) {
      await firestore
          .collection(communityPath)
          .doc(receiverUserId)
          .collection(groupsPath)
          .doc(groupId)
          .update({
        'lastMessage': text,
        'sendTime': sendTime,
      });
    } else {
      // save data to sender user contacts sub collection
      final ChatContact receiverChatContact = ChatContact(
        name: senderUserModel.name,
        profilePic: senderUserModel.profilePic,
        contactId: senderUserModel.uid,
        sendTime: sendTime,
        lastMessage: text,
        otherName: receiverUserModel?.name,
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
        name: receiverUserModel!.name,
        profilePic: receiverUserModel.profilePic,
        contactId: receiverUserModel.uid,
        sendTime: sendTime,
        lastMessage: text,
        otherName: senderUserModel.name,
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
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime sendTime,
    required String messageId,
    required String name,
    required String? receiverUserName,
    required MessageTypeEnum messageType,
    required MessageReply? messageReply,
    required String replySenderUserName,
    required String? replyReceiverUserName,
    required bool isGroupChat,
    required String groupId,
  }) async {
    final Message message = Message(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      sendTime: sendTime,
      messageId: messageId,
      isSeen: false,
      // default value
      repliedMessage: (messageReply == null) ? '' : messageReply.message,
      repliedTo: (messageReply == null)
          ? ''
          : messageReply.isMe
              ? replySenderUserName
              : replyReceiverUserName ?? '',
      repliedType:
          (messageReply == null) ? MessageTypeEnum.text : messageReply.type,
    );

    if (isGroupChat) {
      await firestore
          .collection(communityPath)
          .doc(receiverUserId)
          .collection(groupsPath)
          .doc(groupId)
          .collection(chatsPath)
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
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

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserModel,
    required ProviderRef ref,
    required MessageTypeEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
    required String groupId,
  }) async {
    try {
      final DateTime sendTime = DateTime.now();
      final String messageId = const Uuid().v4();

      final String path =
          '$chatsPath/${messageType.type}/${senderUserModel.uid}/$receiverUserId/$messageId';

      final String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref: path,
            file: file,
          );

      UserModel? receiverUserModel;

      if (!isGroupChat) {
        final DocumentSnapshot<Map<String, dynamic>> receiverUserDataMap =
            await firestore.collection(usersPath).doc(receiverUserId).get();

        if (receiverUserDataMap.data() == null) {
          throw Exception('User data not found');
        }

        receiverUserModel = UserModel.fromMap(
          receiverUserDataMap.data()!,
        );
      }
      String text;

      switch (messageType) {
        case MessageTypeEnum.image:
          text = '📷 Photo';
          break;

        case MessageTypeEnum.video:
          text = '📸 Video';
          break;

        case MessageTypeEnum.audio:
          text = '🎵 Audio';
          break;

        case MessageTypeEnum.gif:
        default:
          text = 'Gif';
      }

      _saveDataToContactsSubCollection(
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        text: text,
        sendTime: sendTime,
        receiverUserId: receiverUserId,
        isGroupChat: isGroupChat,
        groupId: groupId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        sendTime: sendTime,
        messageId: messageId,
        name: senderUserModel.name,
        receiverUserName: receiverUserModel?.name,
        messageType: messageType,
        messageReply: messageReply,
        replySenderUserName: senderUserModel.name,
        replyReceiverUserName: receiverUserModel?.name,
        isGroupChat: isGroupChat,
        groupId: groupId,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUserModel,
    required MessageReply? messageReply,
    required bool isGroupChat,
    required String groupId,
  }) async {
    try {
      final DateTime sendTime = DateTime.now();

      if (firebaseAuth.currentUser == null) {
        throw Exception('User not found');
      }

      UserModel? receiverUserModel;
      if (!isGroupChat) {
        var receiverUserDataMap =
            await firestore.collection(usersPath).doc(receiverUserId).get();

        if (receiverUserDataMap.data() == null) {
          throw Exception('User data not found');
        }

        receiverUserModel = UserModel.fromMap(
          receiverUserDataMap.data()!,
        );
      }

      final String messageId = const Uuid().v4();

      _saveDataToContactsSubCollection(
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        text: 'GIF',
        sendTime: sendTime,
        receiverUserId: receiverUserId,
        isGroupChat: isGroupChat,
        groupId: groupId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        sendTime: sendTime,
        messageId: messageId,
        name: senderUserModel.name,
        receiverUserName: receiverUserModel?.name,
        messageType: MessageTypeEnum.gif,
        messageReply: messageReply,
        replySenderUserName: senderUserModel.name,
        replyReceiverUserName: receiverUserModel?.name,
        isGroupChat: isGroupChat,
        groupId: groupId,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
    required bool isGroupChat,
    required String groupId,
  }) async {
    try {
      if (isGroupChat) {
        await firestore
            .collection(communityPath)
            .doc(receiverUserId)
            .collection(groupsPath)
            .doc(groupId)
            .collection(chatsPath)
            .doc(messageId)
            .update(
          {
            'isSeen': true,
          },
        );
      } else {
        // set message seen to sender user message sub collection
        await firestore
            .collection(usersPath)
            .doc(firebaseAuth.currentUser!.uid)
            .collection(chatsPath)
            .doc(receiverUserId)
            .collection(messagesPath)
            .doc(messageId)
            .update(
          {
            'isSeen': true,
          },
        );

        // set message seen to receiver user message sub collection
        await firestore
            .collection(usersPath)
            .doc(receiverUserId)
            .collection(chatsPath)
            .doc(firebaseAuth.currentUser!.uid)
            .collection(messagesPath)
            .doc(messageId)
            .update(
          {
            'isSeen': true,
          },
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }
}
