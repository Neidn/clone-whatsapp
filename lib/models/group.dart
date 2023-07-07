class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> members;

  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.members,
  });

  factory Group.fromMap(Map<String, dynamic> map) => Group(
        senderId: map['senderId'] ?? '',
        name: map['name'] ?? '',
        groupId: map['groupId'] ?? '',
        lastMessage: map['lastMessage'] ?? '',
        groupPic: map['groupPic'] ?? '',
        members: List<String>.from(map['members'] ?? []),
      );

  toMap() => {
        'senderId': senderId,
        'name': name,
        'groupId': groupId,
        'lastMessage': lastMessage,
        'groupPic': groupPic,
        'members': members,
      };
}
