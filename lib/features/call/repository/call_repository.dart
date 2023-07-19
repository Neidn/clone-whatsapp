import 'package:clone_whatsapp/models/group.dart' as model;
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/call/screens/call_screen.dart';
import 'package:clone_whatsapp/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final callRepositoryProvider = Provider((ref) => CallRepository(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
      ref: ref,
    ));

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  CallRepository({
    required this.firestore,
    required this.firebaseAuth,
    required this.ref,
  });

  Stream<DocumentSnapshot> get getCallStream => firestore
      .collection(callPath)
      .doc(firebaseAuth.currentUser!.uid)
      .snapshots();

  Stream<DocumentSnapshot> get getCallDialogStream => firestore
          .collection(callPath)
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots()
          .where((event) {
        if (event.exists) {
          final Call call = Call.fromMap(event.data()!);

          if (call.hasDialled) {
            return true;
          }
        }

        return false;
      });

  void makeCall({
    required BuildContext context,
    required Call senderCall,
    required Call receiverCall,
  }) async {
    try {
      await firestore
          .collection(callPath)
          .doc(senderCall.callerId)
          .set(senderCall.toMap());

      await firestore
          .collection(callPath)
          .doc(senderCall.receiverId)
          .set(receiverCall.toMap());

      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
          channelId: senderCall.callerId,
          call: senderCall,
          isGroupChat: false,
          groupId: '',
        ),
      ));
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await firestore.collection(callPath).doc(callerId).delete();

      await firestore.collection(callPath).doc(receiverId).delete();
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void makeGroupCall({
    required BuildContext context,
    required Call senderCall,
    required Call receiverCall,
    required String groupId,
  }) async {
    try {
      await firestore
          .collection(callPath)
          .doc(senderCall.callerId)
          .set(senderCall.toMap());

      var groupSnapshot = await firestore
          .collection(communityPath)
          .doc(senderCall.receiverId)
          .collection(groupsPath)
          .doc(groupId)
          .get();

      if (!groupSnapshot.exists) {
        throw 'Group does not exist';
      }

      final model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (String id in group.members) {
        if (id == senderCall.callerId) continue;

        await firestore.collection(callPath).doc(id).set(receiverCall.toMap());
      }

      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
          channelId: senderCall.callerId,
          call: senderCall,
          isGroupChat: true,
          groupId: groupId,
        ),
      ));
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void endGroupCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
    required String groupId,
  }) async {
    try {
      await firestore.collection(callPath).doc(callerId).delete();

      var groupSnapshot = await firestore
          .collection(communityPath)
          .doc(receiverId)
          .collection(groupsPath)
          .doc(groupId)
          .get();

      if (!groupSnapshot.exists) {
        throw 'Group does not exist';
      }

      final model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (String id in group.members) {
        if (id == callerId) continue;

        await firestore.collection(callPath).doc(id).delete();
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void endCallFromPickup({
    required BuildContext context,
    required Call call,
    required String receiverId,
  }) async {
    try {
      if (!call.isGroupCall) {
        await firestore.collection(callPath).doc(call.callerId).delete();
        await firestore.collection(callPath).doc(call.receiverId).delete();
      } else {
        await firestore.collection(callPath).doc(receiverId).delete();
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
