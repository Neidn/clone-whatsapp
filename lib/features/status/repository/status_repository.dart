import 'dart:io';

import 'package:clone_whatsapp/common/repositories/common_firebase_storage_repository.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/models/status_model.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    ref: ref,
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class StatusRepository {
  final ProviderRef ref;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  StatusRepository({
    required this.ref,
    required this.firestore,
    required this.firebaseAuth,
  });

  void uploadStatus({
    required BuildContext context,
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required List<Contact> contacts,
  }) async {
    try {
      final String statusId = const Uuid().v1();
      final String uid = firebaseAuth.currentUser!.uid;
      final String refPath = '$statusPath/$statusId$uid';

      final String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref: refPath,
            file: statusImage,
          );

      // Get all viewers
      final List<String> viewers = [];

      for (Contact contact in contacts) {
        if (contact.phones.isEmpty) {
          continue;
        }

        var userFirebaseData = await firestore
            .collection(usersPath)
            .where(
              'phoneNumber',
              isEqualTo:
                  contact.phones.first.number.replaceAll(RegExp('[- ]'), ''),
            )
            .get();
        if (userFirebaseData.docs.isNotEmpty) {
          var userModelData = UserModel.fromMap(
            userFirebaseData.docs.first.data(),
          );
          viewers.add(userModelData.uid);
        }
      }

      List<String> statusImageUrlList = [];

      final statusSnapshot = await firestore
          .collection(statusPath)
          .where('uid', isEqualTo: uid)
          .get();

      if (statusSnapshot.docs.isNotEmpty) {
        final Status status = Status.fromMap(statusSnapshot.docs.first.data());

        statusImageUrlList = status.photoUrl;
        statusImageUrlList.add(imageUrl);

        await firestore
            .collection(statusPath)
            .doc(statusSnapshot.docs.first.id)
            .update(
          {
            'photoUrl': statusImageUrlList,
          },
        );
        return;
      } else {
        statusImageUrlList.add(imageUrl);
        Status status = Status(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrlList,
          uploadTime: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          viewers: viewers,
        );

        await firestore.collection(statusPath).doc(statusId).set(
              status.toMap(),
            );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      return;
    }
  }

  Future<List<Status>> getStatus({
    required BuildContext context,
    required List<Contact> contacts,
  }) async {
    try {
      final List<Status> statusList = [];

      for (Contact contact in contacts) {
        var statusSnapshot = await firestore
            .collection(statusPath)
            .where(
              'phoneNumber',
              isEqualTo:
                  contact.phones.first.number.replaceAll(RegExp('[- ]'), ''),
            )
            .where('uploadTime',
                isGreaterThan: DateTime.now().subtract(
                  const Duration(days: 1),
                ))
            .get();


        for (var temp in statusSnapshot.docs) {
          Status tempStatus = Status.fromMap(temp.data());
          if (tempStatus.viewers.contains(firebaseAuth.currentUser!.uid)) {
            statusList.add(tempStatus);
          }
        }
      }

      return statusList;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      return [];
    }
  }
}
