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

  void makeCall({
    required BuildContext context,
    required String receiverId,
    required String receiverName,
    required String receiverPic,
    required bool isGroupChat,
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
      );

      callRepository.makeCall(
        context: context,
        senderCall: senderCall,
        receiverCall: receiverCall,
      );
    });
  }
}
