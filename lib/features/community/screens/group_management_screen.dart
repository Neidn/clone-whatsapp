import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/features/community/screens/create_group_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_common_icon.dart';
import 'package:clone_whatsapp/features/community/widgets/community_group_card.dart';
import 'package:clone_whatsapp/features/community/widgets/community_wrapper_widget.dart';
import 'package:clone_whatsapp/features/community/widgets/group_card.dart';
import 'package:flutter/material.dart';

class GroupManagementScreen extends StatelessWidget {
  static const String routeName = '/group-management';

  const GroupManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹관리'),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: primaryColor,
              ),
              Text(
                '뒤로',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                    CreateGroupScreen.routeName,
                  );
                },
                child: const CommunityWrapperWidget(
                  vertical: 8,
                  child: Column(
                    children: [
                      GroupCard(
                        icon: Icons.group,
                        title: '새 그룹 만들기',
                      ),
                      const Divider(),
                      GroupCard(
                        icon: Icons.add,
                        title: '기존 그룹 추가',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '이 커뮤니티의 그룹',
                      style: TextStyle(
                        color: greyColor,
                      ),
                    ),
                    Text(
                      '편집',
                      style: TextStyle(
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const CommunityWrapperWidget(
                vertical: 8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CommunityCommonIcon(
                              icon: Icons.campaign,
                              iconColor: Colors.blueAccent,
                              // #003458
                              backgroundColor: Color.fromRGBO(0, 52, 88, 1),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '공지사항',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
