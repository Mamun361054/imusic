import 'package:dhak_dhol/provider/music/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/music_player_page/audio_player_new_page.dart';
import '../home/music_player_page/common.dart';
import '../home/music_player_page/music_player_page.dart';

class MiniPlayer extends StatefulWidget {

  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _AudioPlayer();
}

class _AudioPlayer extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {

    AudioProvider provider = Provider.of(context);

    return Consumer<AudioProvider>(
      builder: (context, audioPlayerModel, child) {

        final mediaItem = audioPlayerModel.currentMedia;

        return mediaItem == null
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
                },
                child: SizedBox(
                  height: 85.0,
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      margin: const EdgeInsets.all(0.0),
                      elevation: 8.0,
                      clipBehavior: Clip.none,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(audioPlayerModel.backgroundColor, BlendMode.hardLight),
                            image: NetworkImage(mediaItem.coverPhoto ?? '',)
                          )
                        ),
                        child: Row(
                          children: [
                            mediaItem.coverPhoto == "" ? const Icon(Icons.audiotrack) : Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(mediaItem.coverPhoto ?? ''),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: StreamBuilder<AudioPositionData>(
                                      stream: provider.positionDataStream,
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data;
                                        return SeekBar(
                                          duration: positionData?.duration ?? Duration.zero,
                                          position: positionData?.position ?? Duration.zero,
                                          bufferedPosition:positionData?.bufferedPosition ?? Duration.zero,
                                          onChangeEnd: provider.player.seek,
                                        );
                                      },
                                    ),
                                  ),
                                  const MiniPlayerControlButtons(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
      },
    );
  }
}
