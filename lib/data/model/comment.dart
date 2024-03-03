class Comments {
  final int? id, mediaId, date, replies, edited;
  final String? email, name;
  String? content;

  Comments(
      {this.id,
      this.mediaId,
      this.email,
      this.name,
      this.content,
      this.date,
      this.replies,
      this.edited});

  factory Comments.fromJson(Map<String, dynamic> json) {
    int? id = json['id'] != null ? int.parse(json['id'].toString()) : null;
    int? mediaId = json['media_id'] != null
        ? int.parse(json['media_id'].toString())
        : null;
    int? date = int.parse(json['date'].toString());
    int? replies =
        json['replies'] != null ? int.parse(json['replies'].toString()) : null;
    int? edited =
        json['edited'] != null ? int.parse(json['edited'].toString()) : null;

    return Comments(
        id: id,
        email: json['email'] as String,
        name: json['name'] as String,
        content: json['content'] as String,
        date: date,
        mediaId: mediaId,
        replies: replies,
        edited: edited);
  }

  factory Comments.fromMap(Map<String, dynamic> data) {
    return Comments(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        content: data['thumbnail'],
        date: data['date'],
        mediaId: data['media_id'],
        replies: data['replies'],
        edited: data['edited']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "content": content,
        "date": date,
        "mediaId": mediaId,
        "replies": replies,
        "edited": edited
      };
}
