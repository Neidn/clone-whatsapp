import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
    final GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      apiKey: dotenv.get('GIPHY_API_KEY'),
      // showAttribution: false,
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

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}