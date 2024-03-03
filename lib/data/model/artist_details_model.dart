// class ArtistsDetailsModel {
//   String? status;
//   String? message;
//   Data? data;

//   ArtistsDetailsModel({
//     this.status,
//     this.message,
//     this.data,
//   });

//   factory ArtistsDetailsModel.fromJson(Map<String, dynamic> json) =>
//       ArtistsDetailsModel(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   List<Item>? items;

//   Data({
//     this.items,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         items: json["items"] == null
//             ? []
//             : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "items": items == null
//             ? []
//             : List<dynamic>.from(items!.map((x) => x.toJson())),
//       };
// }

// class Item {
//   int? id;
//   String? name;
//   String? image;
//   int? numberOfMusic;
//   int? numberOfAlbum;

//   Item({
//     this.id,
//     this.name,
//     this.image,
//     this.numberOfMusic,
//     this.numberOfAlbum,
//   });

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         numberOfMusic: json["number_of_music"],
//         numberOfAlbum: json["number_of_album"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "number_of_music": numberOfMusic,
//         "number_of_album": numberOfAlbum,
//       };
// }
