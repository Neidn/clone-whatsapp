import 'dart:io';

import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  static const String routeName = '/create-group';

  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late final TextEditingController _groupNameController;
  File? _image;

  @override
  void initState() {
    _groupNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _selectImage({
    required BuildContext context,
  }) async {
    pickImageFromGallery(context: context).then((File? pickedImage) {
      if (pickedImage == null) {
        showSnackBar(
          context: context,
          content: 'Failed to pick image',
        );
        return;
      }

      setState(() {
        _image = pickedImage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 그룹'),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Center(
            child: Text(
              '취소',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Community Profile picture
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

            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              width: double.infinity,
              child: TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  hintText: '그룹 이름',
                  // disable underline
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                maxLines: 1,
                autofocus: true,
                cursorColor: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Select Contacts
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
