import 'package:clone_whatsapp/features/community/widgets/community_common_icon.dart';
import 'package:clone_whatsapp/features/community/widgets/community_wrapper_widget.dart';
import 'package:flutter/material.dart';

class NewCommunity extends StatelessWidget {
  const NewCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommunityWrapperWidget(
      child: Row(
        children: [
          CommunityCommonIcon(
            icon: Icons.people,
            addIcon: Icon(
              Icons.add,
              size: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Text(
            '새 커뮤니티',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
