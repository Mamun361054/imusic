
import 'package:dhak_dhol/data/model/media_model.dart';

class SearchPlayList {
  int? id;
  String? name;
  String? image;
  int? likesCount;
  int? viewsCount;
  int? commentsCount;
  List<Media>? list;
  int? numberOfMusic;
  bool? userLiked;

  SearchPlayList({
    this.id,
    this.name,
    this.image,
    this.likesCount,
    this.viewsCount,
    this.commentsCount,
    this.list,
    this.numberOfMusic,
    this.userLiked,
  });

  factory SearchPlayList.fromJson(Map<String, dynamic> json) => SearchPlayList(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    likesCount: json["likes_count"],
    viewsCount: json["views_count"],
    commentsCount: json["comments_count"],
    list: json["list"] == null ? [] : List<Media>.from(json["list"].map((x) => Media.fromJson(x))),
    numberOfMusic: json["number_of_music"],
    userLiked: json["user_liked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "likes_count": likesCount,
    "views_count": viewsCount,
    "comments_count": commentsCount,
    "list": list == null ? [] : List<Media>.from(list!.map((x) => x.toMap())),
    "number_of_music": numberOfMusic,
    "user_liked": userLiked,
  };
}

