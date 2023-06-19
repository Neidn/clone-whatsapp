import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/repository/auth_repository.dart';

final Provider<AuthController> authControllerProvider =
    Provider((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      authRepository.signInWithPhone(
        context: context,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      rethrow;
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required File? profilePic,
  }) async {
    authRepository.saveUserDataToFirebase(
      context: context,
      name: name,
      profilePic: profilePic,
      ref: ref,
    );
  }
}
