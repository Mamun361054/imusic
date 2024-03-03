import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/music/audio_provider.dart';
import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/screens/auth/sign_in/sign_in_screen.dart';
import 'package:dhak_dhol/screens/home/artists/profile_artists_view.dart';
import 'package:dhak_dhol/screens/home/music_player_page/common.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../../provider/media_player_model.dart';
import 'audio_player_opinion.dart';
import 'music_opinion_screen.dart';
import 'music_player_page.dart';

class AudioPlayerNewPage extends StatefulWidget {
  static const routeName = "/AudioPlayerNewPage";

  const AudioPlayerNewPage({Key? key}) : super(key: key);

  @override
  State<AudioPlayerNewPage> createState() => _AudioPlayerNewPageState();
}

class _AudioPlayerNewPageState extends State<AudioPlayerNewPage> {
  @override
  Widget build(BuildContext context) {
    AudioProvider provider = Provider.of(context);
    final profile = context.watch<ProfileProvider>();

    return ChangeNotifierProvider(
      create: (_) => MediaPlayerModel(provider.currentMedia),
      child: Scaffold(
        backgroundColor: AppColor.signInPageBackgroundColor,
        body: SingleChildScrollView(
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
                    title: Text('${provider.currentMedia?.title}'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Positioned(
                    left: -16.0,
                    right: -16.0,
                    bottom: -30.0,
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.signInPageBackgroundColor,
                              blurRadius: 18.0,
                              spreadRadius: 8.0,
                              offset: const Offset(0.0, 0.0))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ControlButton(provider.player),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  '${provider.currentMedia?.title}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),

              const SizedBox(
                height: 10.0,
              ),
              ////////// Music Slider ////////////
              StreamBuilder<AudioPositionData>(
                stream: provider.positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: provider.player.seek,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MediaCommentsLikesContainer(
                  context: context,
                  currentMedia: provider.currentMedia,
                  audioPlayerModel: provider),

              Column(
                children: provider.opinions.map((e) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MusicOpinionConversation(
                                  media: provider.currentMedia,
                                  opinion: e,
                                )));
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          MediaQuery.of(context).size.width,
                          55.0,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        foregroundColor: Colors.black,
                        backgroundColor: AppColor.buttonColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${e.title}',
                            style: GoogleFonts.manrope(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '${e.userCount}',
                              style: GoogleFonts.manrope(color: AppColor.signInPageBackgroundColor, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final id = await SharedPref.getValue(SharedPref.keyId);
                    var snackBar = SnackBar(
                      content: Text('You are not Signed In!'),
                      action: SnackBarAction(
                          label: 'Sign In',
                          textColor: AppColor.buttonColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ));
                          }),
                    );
                    if (id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AudioPlayerOpinion(),
                          ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55.0,
                    ),
                    foregroundColor: Colors.black,
                    backgroundColor: AppColor.buttonColor,
                  ),
                  child: Text(
                    'CREATE OPINION',
                    style: GoogleFonts.manrope(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              ///============= Artists ======================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ProfileArtistsScreen(
                  artists: profile.selectedArtists,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final Media? playMusic;

  const ControlButtons(this.player, {Key? key, this.playMusic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final bookmarksModel = Provider.of<BookmarksProvider>(context);
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icons.shuffle,
          size: 26,
          color: Colors.grey,
        ),
        IconButton(
            onPressed: () => player.seekToPrevious(),
            icon:
                const Icon(Icons.skip_previous, size: 26, color: Colors.grey)),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),

        IconButton(
            onPressed: () => player.seekToNext(),
            icon: const Icon(Icons.skip_next, size: 26, color: Colors.grey)),

        const Icon(Icons.repeat, size: 26, color: Colors.grey),
      ],
    );
  }
}
