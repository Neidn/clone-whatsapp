class Community {
  final String adminId;
  final String name;
  final String communityId;
  final String communityPic;
  final String description;
  final List<String> groups;
  final List<String> members;
  final String lastMessage;
  final DateTime lastMessageTime;

  Community({
    required this.adminId,
    required this.name,
    required this.communityId,
    required this.communityPic,
    required this.description,
    required this.groups,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Community.fromMap(Map<String, dynamic> map) => Community(
        adminId: map['adminId'] ?? '',
        name: map['name'] ?? '',
        communityId: map['communityId'] ?? '',
        communityPic: map['communityPic'] ?? '',
        description: map['description'] ?? '',
        groups: List<String>.from(map['groups'] ?? []),
        members: List<String>.from(map['members'] ?? []),
        lastMessage: map['lastMessage'] ?? '',
        lastMessageTime: map['lastMessageTime']?.toDate() ?? DateTime.now(),
      );

  toMap() => {
        'adminId': adminId,
        'name': name,
        'communityId': communityId,
        'communityPic': communityPic,
        'description': description,
        'groups': groups,
        'members': members,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
      };
}
