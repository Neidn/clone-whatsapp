import 'dart:io';

import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:clone_whatsapp/features/status/repository/status_repository.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusControllerProvider = Provider((ref) => StatusController(
      statusRepository: ref.read(statusRepositoryProvider),
      ref: ref,
    ));

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  Future<void> addStatus({
    required BuildContext context,
    required File file,
  }) async {
    ref.watch(userDataAuthProvider).whenData((UserModel? userModel) {
      if (userModel == null) {
        return;
      }

      statusRepository.uploadStatus(
        context: context,
        username: userModel.name,
        profilePic: userModel.profilePic,
        phoneNumber: userModel.phoneNumber,
        statusImage: file,
      );
    });
  }
}
