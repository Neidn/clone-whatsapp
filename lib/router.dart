import 'dart:io';

import 'package:clone_whatsapp/features/community/screens/community_detail_screen.dart';
import 'package:clone_whatsapp/features/community/screens/community_screen.dart';
import 'package:clone_whatsapp/features/community/screens/create_community_screen.dart';
import 'package:clone_whatsapp/features/community/screens/create_group_screen.dart';
import 'package:clone_whatsapp/features/community/screens/group_management_screen.dart';
import 'package:clone_whatsapp/features/status/screen/confirm_status_screen.dart';
import 'package:clone_whatsapp/features/status/screen/status_screen.dart';
import 'package:clone_whatsapp/models/status_model.dart';
import 'package:flutter/material.dart';

import 'widgets/error.dart';

import '/screens/mobile_layout_screen.dart';
import '/screens/mobile_chat_screen.dart';

import '/features/auth/screens/otp_screen.dart';
import '/features/auth/screens/login_screen.dart';
import '/features/auth/screens/user_information_screen.dart';

import '/features/chat/screens/chat_screen.dart';

import '/features/select_contact/screens/select_contact_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );

    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;

      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: arguments['name'],
          uid: arguments['uid'],
          isGroupChat: arguments['isGroupChat'],
          groupId: arguments['groupId'],
          profilePic: arguments['profilePic'],
        ),
      );

    case ChatScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      );

    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;

      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );

    case StatusScreen.routeName:
      final status = settings.arguments as Status;

      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );

    case CommunityScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CommunityScreen(),
      );

    case CreateGroupScreen.routeName:
      final String communityId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) => CreateGroupScreen(
          communityId: communityId,
        ),
      );

    case GroupManagementScreen.routeName:
      final String communityId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) => GroupManagementScreen(
          communityId: communityId,
        ),
      );

    case CreateCommunityScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateCommunityScreen(),
      );

    case CommunityDetailScreen.routeName:
      final communityId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) => CommunityDetailScreen(
          communityId: communityId,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page does not exist!'),
        ),
      );
  }
}
