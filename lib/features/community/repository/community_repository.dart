import 'dart:io';

import 'package:clone_whatsapp/common/repositories/common_firebase_storage_repository.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:clone_whatsapp/features/community/controller/group_controller.dart';
import 'package:clone_whatsapp/models/community.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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
        groups: [],
        lastMessage: '',
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
