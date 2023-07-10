import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/features/community/controller/community_controller.dart';
import 'package:clone_whatsapp/features/community/screens/group_management_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_common_icon.dart';
import 'package:clone_whatsapp/features/community/widgets/community_wrapper_widget.dart';
import 'package:clone_whatsapp/features/community/widgets/group_card.dart';
import 'package:clone_whatsapp/features/community/widgets/group_list.dart';
import 'package:clone_whatsapp/models/community.dart';
import 'package:clone_whatsapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityDetailScreen extends ConsumerWidget {
  static const routeName = '/community-detail-screen';

  final String communityId;

  const CommunityDetailScreen({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: StreamBuilder<Community>(
            stream: ref.watch(communityControllerProvider).getCommunity(
                  communityId: communityId,
                ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (!snapshot.hasData) {
                return const Loader();
              }

              final Community community = snapshot.data!;

              final int groupCount = community.groups.length + 1;

              return Column(
                children: [
                  Center(
                    child: community.communityPic.isEmpty
                        ? Container(
                            width: largeImageIconSize.width,
                            height: largeImageIconSize.height,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 50,
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  community.communityPic,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    community.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '커뮤니티',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const TextSpan(
                          text: ' ・ ',
                        ),
                        TextSpan(
                          text: '그룹 $groupCount개',
                          style: const TextStyle(
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
                          onTap: () async =>
                              await Navigator.of(context).pushNamed(
                            GroupManagementScreen.routeName,
                            arguments: communityId,
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
                  SizedBox(
                    width: double.infinity,
                    child: CommunityWrapperWidget(
                      child: Text(
                        community.description,
                        style: const TextStyle(
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
                            onTap: () async =>
                                await Navigator.of(context).pushNamed(
                              GroupManagementScreen.routeName,
                              arguments: communityId,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '그룹 관리',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '$groupCount개',
                                    ),
                                    const Icon(
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

                  SizedBox(
                    width: double.infinity,
                    child: CommunityWrapperWidget(
                      vertical: 8,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CommunityCommonIcon(
                                    icon: Icons.campaign,
                                    iconColor: Colors.blueAccent,
                                    // #003458
                                    backgroundColor:
                                        Color.fromRGBO(0, 52, 88, 1),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '공지사항',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // TODO: change group listview builder
                                      Text(
                                        community.lastMessage,
                                        style: const TextStyle(
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
                                    // TODO: change group listview builder
                                    timeago.format(
                                      community.lastMessageTime,
                                      locale: 'ko',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: greyColor,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.bookmark,
                                    color: greyColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          GroupList(
                            communityId: communityId,
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
                      arguments: communityId,
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
              );
            }),
      ),
    );
  }
}
