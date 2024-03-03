import 'package:dhak_dhol/data/model/audio_upload_option_model.dart';
import 'package:dhak_dhol/provider/upload_songs_provider.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SongUploadScreenFinal extends StatefulWidget {
  const SongUploadScreenFinal({Key? key}) : super(key: key);

  @override
  State<SongUploadScreenFinal> createState() => _SongUploadScreenFinalState();
}

class _SongUploadScreenFinalState extends State<SongUploadScreenFinal> {
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UploadSongProvider>();
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 80,
          ),
          Center(child: Image.asset('assets/images/app_logo.png')),
          const SizedBox(
            height: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.audioTitle,
                textAlign: TextAlign.start,
                style: GoogleFonts.manrope(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: provider.audioTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    errorText: _validate ? 'Add audio title' : null,
                    contentPadding: const EdgeInsets.fromLTRB(20, 38, 0, 0),
                    filled: true,
                    fillColor: AppColor.fromFillColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: AppText.hintName,
                    hintStyle: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(.2))),
              ),
            ],
          ),

          const SizedBox(
            height: 16.0,
          ),
          Text(
            AppText.addAlbum,
            textAlign: TextAlign.start,
            style: GoogleFonts.manrope(color: Colors.white),
          ),
          const SizedBox(
            height: 4.0,
          ),

          ///=================== add album ==================
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColor.fromFillColor,
                border: Border.all(color: AppColor.fromFillColor)),
            child: DropdownButton<Album>(
              dropdownColor: AppColor.fromFillColor,
              isExpanded: true,
              value: provider.dropdownAlbumValue,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 18,
              ),
              underline: const SizedBox(),
              elevation: 16,
              hint: Text(
                'Add Album',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
              focusColor: Colors.white,
              onChanged: (newValue) {
                setState(() {
                  provider.dropdownAlbumValue = newValue;
                });
              },
              items: provider.albums.map<DropdownMenuItem<Album>>((value) {
                return DropdownMenuItem<Album>(
                  value: value,
                  child: Text(value.name!,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),

          const SizedBox(
            height: 16.0,
          ),
          Text(
            AppText.addGenre,
            textAlign: TextAlign.start,
            style: GoogleFonts.manrope(color: Colors.white),
          ),

          const SizedBox(
            height: 4.0,
          ),

          ///=================== add genre ==================
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColor.fromFillColor,
                border: Border.all(color: AppColor.fromFillColor)),
            child: DropdownButton<Album>(
              dropdownColor: AppColor.fromFillColor,
              isExpanded: true,
              value: provider.dropdownGenreValue,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 18,
              ),
              underline: const SizedBox(),
              elevation: 16,
              hint: Text(
                'Select Genres',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
              focusColor: Colors.white,
              onChanged: (newValue) {
                setState(() {
                  provider.dropdownGenreValue = newValue;
                });
              },
              items: provider.genres.map<DropdownMenuItem<Album>>((value) {
                return DropdownMenuItem<Album>(
                  value: value,
                  child: Text(value.name!,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),

          const SizedBox(
            height: 16.0,
          ),
          Text(
            AppText.addMoods,
            textAlign: TextAlign.start,
            style: GoogleFonts.manrope(color: Colors.white),
          ),
          const SizedBox(
            height: 4.0,
          ),

          ///=================== add mood ==================
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColor.fromFillColor,
                border: Border.all(color: AppColor.fromFillColor)),
            child: DropdownButton<Album>(
              dropdownColor: AppColor.fromFillColor,
              isExpanded: true,
              value: provider.dropdownMoodValue,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 18,
              ),
              underline: const SizedBox(),
              elevation: 16,
              hint: Text(
                'Select Mood',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
              focusColor: Colors.white,
              onChanged: (newValue) {
                setState(() {
                  provider.dropdownMoodValue = newValue;
                });
              },
              items: provider.moods.map<DropdownMenuItem<Album>>((value) {
                return DropdownMenuItem<Album>(
                  value: value,
                  child: Text(value.name!,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  provider.audioTitleController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
                provider.uploadAudio();
              },
              style: ElevatedButton.styleFrom(
                primary: AppColor.buttonColor,
                onPrimary: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Upload',
                  style: GoogleFonts.manrope(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
