
import 'package:dhak_dhol/data/model/update_profile.dart';

import 'artist_model.dart';

class Profile {

  final dynamic id;
  final String? name;
  final String? email;
  final String? about;
  final List<dynamic>? interests;
  final String? facebook;
  final String? snapchat;
  final String? instagram;
  final String? thumbnail;
  final List<Artists>? favArtists;

  Profile({
      this.id,
      this.name,
      this.email,
      this.about,
      this.interests,
      this.facebook,
      this.snapchat,
      this.instagram,
      this.thumbnail,
      this.favArtists});

  factory Profile.copyWith(UpdateProfile profile){
    return Profile(
      name: profile.name,
      email: profile.email,
      about: profile.about,
      interests: profile.interests?.split(','),
      facebook: profile.facebook,
      snapchat: profile.snapshot,
      instagram: profile.instagram,
      thumbnail: profile.thumbnail?.path
    );
  }

  factory Profile.fromJson(Map<String,dynamic> json){
    return Profile(
      id: json['id'],
      name: json['name'] as String?,
      email: json['email'] as String?,
      about: json['about'] as String?,
      // facebook: json['social_urls'] != null ? json['social_urls']['facebook']: null,
      // snapchat: json['social_urls'] != null ? json['social_urls']['snapchat']: null,
      // instagram: json['social_urls'] != null ? json['social_urls']['instagram']:null,
      thumbnail: json['thumbnail'] as String?,
      favArtists: json['fav_artists'] != null ? List<Artists>.from((json['fav_artists'] as List).map((e) => Artists.fromJson(e))):[],

    );
  }
}
