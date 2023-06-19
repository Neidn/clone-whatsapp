import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

      return await FlutterContacts.getContacts();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
