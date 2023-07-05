import 'package:clone_whatsapp/features/chat/screens/chat_screen.dart';
import 'package:clone_whatsapp/features/status/screen/status_contacts_screen.dart';
import 'package:flutter/material.dart';

// Pages
const pages = [
  StatusContactsScreen(),
  Center(
    child: Text('Calls'),
  ),
  Center(
    child: Text('Camera'),
  ),
  ChatScreen(),
  Center(
    child: Text('Settings'),
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
