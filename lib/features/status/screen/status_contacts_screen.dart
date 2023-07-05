import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/common/widgets/loader.dart';
import 'package:clone_whatsapp/features/status/controller/status_controller.dart';
import 'package:clone_whatsapp/features/status/screen/confirm_status_screen.dart';
import 'package:clone_whatsapp/models/status_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: FutureBuilder<List<Status>>(
        future: ref.watch(statusControllerProvider).getStatus(
              context: context,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final Status status = snapshot.data![index];

              return Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          status.username,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            status.profilePic,
                          ),
                          radius: 30,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: dividerColor,
                    indent: 85,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
