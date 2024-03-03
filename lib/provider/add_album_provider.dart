import 'dart:io';

import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class AddAlbumProvider extends ChangeNotifier {
  File? file;
  File? compressedFile;
  final TextEditingController titleController = TextEditingController();
  Repository repository = Repository();

  pickAlbumImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
      compressedFile = await FlutterNativeImage.compressImage(
        result.files.single.path!,
        quality: 25,
      );
      debugPrint(result.files.first.name.toString());
      notifyListeners();
    } else {
      // User canceled the picker
    }
    notifyListeners();
  }

  Future<void> albumAdd(context) async {
    final userId = SharedPref.getValue(SharedPref.keyId);
    // loading();
    try {
      FormData formData = FormData.fromMap({
        "name": titleController.text,
        "by_android_user": userId.toString(),
      });
      // var data = {
      //   "name": titleController.text,
      //   "by_android_user": userId.toString(),
      // };
      // print(data);
      // print(ApiUrl.ADD_ALBUM);
      formData.files.add(MapEntry(
          'thumbnail', await MultipartFile.fromFile(compressedFile!.path)));
      final response = await repository.addAlbum(formData);

      // loading();
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        // Toast.show(jsonData['message']);
        Navigator.of(context).pop();
      } else {
        // Toast.show('something went wrong, try again');
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      // setFetchError();
    }
  }
}
