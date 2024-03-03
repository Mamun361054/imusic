import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/music/audio_provider.dart';
import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/screens/home/artists/profile_artists_view.dart';
import 'package:dhak_dhol/screens/home/music_player_page/common.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../../provider/media_player_model.dart';
import 'music_player_page.dart';

class AudioPlayerOpinion extends StatefulWidget {

  const AudioPlayerOpinion({Key? key}) : super(key: key);

  @override
  State<AudioPlayerOpinion> createState() => _AudioPlayerOpinionState();
}

class _AudioPlayerOpinionState extends State<AudioPlayerOpinion> {

  @override
  void initState() {
    super.initState();
    context.read<AudioProvider>().isOpinion = false;
    context.read<AudioProvider>().opinionTitleController.clear();
    context.read<AudioProvider>().opinionDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {

    AudioProvider provider = Provider.of(context);

    return ChangeNotifierProvider(
      create: (_) => MediaPlayerModel(provider.currentMedia),
      child: Scaffold(
        backgroundColor: AppColor.signInPageBackgroundColor,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.34,
                    fit: BoxFit.cover,
                    imageUrl: "${provider.currentMedia?.coverPhoto}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  AppBar(
                    // title: Text('${provider.currentMedia?.title}'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Positioned(
                    left: -5.0,
                    right: -5.0,
                    bottom: -20.0,
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.signInPageBackgroundColor,
                              blurRadius: 24.0,
                              spreadRadius: 8.0,
                              offset: const Offset(0.0, 0.0))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding:const EdgeInsets.only(left: 16.0, right: 16),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppColor.textColor,
                  controller: provider.opinionTitleController,
                  decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.fromLTRB(20, 40, 0, 0),
                      filled: true,
                      fillColor: AppColor.inputBackgroundColor.withOpacity(0.7),
                      enabledBorder : OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                      disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                      hintText: 'Enter Opinion Title',
                      hintStyle: GoogleFonts.manrope(color: Colors.white)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field can't be Empty";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: provider.opinionDescriptionController,
                  cursorColor: AppColor.signInPageBackgroundColor,
                  decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.fromLTRB(20, 40, 0, 0),
                      filled: true,
                      fillColor: AppColor.inputBackgroundColor.withOpacity(0.7),
                      enabledBorder : OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                      disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                    hintText: 'Enter Your own rules for this opinion room',
                      hintStyle: GoogleFonts.manrope(color: Colors.white)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field can't be Empty";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(AppText.opinionStart,
                  style: GoogleFonts.manrope(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                child: ElevatedButton(
                  onPressed: provider.isOpinion ? null : () => provider.createOpinion(context: context),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 55.0,),
                    foregroundColor: Colors.black, backgroundColor: AppColor.buttonColor,
                  ),
                  child: provider.isOpinion ? CircularProgressIndicator() : Text(
                    'START OPINION ROOM',
                    style: GoogleFonts.manrope(fontSize: 16.0,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
