class Message {
  final message;
  final from;
  final timeStamp;
  final type;
  final status;
  List<String>? likes = [];
  String? docId;
  int? fromCount = 0;
  int? toCount = 0;
  String? profileImage = '';

  Message({this.message, this.from, this.timeStamp, this.type, this.status, this.profileImage, this.docId, this.likes});

  Message.chat({this.message, this.from, this.timeStamp, this.type, this.status,this.toCount,this.fromCount});
}
