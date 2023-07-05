class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime uploadTime;
  final String profilePic;
  final String statusId;

  // List of user id who can see this status
  final List<String> viewers;

  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.uploadTime,
    required this.profilePic,
    required this.statusId,
    required this.viewers,
  });

  factory Status.fromMap(Map<String, dynamic> map) => Status(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        photoUrl: List<String>.from(map['photoUrl'] as List<dynamic>),
        uploadTime: (map['uploadTime']).toDate(),
        profilePic: map['profilePic'] ?? '',
        statusId: map['statusId'] ?? '',
        viewers: List<String>.from(map['viewers'] as List<dynamic>),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'uid': uid,
        'username': username,
        'phoneNumber': phoneNumber,
        'photoUrl': photoUrl,
        'uploadTime': uploadTime,
        'profilePic': profilePic,
        'statusId': statusId,
        'viewers': viewers,
      };
}
