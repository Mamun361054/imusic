import 'package:dhak_dhol/provider/upload_songs_provider.dart';
import 'package:dhak_dhol/screens/profile/add_album/song_upload/song_upload_screen_final.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SongUploadScreen extends StatelessWidget {
  const SongUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UploadSongProvider>();
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.deepBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(child: Image.asset('assets/images/app_logo.png')),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Media cover (add picture)',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 156,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.backgroundColor2,
                borderRadius: BorderRadius.circular(10),
                image: provider.file == null
                    ? null
                    : DecorationImage(
                    image: FileImage(provider.file!),
                    fit: BoxFit.cover),
              ),
              child: InkWell(
                onTap: () {
                  provider.pickSongsImage();
                },
                child: DottedBorder(
                  radius: const Radius.circular(50),
                  color: Colors.red,
                  strokeWidth: .4,
                  child: provider.file == null
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                            'assets/images/cloud-upload.png'),
                        Text(
                          'Drag  your music cover',
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 18),
                        )
                      ],
                    ),
                  )
                      : const SizedBox(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Media file (add audio file)',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 156,
              decoration: BoxDecoration(
                  color: AppColor.backgroundColor2,
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  provider.pickAudio();
                },
                child: DottedBorder(
                  radius: const Radius.circular(50),
                  color: Colors.red,
                  strokeWidth: .4,
                  child: Center(
                    child: provider.audioFileName == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/cloud-upload.png'),
                        Text('Drag  your music cover',
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 18),
                        )
                      ],
                    )
                        : Text(
                      "${provider.audioFileName}",
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (provider.file != null &&
                      provider.audioFileName != null) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const SongUploadScreenFinal();
                        }));
                  } else {
                    Fluttertoast.showToast(msg: "Field won't be empty");
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: AppColor.buttonColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Next',
                    style: GoogleFonts.manrope(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// final provider = context.watch<AudioUploadModel>();
