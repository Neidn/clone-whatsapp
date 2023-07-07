import 'dart:io';

import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/common/utils/utils.dart';
import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:clone_whatsapp/features/community/controller/group_controller.dart';
import 'package:clone_whatsapp/features/community/provider/select_contacts_group_provider.dart';
import 'package:clone_whatsapp/features/community/widgets/select_contacts_group.dart';
import 'package:clone_whatsapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';

  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  late final TextEditingController _groupNameController;
  final List<int> selectedContactsIndex = [];

  bool _isLoading = false;
  File? _image;

  @override
  void initState() {
    _groupNameController = TextEditingController();
    // Update FirebaseAuth user
    ref.read(authControllerProvider).getUserData().then((UserModel? user) {
      if (user == null) {
        return;
      }
      ref.read(selectContactsGroupProvider.notifier).update(
            Contact(
              displayName: user.name,
              phones: [
                Phone(user.phoneNumber),
              ],
            ),
          );
    });
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
    });
  }

  void _selectContact({
    required int index,
    required Contact contact,
  }) async {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
      ref.read(selectContactsGroupProvider.notifier).update(contact);
    }
    setState(() {});
  }

  void _removeContact({
    required int index,
    required Contact contact,
  }) async {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
      ref.read(selectContactsGroupProvider.notifier).remove(contact);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
  }

  void _createGroup() async {
    final String groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      showSnackBar(
        context: context,
        content: 'Please enter group name',
      );
      return;
    }

    getImageFileFromAssets(defaultImage).then((value) {
      setState(() {
        _image = value;
      });
    }).then((_) {
      ref.read(groupControllerProvider).createGroup(
            context: context,
            communityId: 'test',
            groupName: groupName,
            profilePic: _image!,
            selectedContacts: ref
                .read(selectContactsGroupProvider.notifier)
                .getSelectedContacts(),
          );
    }).then((_) {
      ref.read(selectContactsGroupProvider.notifier).reset();
    }).then((_) {
      Navigator.of(context).pop();
    });
  }

  bool _checkIndexExists({
    required int index,
  }) {
    return selectedContactsIndex.contains(index);
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
        actions: [
          InkWell(
            onTap: () {
              if (selectedContactsIndex.isEmpty) return;
              _createGroup();
            },
            child: Center(
              child: Text(
                '다음',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedContactsIndex.isEmpty
                      ? Colors.grey
                      : primaryColor,
                ),
              ),
            ),
          ),
        ],
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
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SelectContactsGroup(
              onSelected: _selectContact,
              onRemoved: _removeContact,
              onIndexExisted: _checkIndexExists,
            ),
          ],
        ),
      ),
    );
  }
}
