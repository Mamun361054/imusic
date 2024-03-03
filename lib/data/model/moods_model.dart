// class Moods {
//   final int? id;
//   final String? title;
//   final String? thumbnail;
//   final int? mediaCount;
//
//   Moods({
//     this.id,
//     this.title,
//     this.thumbnail,
//     this.mediaCount,
//   });
//
//   factory Moods.fromJson(Map<String, dynamic> json) {
//     int id = int.parse(json['id'].toString());
//     int count = int.parse(json['media_count'].toString());
//     return Moods(
//       id: id,
//       title: json['name'] as String,
//       thumbnail: json['thumbnail'] as String,
//       mediaCount: count,
//     );
//   }
// }

class Moods {
  Moods({
    this.id,
    this.serial,
    this.title,
    this.thumbnail,
    this.mediaCount,
    this.numberOfAlbum,
  });

  int? id;
  int? serial;
  String? title;
  String? thumbnail;
  int? mediaCount;
  int? numberOfAlbum;

  factory Moods.fromJson(Map<String, dynamic> json) => Moods(
        id: json["id"],
        serial: json["serial"],
        title: json["name"],
        thumbnail: json["image"],
        mediaCount: json["media_count"],
        numberOfAlbum: json["number_of_album"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serial": serial,
        "name": title,
        "image": thumbnail,
        "number_of_music": mediaCount,
        "number_of_album": numberOfAlbum,
      };
}
