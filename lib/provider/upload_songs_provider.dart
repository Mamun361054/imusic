import 'dart:io';

import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/audio_upload_option_model.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UploadSongProvider extends ChangeNotifier {
  Repository repository = Repository();
  File? file;
  File? compressedFile;
  File? audioFile;
  String? audioFileName;
  final TextEditingController audioTitleController = TextEditingController();
  bool isLoading = false;

  List<Album> albums = [];
  List<Album> genres = [];
  List<Album> moods = [];

  Album? dropdownAlbumValue;
  Album? dropdownGenreValue;
  Album? dropdownMoodValue;

  UploadSongProvider() {
    // clear();
    fetchItems();
  }

  pickSongsImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowCompression: true);

    if (result != null) {
      file = File(result.files.single.path!);
      compressedFile = await FlutterNativeImage.compressImage(
        result.files.single.path!,
        quality: 25,
      );
      debugPrint(result.files.first.name.toString());
    } else {
      // User canceled the picker
    }
    notifyListeners();
  }

  pickAudio() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      audioFile = File(result.files.single.path!);
      audioFileName = result.files.first.name;
      debugPrint(result.files.first.bytes.toString());
      debugPrint(result.files.first.size.toString());
      debugPrint(result.files.first.extension.toString());
    } else {
      // User canceled the picker
    }
    notifyListeners();
  }

  Future<void> fetchItems() async {
    final userId = SharedPref.getValue(SharedPref.keyId);
    var newData = FormData.fromMap({"user_id": userId});
    final response = await repository.uploadSongsItemFetch(newData);
    if (response != null) {
      albums = response.data!.albums!;
      genres = response.data!.genres!;
      moods = response.data!.moods!;
    }
    debugPrint(response.toString());
    notifyListeners();
  }

  void uploadAudio() async {
    final userId = SharedPref.getValue(SharedPref.keyId);
    var formData = FormData.fromMap({
      "title": audioTitleController.text,
      "artists": '1',
      "album": dropdownAlbumValue?.id,
      "genre": dropdownGenreValue?.id,
      "mood": dropdownMoodValue?.id,
      "media_type": '0',
      "is_free": '0',
      "can_download": '0',
      "can_preview": '0',
      "preview_duration": '60',
      "duration": '429426',
      "notify": 'true',
      "by_android_user": userId.toString(),
    });
    formData.files.add(MapEntry(
        'thumbnail', await MultipartFile.fromFile(compressedFile!.path)));
    formData.files
        .add(MapEntry('audio', await MultipartFile.fromFile(audioFile!.path)));

    final response = await repository.uploadSongs(formData);
    debugPrint(response.toString());
  }

  clear() {
    dropdownAlbumValue = null;
    dropdownGenreValue = null;
    dropdownMoodValue = null;
    notifyListeners();
  }
}
