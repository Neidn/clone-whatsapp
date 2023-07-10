import 'package:clone_whatsapp/features/community/controller/community_controller.dart';
import 'package:clone_whatsapp/features/community/screens/create_community_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_group_card.dart';
import 'package:clone_whatsapp/features/community/widgets/new_community.dart';
import 'package:clone_whatsapp/models/community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityScreen extends ConsumerWidget {
  static const String routeName = '/community-screen';

  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Community>>(
          stream: ref.watch(communityControllerProvider).getCurrentCommunityData(),
          builder: (context, snapshot) {

            final int length = (snapshot.data?.length ?? 0) + 1;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                itemCount: length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '커뮤니티',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        InkWell(
                          onTap: () async {
                            await Navigator.of(context).pushNamed(
                              CreateCommunityScreen.routeName,
                            );
                          },
                          child: const NewCommunity(),
                        ),
                      ],
                    );
                  }

                  final Community community = snapshot.data![index - 1];
                  return CommunityGroupCard(
                    communityId: community.communityId,
                    communityName: community.name,
                    groupTitle: '공지사항',
                    lastMessage: community.lastMessage,
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }
}
