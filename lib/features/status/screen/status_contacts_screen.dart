import 'dart:io';

import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/status/screen/confirm_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: const Text(
          '개인정보보호',
          style: TextStyle(
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () => pickImageFromGallery(context: context).then(
          (File? file) {
            if (file == null) {
              return;
            }

            Navigator.of(context).pushNamed(
              ConfirmStatusScreen.routeName,
              arguments: file,
            );
          },
        ),
        icon: const Icon(
          Icons.arrow_circle_right,
          color: primaryColor,
          size: 32,
        ),
      ),
    );
  }
}
