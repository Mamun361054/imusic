import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/bookmarks_provider.dart';
import 'package:dhak_dhol/provider/music/music_provider.dart';
import 'package:dhak_dhol/screens/home/music_player_page/common.dart';
import 'package:dhak_dhol/screens/home/playlists/add_playlist/add_playlist_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../../provider/media_player_model.dart';
import '../../../provider/music/audio_provider.dart';
import '../../../widgets/popup_menu.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({Key? key, this.playMusic}) : super(key: key);
  final Media? playMusic;

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  @override
  Widget build(BuildContext context) {
    MusicProvider provider = Provider.of(context);
    BookmarksProvider bookmarksProvider = Provider.of(context);
    debugPrint(provider.currentAudio?.coverPhoto.toString());
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        title: const Text('Playing music'),
        backgroundColor: AppColor.deepBlue,
        elevation: 0,
        actions: [
          PopupMenuButton(
            elevation: 3.2,
            //initialValue: choices[1],
            itemBuilder: (BuildContext context) {
              bool isBookmarked =
                  bookmarksProvider.isMediaBookmarked(widget.playMusic);
              List<String> choices = [];
              choices.add('Add playlist');
              if (isBookmarked) {
                choices.add("UnBookmark");
              } else {
                choices.add("Bookmark");
              }
              return choices.map((itm) {
                return PopupMenuItem(
                  value: itm,
                  child: Text(itm),
                );
              }).toList();
            },
            //initialValue: 2,
            onCanceled: () {
              debugPrint("You have canceled the menu.");
            },
            onSelected: (value) {
              if (value == 'Add playlist') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddPlaylistScreen(media: widget.playMusic!);
                }));
              }
              if (value == 'Bookmark') {
                bookmarksProvider.bookmarkMedia(widget.playMusic!);
              }
              if (value == "UnBookmark") {
                bookmarksProvider.unBookmarkMedia(widget.playMusic!);
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[500],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  height: 240,
                  imageUrl: "${provider.currentAudio?.coverPhoto}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Image.asset(
                      'assets/images/music_handaler.png',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      '${provider.currentAudio?.title}',
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/images/thumbs_up.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${provider.currentAudio?.likesCount}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset('assets/images/comment.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${provider.currentAudio?.commentsCount}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Image.asset('assets/images/download_icon.png'),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff94999F).withOpacity(.4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      child: Text(
                        "Follow",
                        style: TextStyle(color: Colors.white.withOpacity(.7)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff94999F).withOpacity(.4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      child: Text(
                        "Lyrics",
                        style: TextStyle(color: Colors.white.withOpacity(.7)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${provider.currentAudio?.artist}',
                style: TextStyle(color: Colors.white.withOpacity(.4)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ////////// Music Slider ////////////
            StreamBuilder<PositionData>(
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

            StreamBuilder<PositionData>(
                stream: provider.positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  Duration remaining =
                      (positionData?.position ?? Duration.zero);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                  .firstMatch('$remaining')
                                  ?.group(1) ??
                              '$remaining',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                  .firstMatch('${provider.durationMin}')
                                  ?.group(1) ??
                              '${provider.durationMin}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }),

            ControlButtons(
              provider.player,
              playMusic: provider.currentAudio,
            ),
            const SizedBox(
              height: 80,
            ),
            Image.asset('assets/images/music_bit.png')
          ],
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
    return Row(
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

/// Displays the play/pause button and volume/speed sliders.
class MiniPlayerControlButtons extends StatelessWidget {
  const MiniPlayerControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, provider, child) {
      provider.setContext(context);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () => provider.skipPrevious(),
              icon: const Icon(Icons.skip_previous,
                  size: 35.0, color: Color(0xffFFA64D))),

          /// This StreamBuilder rebuilds whenever the player state changes, which
          /// includes the playing/paused state and also the
          /// loading/buffering/ready state. Depending on the state we show the
          /// appropriate button or loading indicator.
          StreamBuilder<PlayerState>(
            stream: provider.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 35.0,
                  height: 35.0,
                  child: const CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Color(0xffFFA64D),
                  ),
                  iconSize: 35.0,
                  onPressed: provider.player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(
                    Icons.pause,
                    color: Color(0xffFFA64D),
                  ),
                  iconSize: 35.0,
                  onPressed: provider.player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(
                    Icons.replay,
                    color: Color(0xffFFA64D),
                  ),
                  iconSize: 35.0,
                  onPressed: () => provider.player.seek(Duration.zero),
                );
              }
            },
          ),
          IconButton(
              onPressed: () => provider.skipNext(),
              icon: const Icon(Icons.skip_next,
                  size: 35.0, color: Color(0xffFFA64D))),
        ],
      );
    });
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButton extends StatelessWidget {
  final AudioPlayer player;

  const ControlButton(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioProvider audioPlayerModel = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
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
                  child: const CircularProgressIndicator(
                    color: Colors.pink,
                  ),
                );
              } else if (playing != true) {
                return ClipOval(
                  child: Container(
                    color: AppColor.titleColor,
                    width: 60.0,
                    height: 60.0,
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 40.0,
                      color: AppColor.signInPageBackgroundColor,
                      onPressed: player.play,
                    ),
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return ClipOval(
                  child: Container(
                    color: AppColor.titleColor,
                    width: 60.0,
                    height: 60.0,
                    child: IconButton(
                      icon: Icon(Icons.pause,
                          color: AppColor.signInPageBackgroundColor),
                      iconSize: 40.0,
                      onPressed: player.pause,
                    ),
                  ),
                );
              } else {
                return ClipOval(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary.withAlpha(30),
                    width: 70.0,
                    height: 70.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.replay,
                        color: Colors.white,
                      ),
                      iconSize: 64.0,
                      onPressed: () => player.seek(Duration.zero),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            width: 16,
          ),
          // Opens volume slider dialog
          IconButton(
            onPressed: () {
              audioPlayerModel.skipPrevious();
              Provider.of<MediaPlayerModel>(context, listen: false)
                  .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
            },
            icon: const Icon(
              Icons.fast_rewind,
              size: 25.0,
              color: Colors.white,
            ),
          ),

          IconButton(
            onPressed: () {
              audioPlayerModel.skipNext();
              Provider.of<MediaPlayerModel>(context, listen: false)
                  .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
            },
            icon: const Icon(
              Icons.fast_forward,
              size: 25.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtonNew extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtonNew(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioProvider audioPlayerModel = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Opens volume slider dialog
          IconButton(
            onPressed: () {
              audioPlayerModel.skipPrevious();
              Provider.of<MediaPlayerModel>(context, listen: false)
                  .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
            },
            icon: const Icon(
              //Icons.skip_previous,
              Icons.fast_rewind,
              size: 25.0,
              color: Colors.white,
            ),
          ),

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
                  child: const CircularProgressIndicator(
                    color: Colors.pink,
                  ),
                );
              } else if (playing != true) {
                return ClipOval(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary.withAlpha(30),
                    width: 70.0,
                    height: 70.0,
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 40.0,
                      color: Colors.white,
                      onPressed: player.play,
                    ),
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return ClipOval(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary.withAlpha(30),
                    width: 70.0,
                    height: 70.0,
                    child: IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white),
                      iconSize: 40.0,
                      onPressed: player.pause,
                    ),
                  ),
                );
              } else {
                return ClipOval(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary.withAlpha(30),
                    width: 70.0,
                    height: 70.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.replay,
                        color: Colors.white,
                      ),
                      iconSize: 64.0,
                      onPressed: () => player.seek(Duration.zero),
                    ),
                  ),
                );
              }
            },
          ),

          IconButton(
            onPressed: () {
              audioPlayerModel.skipNext();
              Provider.of<MediaPlayerModel>(context, listen: false)
                  .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
            },
            icon: const Icon(
              Icons.fast_forward,
              size: 25.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class MediaCommentsLikesContainer extends StatefulWidget {
  const MediaCommentsLikesContainer({
    Key? key,
    required this.context,
    required this.currentMedia,
    required this.audioPlayerModel,
  }) : super(key: key);

  final BuildContext context;
  final Media? currentMedia;
  final AudioProvider audioPlayerModel;

  @override
  State<MediaCommentsLikesContainer> createState() =>
      _MediaCommentsLikesContainerState();
}

class _MediaCommentsLikesContainerState
    extends State<MediaCommentsLikesContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPlayerModel>(
      builder: (context, mediaPlayerModel, child) {
        return Container(
          height: 50,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  final id = await SharedPref.getValue(SharedPref.keyId);

                  if (id == null) {
                    Fluttertoast.showToast(msg: 'You are not logged in');
                    return;
                  }
                  try {
                    final response =
                        await Repository().likePost(widget.currentMedia?.id);
                    if (response['status'] == 'success') {
                      final message = response['message'];
                      if (message.contains("Disliked")) {
                        setState(() {
                          widget.currentMedia?.likesCount =
                              widget.currentMedia?.likesCount != null
                                  ? widget.currentMedia!.likesCount! - 1
                                  : 0;
                          widget.currentMedia?.userLiked = false;
                        });
                      } else {
                        setState(() {
                          widget.currentMedia?.likesCount =
                              widget.currentMedia?.likesCount != null
                                  ? widget.currentMedia!.likesCount! + 1
                                  : 0;
                          widget.currentMedia?.userLiked = true;
                        });
                      }
                    }
                  } catch (exception) {
                    debugPrint(exception.toString());
                  }
                },
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: FaIcon(FontAwesomeIcons.thumbsUp,
                        size: 26,
                        color: widget.currentMedia?.userLiked ?? false
                            ? Colors.pink
                            : Colors.white),
                  ),
                  widget.currentMedia?.likesCount == 0
                      ? const SizedBox.shrink()
                      : Text('${widget.currentMedia?.likesCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                ]),
              ),
              IconButton(
                onPressed: () {
                  widget.audioPlayerModel.shufflePlaylist();
                  Provider.of<MediaPlayerModel>(context, listen: false)
                      .setMediaLikesCommentsCount(
                          widget.audioPlayerModel.currentMedia);
                },
                icon: const Icon(
                  Icons.shuffle,
                  size: 26.0,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => widget.audioPlayerModel
                    .setShowList(!widget.audioPlayerModel.showList),
                icon: const Icon(
                  Icons.playlist_play,
                  size: 27.0,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => widget.audioPlayerModel.changeRepeat(),
                icon: widget.audioPlayerModel.isRepeat == true
                    ? const Icon(
                        Icons.repeat_one,
                        size: 26.0,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.repeat,
                        size: 26.0,
                        color: Colors.white,
                      ),
              ),
              MediaPopupMenu(widget.currentMedia),
            ],
          ),
        );
      },
    );
  }
}
