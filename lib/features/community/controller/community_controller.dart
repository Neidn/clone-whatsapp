import 'dart:io';

import 'package:clone_whatsapp/features/community/repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityControllerProvider = Provider((ref) => CommunityController(
      communityRepository: ref.read(communityRepositoryProvider),
      ref: ref,
    ));

class CommunityController {
  final CommunityRepository communityRepository;
  final ProviderRef ref;

  CommunityController({
    required this.communityRepository,
    required this.ref,
  });

  void createCommunity({
    required BuildContext context,
    required String communityName,
    required File profilePic,
    required String communityDescription,
  }) {
    communityRepository.createCommunity(
      context: context,
      communityName: communityName,
      profilePic: profilePic,
      communityDescription: communityDescription,
    );
  }
}
