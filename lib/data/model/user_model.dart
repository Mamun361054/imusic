
class UserModel {
  UserModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  bool? status;
  String? message;
  String? token;
  User? user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "user": user?.toJson(),
      };
}

class User {
  User({
    this.id,
    this.name,
    this.image,
    this.role,
    this.roleId,
    this.phone,
    this.dateOfBirth,
    this.email,
    this.loginType,
    this.subscribed,
    this.subscribeExpiryDate,
    this.subscribePlan,
    this.artistId,
    this.about,
    this.thumbnail,
    this.interests,
    this.socialUrls,
    this.favArtists,
    this.token,
  });

  int? id;
  String? name;
  dynamic image;
  String? role;
  int? roleId;
  dynamic phone;
  dynamic dateOfBirth;
  String? email;
  String? loginType;
  int? subscribed;
  dynamic subscribeExpiryDate;
  dynamic subscribePlan;
  dynamic artistId;
  dynamic about;
  String? thumbnail;
  List<String>? interests;
  dynamic socialUrls;
  List<FavArtist>? favArtists;
  String? token;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        role: json["role"],
        roleId: json["role_id"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"],
        email: json["email"],
        loginType: json["login_type"],
        subscribed: json["subscribed"],
        subscribeExpiryDate: json["subscribe_expiry_date"],
        subscribePlan: json["subscribe_plan"],
        artistId: json["artist_id"],
        about: json["about"],
        thumbnail: json["thumbnail"],
        interests: json["interests"] == null
            ? []
            : List<String>.from(json["interests"]!.map((x) => x)),
    favArtists: json["fav_artists"] == null ? [] : List<FavArtist>.from(json["fav_artists"]!.map((x) => FavArtist.fromJson(x))),
    token: json["token"],
        // favArtists: json["fav_artists"] != null
        //     ? json["fav_artists"].map((e) => FavArtists.fromJson(e)).toList() :  <FavArtists>[],
        // token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "role": role,
        "role_id": roleId,
        "phone": phone,
        "date_of_birth": dateOfBirth,
        "email": email,
        "login_type": loginType,
        "subscribed": subscribed,
        "subscribe_expiry_date": subscribeExpiryDate,
        "subscribe_plan": subscribePlan,
        "artist_id": artistId,
        "about": about,
        "thumbnail": thumbnail,
        "interests": interests == null
            ? []
            : List<dynamic>.from(interests!.map((x) => x)),
        "social_urls": socialUrls,
        "fav_artists": List<FavArtist>.from(favArtists!.map((x) => x)),
        "token": token,
      };
}
class FavArtist {
  int? id;
  int? userId;
  int? imageId;
  String? status;
  String? name;
  String? slug;
  String? description;
  String? image;
  int? likesCount;
  int? viewsCount;
  int? downloadsCount;
  int? sharesCount;
  int? followersCount;
  int? commentsCount;
  String? categories;
  int? mediaCount;
  int? albumCount;
  bool? userLiked;
  int? numberOfMusic;
  int? numberOfAlbum;

  FavArtist({
    this.id,
    this.userId,
    this.imageId,
    this.status,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.likesCount,
    this.viewsCount,
    this.downloadsCount,
    this.sharesCount,
    this.followersCount,
    this.commentsCount,
    this.categories,
    this.mediaCount,
    this.albumCount,
    this.userLiked,
    this.numberOfMusic,
    this.numberOfAlbum,
  });

  factory FavArtist.fromJson(Map<String, dynamic> json) => FavArtist(
    id: json["id"],
    userId: json["user_id"],
    imageId: json["image_id"],
    status: json["status"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    image: json["image"],
    likesCount: json["likes_count"],
    viewsCount: json["views_count"],
    downloadsCount: json["downloads_count"],
    sharesCount: json["shares_count"],
    followersCount: json["followers_count"],
    commentsCount: json["comments_count"],
    categories: json["categories"],
    mediaCount: json["media_count"],
    albumCount: json["album_count"],
    userLiked: json["user_liked"],
    numberOfMusic: json["number_of_music"],
    numberOfAlbum: json["number_of_album"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "image_id": imageId,
    "status": status,
    "name": name,
    "slug": slug,
    "description": description,
    "image": image,
    "likes_count": likesCount,
    "views_count": viewsCount,
    "downloads_count": downloadsCount,
    "shares_count": sharesCount,
    "followers_count": followersCount,
    "comments_count": commentsCount,
    "categories": categories,
    "media_count": mediaCount,
    "album_count": albumCount,
    "user_liked": userLiked,
    "number_of_music": numberOfMusic,
    "number_of_album": numberOfAlbum,
  };
}


