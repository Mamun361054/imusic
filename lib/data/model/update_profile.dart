
import 'dart:io';

class UpdateProfile{
   String? email;
   String? name;
   String? facebook;
   String? instagram;
   String? snapshot;
   String? about;
   String? artists;
   String? interests;
   File? thumbnail;

   UpdateProfile({this.email, this.name, this.facebook, this.instagram,
      this.snapshot, this.about, this.artists, this.interests, this.thumbnail});

  Map<String,dynamic> get toMap => {
    'email': email,
    'name': name,
    'facebook': facebook,
    'instagram': instagram,
    'snapshot': snapshot,
    'about': about,
    'fav_artists': artists,
    'interests': interests,
    'thumbnail': thumbnail
  };
}