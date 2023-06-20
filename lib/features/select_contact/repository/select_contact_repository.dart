import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/constants.dart';
import '/common/utils/utils.dart';

import '/models/user_model.dart';

import '/screens/mobile_chat_screen.dart';

final Provider<SelectContactRepository> selectContactRepositoryProvider =
    Provider<SelectContactRepository>(
  (ref) => SelectContactRepository(
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactRepository({
    required this.firebaseFirestore,
  });

  Future<List<Contact>> getContacts() async {
    try {
      final bool hasPermission = await FlutterContacts.requestPermission();
      if (!hasPermission) {
        throw Exception('Permission not granted');
      }

      return await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> selectContact({
    required BuildContext context,
    required Contact selectedContact,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> userCollection =
          await firebaseFirestore.collection(usersPath).get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        final UserModel userModel = UserModel.fromMap(document.data());

        final String selectedPhoneNumber =
            selectedContact.phones.first.number.replaceAll(RegExp('[- ]'), '');

        if (userModel.phoneNumber == selectedPhoneNumber) {
          isFound = true;
          Navigator.of(context).pushNamed(
            MobileChatScreen.routeName,
            arguments: {
              'name': userModel.name,
              'uid': userModel.uid,
            },
          );
          return;
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app',
        );
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
