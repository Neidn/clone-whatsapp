import 'dart:io';

import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/utils.dart';
import '/common/utils/constants.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information-screen';

  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  late final TextEditingController _nameController;

  File? _image;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _selectImage({required BuildContext context}) {
    pickImageFromGallery(context: context).then((File? image) {
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    });
  }

  void _storeUserData() async {
    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      showSnackBar(
        context: context,
        content: 'Please enter your name',
      );
      return;
    }

    ref.read(authControllerProvider).saveUserDataToFirebase(
          context: context,
          name: name,
          profilePic: _image,
        );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Profile picture
              Stack(
                children: [
                  _image == null
                      ? CircleAvatar(
                          backgroundImage: const AssetImage(
                            defaultImage,
                          ),
                          radius: size.width * 0.2,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(_image!),
                          radius: size.width * 0.2,
                        ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      onPressed: () => _selectImage(context: context),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _storeUserData(),
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
