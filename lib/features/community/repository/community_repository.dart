import 'dart:io';

import 'package:clone_whatsapp/common/repositories/common_firebase_storage_repository.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/community/controller/group_controller.dart';
import 'package:clone_whatsapp/models/community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final communityRepositoryProvider = Provider((ref) => CommunityRepository(
      firebaseFirestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
      ref: ref,
    ));

class CommunityRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  CommunityRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.ref,
  });

  Stream<List<Community>> getCurrentCommunityData() {
    return firebaseFirestore
        .collection(communityPath)
        .where('members', arrayContains: firebaseAuth.currentUser!.uid)
        .snapshots()
        .asyncMap((event) async {
      final List<Community> communities = [];

      for (final DocumentSnapshot community in event.docs) {
        communities.add(
          Community.fromMap(community.data() as Map<String, dynamic>),
        );
      }

      return communities;
    });
  }

  Stream<Community> getCommunity({required String communityId}) {
    return firebaseFirestore
        .collection(communityPath)
        .doc(communityId)
        .snapshots()
        .asyncMap((event) async {
      return Community.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  void createCommunity({
    required BuildContext context,
    required String communityName,
    required File profilePic,
    required String communityDescription,
  }) async {
    try {
      final String communityId = const Uuid().v1();

      final String communityPicRef = '$communityPath/$communityId';
      final String communityPic = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref: communityPicRef,
            file: profilePic,
          );

      Community community = Community(
        adminId: firebaseAuth.currentUser!.uid,
        name: communityName,
        communityId: communityId,
        communityPic: communityPic,
        description: communityDescription,
        groups: [],
        members: [firebaseAuth.currentUser!.uid],
        lastMessage: communityLastMessage,
        lastMessageTime: DateTime.now(),
      );

      firebaseFirestore
          .collection(communityPath)
          .doc(communityId)
          .set(
            community.toMap(),
          )
          .then((_) {
        ref.read(groupControllerProvider).createGroup(
              context: context,
              communityId: communityId,
              groupName: '공지사항',
              profilePic: profilePic,
              selectedContacts: [],
              isNotice: true,
              lastMessage: communityLastMessage,
            );
      });
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
