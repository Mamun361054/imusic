import 'package:image_picker/image_picker.dart';

class ChatCommon {
  static Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 400,
        maxWidth: 400);

    if (imageFile != null) {
      return imageFile;
    }
    return null;
  }
}
