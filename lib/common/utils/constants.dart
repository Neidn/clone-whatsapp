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

// firestore path
const String usersPath = 'users';
const String chatsPath = 'chats';
const String messagesPath = 'messages';
const String statusPath = 'status';

// firebase storage path
const String profilePicturePath = 'profilePictures';

// Temp File Name
const String soundTempFile = '_temp_sound.aac';
