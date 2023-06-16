import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/repository/auth_repository.dart';

final Provider<AuthController> authControllerProvider =
    Provider((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
        ));

class AuthController {
  final AuthRepository authRepository;

  AuthController({
    required this.authRepository,
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
}
