class LastChat {
  final String? uid;
  final String? timeStamp;
  final String? message;
  final int fromUnseenCount;
  final int toUnseenCount;

  LastChat({this.uid, this.timeStamp, this.message,this.fromUnseenCount = 0,this.toUnseenCount = 0});

  factory LastChat.fromJson(Map<dynamic, dynamic> item) {
    return LastChat(
      uid: item['uid'] ?? '',
      timeStamp: item['timestamp'] ?? '',
      fromUnseenCount: item['from_unseen_count'] != null ? item['from_unseen_count'] : 0,
      toUnseenCount: item['to_unseen_count'] != null?  item['to_unseen_count'] : 0,
      message: item['message'] ?? '',
    );
  }

  factory LastChat.fromRoom(Map<dynamic, dynamic> item) {
    return LastChat(
      uid: item['uid'] ?? '',
      timeStamp: item['timestamp'] ?? '',
      fromUnseenCount: item['from_unseen_count'] != null ? item['from_unseen_count'] : 0,
      toUnseenCount: item['to_unseen_count'] != null?  item['to_unseen_count'] : 0,
      message: item['message'] ?? '',
    );
  }
}
