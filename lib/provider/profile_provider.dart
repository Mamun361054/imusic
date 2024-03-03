import 'dart:io';
import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/data/model/profile_model.dart';
import 'package:dhak_dhol/data/model/update_profile.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:dhak_dhol/widgets/custom_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/model/artist_model.dart';
import '../data/model/audio_upload_option_model.dart';
import '../screens/profile/profile_new/chat_profile.dart';

class ProfileProvider extends ChangeNotifier {
  Repository repository = Repository();
  List<Albums>? albums;
  Profile? profile;
  bool isUpdating = false;
  List<Album> allAlbums = [];
  List<Artists> allArtists = [];
  List<Album> selectedAlbums = [];
  List<Artists> selectedArtists = [];
  List<Album> genres = [];
  List<Album> moods = [];
  Album? selectedAlbum;
  Artists? selectedArtist;
  bool isImagePicked = false;
  File? attachmentFile;
  String? chatUserEmail;
  bool loadingProfile = false;

  ProfileProvider() {
    getProfile();
    getAllArtists();
  }

  void navigationToProfile(context, UserModel friend) {
    notifyListeners();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatProfileScreen(friend: friend)));
  }

  ///Pick Attachment from Camera and Gallery
  Future<dynamic> uploadImage(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogImagePicker(
          onCameraClick: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                maxHeight: 300,
                maxWidth: 300,
                imageQuality: 90);
            attachmentFile = File(image!.path);
            notifyListeners();
            if (kDebugMode) {
              print(File(image.path));
            }
          },
          onGalleryClick: () async {
            final ImagePicker pickerGallery = ImagePicker();
            final XFile? imageGallery = await pickerGallery.pickImage(
                source: ImageSource.gallery,
                maxHeight: 300,
                maxWidth: 300,
                imageQuality: 90);
            attachmentFile = File(imageGallery!.path);
            notifyListeners();
            if (kDebugMode) {
              print(File(imageGallery.path));
            }
            notifyListeners();
          },
        );
      },
    );
    notifyListeners();
  }

  void fetchItems() async {
    final userId = await SharedPref.getValue(SharedPref.keyId);

    final response = await repository.fetchUserUploadAlbums(userId);
    // final response = await repository.fetchAlbum(userId ?? '');

    albums = response;
    debugPrint(albums?.length.toString());
    notifyListeners();
  }

  Future<void> getAllAlbums() async {
    final userId = SharedPref.getValue(SharedPref.keyId);
    var newData = FormData.fromMap({"user_id": userId});
    final response = await repository.uploadSongsItemFetch(newData);
    if (response != null) {
      allAlbums = response.data!.albums!;
      if (allAlbums.isNotEmpty) {
        selectedAlbum = allAlbums.first;
      }
      genres = response.data!.genres!;
      moods = response.data!.moods!;
    }
    notifyListeners();
  }

  Future<void> getAllArtists() async {
    // var newData = FormData.fromMap({"page": null});
    final response = await repository.fetchArtists(1);
    if (response != null) {
      allArtists = response;
      if (allAlbums.isNotEmpty) {
        selectedArtist = allArtists.first;
      }
    }
    notifyListeners();
  }

  void updateProfile(UpdateProfile updateProfile) {
    profile = Profile.copyWith(updateProfile);

    notifyListeners();
  }

  void updateProfile1(Profile? updatedProfile) {
    profile = updatedProfile;

    notifyListeners();
  }

  void onItemChanged(Artists? artist) {
    selectedArtist = artist;
    if (artist != null) {
      onItemSelect(artist);
    }
    notifyListeners();
  }

  onItemSelect(Artists artist) {
    if (selectedArtists.isNotEmpty) {
      final list =
          selectedArtists.where((element) => element.id == artist.id).toList();
      if (list.isEmpty) {
        selectedArtists.add(artist);
      }
    } else {
      selectedArtists.add(artist);
    }
  }

  onItemRemove(Artists artist) {
    selectedArtists.removeWhere((element) => element.id == artist.id);
    notifyListeners();
  }

   getProfile({int? pid}) async {

    loadingProfile = true;

    notifyListeners();

    final token = await SharedPref.getValue(SharedPref.keyToken);

    final uid = await SharedPref.getValue(SharedPref.keyId);

    if(token != null){

      final response = await repository.getProfileData(pid:pid ?? int.parse('${uid}'));

      if (response?.statusCode == 200) {
        profile = response?.data['data'] != null
            ? Profile.fromJson(response?.data['data'])
            : null;
        selectedArtists = profile?.favArtists ?? [];
      }
    }
    loadingProfile = false;

    notifyListeners();
  }

  Future<bool> onUpdateProfile({UpdateProfile? updateProfile}) async {
    isUpdating = true;
    notifyListeners();

    if (kDebugMode) {
      print('toMap ${updateProfile?.toMap}');
    }
    var fileAttachment = attachmentFile?.path.split('/').last;

    var fromData = FormData.fromMap({
      "email": updateProfile?.email,
      "name": updateProfile?.name,
      "about": updateProfile?.about,
      "facebook": updateProfile?.facebook ?? '',
      "instagram": updateProfile?.instagram ?? '',
      "snapchat": updateProfile?.snapshot ?? '',
      "fav_artists": updateProfile?.artists,
      "interests": updateProfile?.interests,
      "thumbnail": attachmentFile?.path != null
          ? await MultipartFile.fromFile(attachmentFile!.path,
              filename: fileAttachment)
          : '',
    });

    final response = await repository.updateProfileData(fromData);
    if (response?.statusCode == 200) {
      isUpdating = false;
      notifyListeners();
      return true;
    }
    {
      return false;
    }
  }
}
