class Community {
  final String adminId;
  final String name;
  final String communityId;
  final String communityPic;
  final List<String> groups;
  final String lastMessage;
  final DateTime lastMessageTime;

  Community({
    required this.adminId,
    required this.name,
    required this.communityId,
    required this.communityPic,
    required this.groups,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Community.fromMap(Map<String, dynamic> map) => Community(
        adminId: map['adminId'] ?? '',
        name: map['name'] ?? '',
        communityId: map['communityId'] ?? '',
        communityPic: map['communityPic'] ?? '',
        groups: List<String>.from(map['groups'] ?? []),
        lastMessage: map['lastMessage'] ?? '',
        lastMessageTime: map['lastMessageTime']?.toDate() ?? DateTime.now(),
      );

  toMap() => {
        'adminId': adminId,
        'name': name,
        'communityId': communityId,
        'communityPic': communityPic,
        'groups': groups,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
      };
}
