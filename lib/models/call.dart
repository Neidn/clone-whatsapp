class Call {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final bool hasDialled;

  Call({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.hasDialled,
  });

  factory Call.fromMap(Map<String, dynamic> data) {
    return Call(
      callId: data['callId'],
      callerId: data['callerId'],
      callerName: data['callerName'],
      callerPic: data['callerPic'],
      receiverId: data['receiverId'],
      receiverName: data['receiverName'],
      receiverPic: data['receiverPic'],
      hasDialled: data['hasDialled'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'hasDialled': hasDialled,
    };
  }
}
