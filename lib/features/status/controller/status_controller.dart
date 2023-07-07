import 'dart:io';

import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:clone_whatsapp/features/select_contact/controller/select_contact_controller.dart';
import 'package:clone_whatsapp/features/status/repository/status_repository.dart';
import 'package:clone_whatsapp/models/status_model.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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
    final List<Contact> contacts =
        await ref.read(selectedContactControllerProvider).getContacts();

    // get contact from provider
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
        contacts: contacts,
      );
    });
  }

  Future<List<Status>> getStatus({
    required BuildContext context,
  }) async {
    final contacts =
        await ref.read(selectedContactControllerProvider).getContacts();

    return await statusRepository.getStatus(
      context: context,
      contacts: contacts,
    );
  }
}
