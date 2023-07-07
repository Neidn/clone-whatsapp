import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:flutter/material.dart';

class CommunityWrapperWidget extends StatelessWidget {
  final Widget child;
  final double vertical;

  const CommunityWrapperWidget({
    super.key,
    required this.child,
    this.vertical = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: vertical,
      ),
      decoration: BoxDecoration(
        color: textFieldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
