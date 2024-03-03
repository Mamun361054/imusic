
class Opinions {
  List<Opinion> opinions;

  Opinions({
    this.opinions = const [],
  });

  factory Opinions.fromJson(Map<String, dynamic> json) => Opinions(
    opinions: json["opinions"] == null ? [] : List<Opinion>.from(json["opinions"]!.map((x) => Opinion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "opinions": List<dynamic>.from(opinions.map((x) => x.toJson())),
  };
}

class Opinion {
  int? id;
  String? title;
  dynamic description;
  int? userId;
  int? userCount;
  String? createdBy;

  Opinion({
    this.id,
    this.title,
    this.description,
    this.userId,
    this.userCount,
    this.createdBy,
  });

  factory Opinion.fromJson(Map<String, dynamic> json) => Opinion(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    userId: json["user_id"],
    userCount: json["user_count"],
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "user_id": userId,
    "user_count": userCount,
    "created_by": createdBy,
  };
}
