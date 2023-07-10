import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/utils/colors.dart';
import 'package:clone_whatsapp/common/utils/constants.dart';
import 'package:clone_whatsapp/features/community/repository/group_repository.dart';
import 'package:clone_whatsapp/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:clone_whatsapp/models/group.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupList extends ConsumerWidget {
  final String communityId;

  const GroupList({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<model.Group>>(
      stream: ref.read(groupRepositoryProvider).getGroups(
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

        final groups = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: smallImageIconSize.width,
                        height: smallImageIconSize.height,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: group.groupPic,
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          group.lastMessage,
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
                      timeago.format(
                        group.lastMessageTime,
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
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        );
      },
    );
  }
}
