import 'dart:io';

import 'package:clone_whatsapp/features/community/repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupControllerProvider = Provider((ref) => GroupController(
      groupRepository: ref.read(groupRepositoryProvider),
      ref: ref,
    ));

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String communityId,
    required String groupName,
    required File profilePic,
    required List<Contact> selectedContacts,
    bool isNotice = false,
  }) {
    groupRepository.createGroup(
      context: context,
      communityId: communityId,
      groupName: groupName,
      profilePic: profilePic,
      selectedContacts: selectedContacts,
      isNotice: isNotice,
    );
  }
}
