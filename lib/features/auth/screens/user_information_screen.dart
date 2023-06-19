import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/common/utils/utils.dart';

class UserInformationScreen extends StatefulWidget {
  static const routeName = '/user-information-screen';

  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  late final TextEditingController _nameController;
  final String _defaultImageUrl =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

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
                          backgroundImage: CachedNetworkImageProvider(
                            _defaultImageUrl,
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
                    onPressed: () => {},
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
