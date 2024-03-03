class Albums {
  Albums({
    this.id,
    this.name,
    this.thumbnail,
    this.artistId,
    this.byAndroidUser,
    this.user,
    this.artist,
    this.artistAvatar,
    this.mediaCount,
    this.albumDuration
  });

  String? id;
  String? name;
  String? thumbnail;
  String? artistId;
  String? byAndroidUser;
  String? user;
  String? artist;
  String? artistAvatar;
  String? mediaCount;
  String? albumDuration;

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        id: json["id"].toString(),
        name: json["name"],
        thumbnail: json["thumbnail"],
        artistId: json["artist_id"].toString(),
        byAndroidUser: json["by_android_user"],
        user: json["user"],
        artist: json["artist"],
        artistAvatar: json["artist_avatar"],
        mediaCount: json["media_count"].toString(),
        albumDuration: json["duration"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "artist_id": artistId,
        "by_android_user": byAndroidUser,
        "user": user,
        "artist": artist,
        "artist_avatar": artistAvatar,
        "media_count": mediaCount,
      };
}
