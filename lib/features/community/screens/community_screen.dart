import 'package:clone_whatsapp/features/community/screens/community_detail_screen.dart';
import 'package:clone_whatsapp/features/community/screens/create_community_screen.dart';
import 'package:clone_whatsapp/features/community/screens/create_group_screen.dart';
import 'package:clone_whatsapp/features/community/widgets/community_group_card.dart';
import 'package:clone_whatsapp/features/community/widgets/new_community.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  static const String routeName = '/community-screen';

  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: 10,
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

            return CommunityGroupCard(
              communityName: 'test',
              groupTitle: 'test',
              lastMessage: 'hiiii',
            );
          },
        ),
      ),
    );
  }
}
