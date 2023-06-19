import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({
  required BuildContext context,
  required String content,

}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery({
  required BuildContext context,
}) async {
  try {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      showSnackBar(
        context: context,
        content: 'No image selected',
      );
      return null;
    }

    return File(pickedFile.path);
  } catch (e) {
    showSnackBar(
      context: context,
      content: 'Error picking image from gallery',
    );
    return null;
  }
}
