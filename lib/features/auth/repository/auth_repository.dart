import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/utils.dart';
import '/common/utils/constants.dart';

import '/models/user_model.dart';

import '/common/repositories/common_firebase_storage_repository.dart';

import '/features/auth/screens/otp_screen.dart';
import '/features/auth/screens/user_information_screen.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider((ref) => AuthRepository(
          firebaseAuth: FirebaseAuth.instance,
          firebaseFirestore: FirebaseFirestore.instance,
        ));

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) {
          throw Exception(verificationFailed.message);
        },
        codeSent: (verificationId, resendingToken) {
          Navigator.of(context).pushNamed(
            OTPScreen.routeName,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        content: e.message ?? 'Something went wrong!',
      );
      rethrow;
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );

      firebaseAuth.signInWithCredential(credential).then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          UserInformationScreen.routeName,
          (route) => false,
        );
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        content: e.message ?? 'Something went wrong!',
      );
      rethrow;
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }

  // Save user information to firestore
  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required File? profilePic,
    required ProviderRef ref,
  }) async {
    try {
      final String uid = firebaseAuth.currentUser!.uid;
      String photoUrl = defaultImageUrl;

      if (profilePic == null) {
        return;
      }

      photoUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref: '$profilePicturePath/$uid',
            file: profilePic,
          );

      final UserModel user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: firebaseAuth.currentUser!.phoneNumber!,
        groupId: [],
      );

      firebaseFirestore.collection(usersPath).doc(uid).set(user.toMap()).then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          UserInformationScreen.routeName,
          (route) => false,
        );
      });
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
      rethrow;
    }
  }
}
