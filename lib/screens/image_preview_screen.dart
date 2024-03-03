import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.signInPageBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.signInPageBackgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  downloadImage(widget.message);
                });
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: PhotoView(
        imageProvider: MemoryImage(base64Decode(widget.message)),
        heroAttributes: PhotoViewHeroAttributes(tag: widget.message),
      ),
    );
  }

  downloadImage(message) async {
    int max = 101;
    int randomNumber = Random().nextInt(max);

    try {
      Uint8List imageInUnit8List = base64Decode(message);
      final tempDir = await getTemporaryDirectory();
      print(tempDir.path.toString());
      File file =
          await File('/storage/emulated/0/Download/image$randomNumber.png')
              .create();
      file.writeAsBytesSync(imageInUnit8List);
      Fluttertoast.showToast(msg: 'Download Complete');
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
