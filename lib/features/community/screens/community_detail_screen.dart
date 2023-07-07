import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/features/community/screens/group_management_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_common_icon.dart';
import 'package:clone_whatsapp/features/community/widgets/community_wrapper_widget.dart';
import 'package:clone_whatsapp/features/community/widgets/group_card.dart';
import 'package:flutter/material.dart';

class CommunityDetailScreen extends StatelessWidget {
  static const routeName = '/community-detail-screen';

  const CommunityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
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
        actions: [
          InkWell(
            onTap: () {},
            child: const Center(
              child: Text(
                '편집',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '커뮤니티 이름',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '커뮤니티',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: ' ・ ',
                  ),
                  TextSpan(
                    text: '그룹 1개',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: const CommunityWrapperWidget(
                      vertical: 8,
                      child: Column(
                        children: [
                          Icon(
                            Icons.link,
                            color: Colors.blueAccent,
                          ),
                          Text(
                            '초대',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: const CommunityWrapperWidget(
                      vertical: 8,
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Colors.blueAccent,
                          ),
                          Text(
                            '멤버',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async => await Navigator.of(context).pushNamed(
                      GroupManagementScreen.routeName,
                    ),
                    child: SizedBox(
                      width: size.width * 0.3,
                      child: const CommunityWrapperWidget(
                        vertical: 8,
                        child: Column(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.blueAccent,
                            ),
                            Text(
                              '그룹 추가',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: double.infinity,
              child: CommunityWrapperWidget(
                child: Text(
                  '커뮤니티 설명',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CommunityWrapperWidget(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async => await Navigator.of(context).pushNamed(
                        GroupManagementScreen.routeName,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '그룹 관리',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '1개',
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '멤버 보기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ],
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '커뮤니티 설정',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // MyGroup
            const SizedBox(height: 24),
            const SizedBox(
              width: double.infinity,
              child: Text(
                '내 그룹',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: double.infinity,
              child: CommunityWrapperWidget(
                vertical: 8,
                child: Row(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '공지사항',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '마지막 메세지',
                              style: TextStyle(
                                fontSize: 14,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '어제',
                          style: TextStyle(
                            fontSize: 14,
                            color: greyColor,
                          ),
                        ),
                        Icon(
                          Icons.bookmark,
                          color: greyColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Other Group
            const SizedBox(height: 24),
            const SizedBox(
              width: double.infinity,
              child: Text(
                '다른 그룹',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async => await Navigator.of(context).pushNamed(
                GroupManagementScreen.routeName,
              ),
              child: const SizedBox(
                width: double.infinity,
                child: CommunityWrapperWidget(
                  vertical: 8,
                  child: GroupCard(
                    icon: Icons.people,
                    title: '그룹 추가',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const SizedBox(
              width: double.infinity,
              child: CommunityWrapperWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '커뮤니티 나가기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    Divider(),
                    Text(
                      '커뮤니티 신고',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    Divider(),
                    Text(
                      '커뮤니티 비활성화',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
