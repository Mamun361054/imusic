class Artists {
  final int? id;
  final String? title;
  final String? thumbnail;
  final int? mediaCount, albumCount;

  Artists({
    this.id,
    this.title,
    this.thumbnail,
    this.mediaCount,
    this.albumCount,
  });

  factory Artists.fromJson(Map<String, dynamic> json) {
    int id = int.parse(json['id'].toString());
    int count = json['number_of_music'] != null
        ? int.parse(json['number_of_music'].toString())
        : 0;
    int tmpAlbumCount = json['number_of_album'] != null
        ? int.parse(json['number_of_album'].toString())
        : 0;
    return Artists(
      id: id,
      title: json['name'] as String,
      thumbnail: json['image'] != null ? json['image'] as String : null,
      mediaCount: count,
      albumCount: tmpAlbumCount,
    );
  }
}

