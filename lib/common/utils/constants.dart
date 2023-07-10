import 'package:clone_whatsapp/features/chat/screens/chat_screen.dart';
import 'package:clone_whatsapp/features/community/screens/community_screen.dart';
import 'package:clone_whatsapp/features/status/screen/status_contacts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Pages
final pages = [
  const StatusContactsScreen(),
  const Center(
    child: Text('Calls'),
  ),
  const CommunityScreen(),
  const ChatScreen(),
  Center(
    child: IconButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      icon: const Icon(Icons.logout),
    ),
  ),
];

const String defaultImage = "assets/images/blank-profile.png";

const configFileName = '.env';

// Chat Constants
Map<String, int> chatLines = {
  "min": 1,
  "max": 5,
};

const Size smallImageIconSize = Size(40, 40);
const Size largeImageIconSize = Size(100, 100);

// firestore path
const String usersPath = 'users';
const String chatsPath = 'chats';
const String messagesPath = 'messages';
const String statusPath = 'status';
const String communityPath = 'community';
const String groupsPath = 'groups';
const String noticePath = 'notice';

// firebase storage path
const String profilePicturePath = 'profilePictures';

// Temp File Name
const String soundTempFile = '_temp_sound.aac';

const String communityDescriptionHint = '어떤 커뮤니티인지 설명햊쉐요. 멤버 규칙을 추가하는 것이 좋습니다.';
const String communityDefaultDescription =
    '안녕하세요! 이 커뮤니티는 멤버들이 주제 기반 그룹에서 대화하고 중요한 공지사항을 확인할 수 있는 커뮤니티 입니다.';
const String communityLastMessage = '커뮤니티에 오신 것을 환영합니다!';
const String defaultNoticeGroup = '공지사항';
