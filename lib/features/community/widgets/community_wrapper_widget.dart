import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:flutter/material.dart';

class CommunityWrapperWidget extends StatelessWidget {
  final Widget child;

  const CommunityWrapperWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: textFieldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
