import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:clone_whatsapp/features/call/repository/call_repository.dart';
import 'package:clone_whatsapp/models/call.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) => CallController(
      callRepository: ref.read(callRepositoryProvider),
      ref: ref,
      firebaseAuth: FirebaseAuth.instance,
    ));

final callStreamProvider = StreamProvider.autoDispose<DocumentSnapshot>((ref) {
  return ref.watch(callControllerProvider).getCallStream;
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth firebaseAuth;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.firebaseAuth,
  });

  Stream<DocumentSnapshot> get getCallStream => callRepository.getCallStream;

  Stream<DocumentSnapshot> get getCallDialogStream =>
      callRepository.getCallDialogStream;

  void makeCall({
    required BuildContext context,
    required String receiverId,
    required String receiverName,
    required String receiverPic,
    required bool isGroupChat,
    required String groupId,
  }) async {
    ref.read(userDataAuthProvider).whenData((UserModel? userModel) {
      final String callId = const Uuid().v1();

      final Call senderCall = Call(
        callId: callId,
        callerId: firebaseAuth.currentUser!.uid,
        callerName: userModel!.name,
        callerPic: userModel.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        hasDialled: true,
        isGroupCall: isGroupChat,
        groupId: groupId,
      );

      final Call receiverCall = Call(
        callId: callId,
        callerId: firebaseAuth.currentUser!.uid,
        callerName: userModel.name,
        callerPic: userModel.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        hasDialled: false,
        isGroupCall: isGroupChat,
        groupId: groupId,
      );

      if (!isGroupChat) {
        callRepository.makeCall(
          context: context,
          senderCall: senderCall,
          receiverCall: receiverCall,
        );
      } else {
        callRepository.makeGroupCall(
          context: context,
          senderCall: senderCall,
          receiverCall: receiverCall,
          groupId: groupId,
        );
      }
    });
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
    required bool isGroupChat,
    required String groupId,
  }) {
    if (!isGroupChat) {
      callRepository.endCall(
        context: context,
        callerId: callerId,
        receiverId: receiverId,
      );
    } else {
      callRepository.endGroupCall(
        context: context,
        callerId: callerId,
        receiverId: receiverId,
        groupId: groupId,
      );
    }
  }

  void endCallFromPickup({
    required BuildContext context,
    required Call call,
  }) {
    callRepository.endCallFromPickup(
      context: context,
      call: call,
      receiverId: firebaseAuth.currentUser!.uid,
    );
  }
}
