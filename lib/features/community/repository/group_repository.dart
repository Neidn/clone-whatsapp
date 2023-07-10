import 'dart:io';

import 'package:clone_whatsapp/common/repositories/common_firebase_storage_repository.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:clone_whatsapp/models/group.dart' as model;

final groupRepositoryProvider = Provider((ref) => GroupRepository(
      firebaseFirestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
      ref: ref,
    ));

class GroupRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  GroupRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.ref,
  });

  Stream<model.Group> getCommunityNotice({
    required String communityId,
  }) {
    return firebaseFirestore
        .collection(communityPath)
        .doc(communityId)
        .collection(noticePath)
        .snapshots()
        .asyncMap((event) {
      return model.Group.fromMap(event.docs.first.data());
    });
  }

  Stream<List<model.Group>> getGroups({
    required String communityId,
  }) {
    return firebaseFirestore
        .collection(communityPath)
        .doc(communityId)
        .collection(groupsPath)
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) => model.Group.fromMap(e.data())).toList();
    });
  }

  void createGroup({
    required BuildContext context,
    required String communityId,
    required String groupName,
    required File profilePic,
    required List<Contact> selectedContacts,
    bool isNotice = false,
    String? lastMessage,
  }) async {
    try {
      List<String> uidList = [];

      for (var contact in selectedContacts) {
        var userCollection = await firebaseFirestore
            .collection(usersPath)
            .where(
              'phoneNumber',
              isEqualTo:
                  contact.phones.first.number.replaceAll(RegExp('[- ]'), ''),
            )
            .get();
        if (userCollection.docs.isEmpty || !userCollection.docs.first.exists) {
          continue;
        }
        uidList.add(userCollection.docs.first.data()['uid']);
      }

      final String groupId = const Uuid().v1();

      final String groupPicRef = '$groupsPath/$groupId';
      final String groupPic = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref: groupPicRef,
            file: profilePic,
          );

      List<String> members = [...uidList, firebaseAuth.currentUser!.uid];
      members = members.toSet().toList();

      final model.Group group = model.Group(
        senderId: firebaseAuth.currentUser!.uid,
        communityId: communityId,
        name: groupName,
        groupId: groupId,
        lastMessage: lastMessage ?? '',
        lastMessageTime: DateTime.now(),
        groupPic: groupPic,
        members: members,
      );

      if (isNotice) {
        await firebaseFirestore
            .collection(communityPath)
            .doc(communityId)
            .collection(noticePath)
            .doc(groupId)
            .set(group.toMap());
      } else {
        await firebaseFirestore
            .collection(communityPath)
            .doc(communityId)
            .collection(groupsPath)
            .doc(groupId)
            .set(group.toMap());

        await firebaseFirestore
            .collection(communityPath)
            .doc(communityId)
            .update(
          {
            'groups': FieldValue.arrayUnion([groupId]),
            'members': FieldValue.arrayUnion(uidList),
          },
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
