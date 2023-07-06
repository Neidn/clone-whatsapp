import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:flutter/material.dart';

class CommunityCommonIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Icon? addIcon;
  final Color addIconBackgroundColor;

  const CommunityCommonIcon({
    super.key,
    required this.icon,
    this.backgroundColor = greyColor,
    this.iconColor = Colors.white,
    this.addIcon,
    this.addIconBackgroundColor = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 32,
              color: iconColor,
            ),
          ),
        ),
        if (addIcon != null)
          Positioned(
            right: -4,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: addIconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: addIcon,
              ),
            ),
          ),
      ],
    );
  }
}
