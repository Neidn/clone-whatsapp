import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/features/community/repository/group_repository.dart';
import 'package:clone_whatsapp/features/community/screens/create_group_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_common_icon.dart';
import 'package:clone_whatsapp/features/community/widgets/community_wrapper_widget.dart';
import 'package:clone_whatsapp/features/community/widgets/group_card.dart';
import 'package:clone_whatsapp/screens/mobile_chat_screen.dart';
import 'package:clone_whatsapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clone_whatsapp/models/group.dart' as model;

class GroupManagementScreen extends ConsumerWidget {
  static const String routeName = '/group-management';

  final String communityId;

  const GroupManagementScreen({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              CommunityWrapperWidget(
                vertical: 8,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await Navigator.of(context).pushNamed(
                          CreateGroupScreen.routeName,
                          arguments: communityId,
                        );
                      },
                      child: const GroupCard(
                        icon: Icons.group,
                        title: '새 그룹 만들기',
                      ),
                    ),
                    const Divider(),
                    const GroupCard(
                      icon: Icons.add,
                      title: '기존 그룹 추가',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
              StreamBuilder<model.Group>(
                  stream: ref.read(groupRepositoryProvider).getCommunityNotice(
                        communityId: communityId,
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Loader(),
                      );
                    }

                    final noticeGroup = snapshot.data!;

                    return CommunityWrapperWidget(
                      vertical: 8,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await Navigator.of(context).pushNamed(
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': noticeGroup.name,
                                  'uid': communityId,
                                  'isGroupChat': true,
                                  'groupId': noticeGroup.groupId,
                                  'profilePic': noticeGroup.groupPic,
                                },
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CommunityCommonIcon(
                                      icon: Icons.campaign,
                                      iconColor: Colors.blueAccent,
                                      backgroundColor:
                                          Color.fromRGBO(0, 52, 88, 1),
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                          StreamBuilder<List<model.Group>>(
                            stream: ref.read(groupRepositoryProvider).getGroups(
                                  communityId: communityId,
                                ),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Something went wrong'),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Loader(),
                                );
                              }

                              final groups = snapshot.data!;

                              return ListView.builder(
                                padding: const EdgeInsets.only(bottom: 0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  final group = groups[index];

                                  return InkWell(
                                    onTap: () async {
                                      await Navigator.of(context).pushNamed(
                                        MobileChatScreen.routeName,
                                        arguments: {
                                          'name': group.name,
                                          'uid': communityId,
                                          'isGroupChat': true,
                                          'groupId': group.groupId,
                                          'profilePic': group.groupPic,
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: smallImageIconSize.width,
                                                    height:
                                                        smallImageIconSize.height,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                      child: CachedNetworkImage(
                                                        imageUrl: group.groupPic,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                                const SizedBox(width: 16),
                                                Text(
                                                  group.name,
                                                  style: const TextStyle(
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
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
