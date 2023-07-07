import 'dart:io';

import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  static const routeName = '/create-community-screen';

  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  late final TextEditingController _communityNameController;
  late final TextEditingController _communityDescriptionController;

  bool _isLoading = false;
  File? _image;

  @override
  void initState() {
    _communityNameController = TextEditingController();
    _communityDescriptionController = TextEditingController(
      text: communityDefaultDescription,
    );
    super.initState();
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    _communityDescriptionController.dispose();
    super.dispose();
  }

  void _selectImage({
    required BuildContext context,
  }) async {
    setState(() {
      _isLoading = true;
    });
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
        _isLoading = false;
      });
    }).catchError((error) {
      showSnackBar(
        context: context,
        content: 'Failed to pick image',
      );
      setState(() {
        _isLoading = false;
        _image = null;
      });
    });
  }

  void _createCommunity() {
    final String communityName = _communityNameController.text.trim();

    if (communityName.isEmpty) {
      showSnackBar(
        context: context,
        content: 'Please enter community name',
      );
      return;
    }

    getImageFileFromAssets(defaultImage).then((value) {
      setState(() {
        _image = value;
      });
    }).then((_) {
      ref.read(communityControllerProvider).createCommunity(
            context: context,
            communityName: communityName,
            profilePic: _image!,
            communityDescription: _communityDescriptionController.text.trim(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 커뮤니티'),
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
            _isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0)),
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
                controller: _communityNameController,
                decoration: const InputDecoration(
                  hintText: '커뮤니티 이름',
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
                controller: _communityDescriptionController,
                decoration: const InputDecoration(
                  hintText: communityDescriptionHint,
                  // disable underline
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                maxLines: 8,
                cursorColor: primaryColor,
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                minimumSize: Size(size.width * 0.8, 40),
              ),
              onPressed: () => _createCommunity(),
              child: const Text('커뮤니티 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
