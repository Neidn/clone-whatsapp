class Group {
  final String senderId;
  final String communityId;
  final String name;
  final String groupId;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String groupPic;
  final List<String> members;

  Group({
    required this.senderId,
    required this.communityId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.groupPic,
    required this.members,
  });

  factory Group.fromMap(Map<String, dynamic> map) => Group(
        senderId: map['senderId'] ?? '',
        communityId: map['communityId'] ?? '',
        name: map['name'] ?? '',
        groupId: map['groupId'] ?? '',
        lastMessage: map['lastMessage'] ?? '',
        lastMessageTime: map['lastMessageTime']?.toDate() ?? DateTime.now(),
        groupPic: map['groupPic'] ?? '',
        members: List<String>.from(map['members'] ?? []),
      );

  toMap() => {
        'senderId': senderId,
        'communityId': communityId,
        'name': name,
        'groupId': groupId,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
        'groupPic': groupPic,
        'members': members,
      };
}
