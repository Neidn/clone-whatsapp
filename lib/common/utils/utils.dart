import 'dart:io';

import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
    ));

Future<File?> pickImageFromGallery({
  required BuildContext context,
}) async {
  try {
    final XFile? pickedFile = await ImagePicker().pickImage(
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

Future<File?> pickImageFromCamera({
  required BuildContext context,
}) async {
  try {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
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
      content: 'Error picking image from camera',
    );
    return null;
  }
}

Future<File?> pickVideoFromGallery({
  required BuildContext context,
}) async {
  try {
    final XFile? pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      showSnackBar(
        context: context,
        content: 'No video selected',
      );
      return null;
    }

    return File(pickedFile.path);
  } catch (e) {
    showSnackBar(
      context: context,
      content: 'Error picking video from gallery',
    );
    return null;
  }
}

Future<GiphyGif?> pickGIF({
  required BuildContext context,
}) async {
  try {
    final GiphyGif? gif = await Giphy.getGif(
      context: context,
      apiKey: apiKey,
      showAttribution: false,
    );

    if (gif == null) {
      showSnackBar(
        context: context,
        content: 'No GIF selected',
      );
      return null;
    }

    return gif;
  } catch (e) {
    showSnackBar(
      context: context,
      content: e.toString(),
    );
    return null;
  }
}
