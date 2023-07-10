class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime sendTime;
  final String lastMessage;
  final String? otherName;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.sendTime,
    required this.lastMessage,
    required this.otherName,
  });

  factory ChatContact.fromMap(Map<String, dynamic> map) => ChatContact(
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        contactId: map['contactId'] ?? '',
        sendTime: DateTime.parse(map['sendTime']),
        lastMessage: map['lastMessage'] ?? '',
        otherName: map['otherName'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'profilePic': profilePic,
        'contactId': contactId,
        'sendTime': sendTime.toString(),
        'lastMessage': lastMessage,
        'otherName': otherName,
      };
}
