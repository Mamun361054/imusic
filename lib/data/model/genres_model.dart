class Genres {
  Genres({
    this.id,
    this.name,
    this.image,
    this.numberOfMusic,
  });

  int? id;
  String? name;
  String? image;
  int? numberOfMusic;

  factory Genres.fromJson(Map<String, dynamic> json) => Genres(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        numberOfMusic: json["number_of_music"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "number_of_music": numberOfMusic,
      };
}
