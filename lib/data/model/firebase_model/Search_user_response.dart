// To parse this JSON data, do
//
//     final searchUserResponse = searchUserResponseFromJson(jsonString);

import 'dart:convert';

import '../artist_model.dart';

SearchUserResponse searchUserResponseFromJson(String str) =>
    SearchUserResponse.fromJson(json.decode(str));

String searchUserResponseToJson(SearchUserResponse data) =>
    json.encode(data.toJson());

class SearchUserResponse {
  SearchUserResponse({
    this.status,
    this.searchProfiles,
  });

  String? status;
  List<ChatProfileSearch>? searchProfiles;

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) =>
      SearchUserResponse(
        status: json["status"],
        searchProfiles: List<ChatProfileSearch>.from(
            json["data"].map((x) => ChatProfileSearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(searchProfiles!.map((x) => x.toJson())),
      };
}

class ChatProfileSearch {
  ChatProfileSearch({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.subscribed,
    this.subscribeExpiryDate,
    this.subscribePlan,
    this.artistId,
    this.about,
    this.interests,
    this.socialUrls,
    this.favArtists,
    this.imageId,
    this.thumbnail,
  });

  int? id;
  String? name;
  String? phone;
  String? email;
  int? gender;
  String? dateOfBirth;
  int? subscribed;
  DateTime? subscribeExpiryDate;
  String? subscribePlan;
  int? artistId;
  String? about;
  List<String>? interests;
  dynamic socialUrls;
  List<dynamic>? favArtists;
  int? imageId;
  String? thumbnail;

  factory ChatProfileSearch.fromJson(Map<String, dynamic> json) =>
      ChatProfileSearch(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        dateOfBirth: json["date_of_birth"],
        subscribed: json["subscribed"],
        subscribeExpiryDate: json["subscribe_expiry_date"] != null
            ? DateTime.parse(json["subscribe_expiry_date"])
            : null,
        subscribePlan: json["subscribe_plan"],
        artistId: json["artist_id"],
        about: json["about"],
        interests: json["interests"] == null
            ? []
            : List<String>.from(json["interests"]!.map((x) => x)),
        socialUrls: json["social_urls"],
        favArtists: json["fav_artists"] == null
            ? []
            : List<dynamic>.from(json["fav_artists"]!.map((x) => x)),
        imageId: json["image_id"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "subscribed": subscribed,
        "subscribe_expiry_date": subscribeExpiryDate?.toIso8601String(),
        "subscribe_plan": subscribePlan,
        "artist_id": artistId,
        "about": about,
        "interests": interests,
        "social_urls": socialUrls,
        "fav_artists": favArtists,
        "image_id": imageId,
        "thumbnail": thumbnail,
      };
}
