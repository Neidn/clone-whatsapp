import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/features/community/screens/community_detail_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_common_icon.dart';
import 'package:clone_whatsapp/features/community/widgets/community_wrapper_widget.dart';
import 'package:flutter/material.dart';

class CommunityGroupCard extends StatelessWidget {
  final String communityId;
  
  final String communityName;
  final String groupTitle;
  final String? lastMessage;

  const CommunityGroupCard({
    super.key,
    required this.communityId,
    required this.communityName,
    required this.groupTitle,
    this.lastMessage,
  });

  @override
  Widget build(BuildContext context) {
    return CommunityWrapperWidget(
      child: Column(
        children: [
          // Community Name
          InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                CommunityDetailScreen.routeName,
                arguments: communityId,
              );
            },
            child: Row(
              children: [
                const CommunityCommonIcon(
                  icon: Icons.people,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      communityName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Group Title
          Row(
            children: [
              const CommunityCommonIcon(
                icon: Icons.people,
                iconColor: Colors.blueAccent,
                // #003458
                backgroundColor: Color.fromRGBO(0, 52, 88, 1),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (lastMessage != null && lastMessage!.isNotEmpty)
                    Text(
                      lastMessage!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: greyColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const Divider(),
          InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                CommunityDetailScreen.routeName,
                arguments: communityId,
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '모두보기',
                  style: TextStyle(
                    fontSize: 16,
                    color: greyColor,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: greyColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
