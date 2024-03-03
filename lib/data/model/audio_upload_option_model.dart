import 'dart:convert';

AudioUploadOptionModel mediaUploadOptionFromJson( str) => AudioUploadOptionModel.fromJson(json.decode(str));

class AudioUploadOptionModel {
  AudioUploadOptionModel({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory AudioUploadOptionModel.fromJson(Map<String, dynamic> json) => AudioUploadOptionModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  Data({
    this.albums,
    this.genres,
    this.moods,
  });

  List<Album>? albums;
  List<Album>? genres;
  List<Album>? moods;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    albums: List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
    genres: List<Album>.from(json["genres"].map((x) => Album.fromJson(x))),
    moods: List<Album>.from(json["moods"].map((x) => Album.fromJson(x))),
  );
}

class Album {
  Album({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json["id"],
    name: json["name"],
  );
}
