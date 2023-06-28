import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:flutter/material.dart';

class PickerBottomSheet extends StatelessWidget {
  final Size size;
  final VoidCallback selectGIF;
  final VoidCallback takePhoto;
  final VoidCallback selectImage;
  final VoidCallback selectVideo;

  const PickerBottomSheet({
    super.key,
    required this.size,
    required this.selectGIF,
    required this.takePhoto,
    required this.selectImage,
    required this.selectVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: size.height * 0.04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Picker Wrapper
          Container(
            decoration: const BoxDecoration(
              color: bottomBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Wrap(
              children: [
                // GIF
                ListTile(
                  leading: const Icon(
                    Icons.gif_box,
                    color: primaryColor,
                  ),
                  title: const Text('GIF'),
                  onTap: () {
                    Navigator.of(context).pop();
                    selectGIF();
                  },
                ),
                // Camera
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: primaryColor,
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    takePhoto();
                  },
                ),
                // Image
                ListTile(
                  leading: const Icon(
                    Icons.image,
                    color: primaryColor,
                  ),
                  title: const Text('Image'),
                  onTap: () {
                    Navigator.of(context).pop();
                    selectImage();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.video_collection,
                    color: primaryColor,
                  ),
                  title: const Text('Video'),
                  onTap: () {
                    Navigator.of(context).pop();
                    selectVideo();
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            height: size.height * 0.008,
          ),

          // Cancel
          Container(
              decoration: const BoxDecoration(
                color: textFieldBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: primaryColor,
                ),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    );
  }
}
