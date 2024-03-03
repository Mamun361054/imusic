import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/screens/home/music_player_page/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MusicProvider extends ChangeNotifier with WidgetsBindingObserver {
  final player = AudioPlayer();
  LockCachingAudioSource? audioSource;
  Media? currentAudio;
  List<Media> medialList = [];
  int playerIndex = 0;
  Duration? durationMin;
  late AudioSession session;
  bool remoteAudioPlaying = false;
  bool tmpRemoteAudioLoading = false;
  bool isUserSubscribed = false;

  MusicProvider() {
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  playCurrentMusic({Media? media, List<Media>? listOfMedia, int? playListIndex}) {
    currentAudio = media;
    medialList = listOfMedia ?? [];
    playerIndex = playListIndex!;
    startPlayMusic(media!);
    notifyListeners();
  }

  startPlayMusic(Media media) async {
    _init();
  }


  Future<void> _init() async {
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    final playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder(),
        // Specify the playlist items
        children: medialList
            .map((e) => LockCachingAudioSource(Uri.parse(e.streamUrl!)))
            .toList());

    if(currentAudio != null){
      currentAudio!.streamUrl!.startsWith('http')
          ? await player.setAudioSource(playlist,initialIndex: playerIndex)
          : player.setUrl(
          'file://${currentAudio?.streamUrl}',
          initialPosition: Duration.zero,
          preload: true);
    }

    /// play audio from here =================
    // audioSource = await player.setAudioSource(playlist, initialIndex: playerIndex) as LockCachingAudioSource?;
    await player.play();
    notifyListeners();

    try {
      await audioSource?.clearCache();
      await player.setAudioSource(playlist);
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }

    /// The duration of the current audio.
    player.durationStream.listen((event) {
      remoteAudioPlaying = true;
      debugPrint("duration in sec: ${event?.inSeconds}");
      notifyListeners();
    });

    /// A stream of [PlaybackEvent]s.
    player.playbackEventStream.listen((event) {
      debugPrint('Buffered position ${event.bufferedPosition.inSeconds}');
    },onError: (_) {
      player.dispose();
      remoteAudioPlaying = false;
    });
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream, (position, bufferedPosition, duration) {
        durationMin = duration;
        return PositionData(
            position, bufferedPosition, duration ?? Duration.zero);
      });

  preparePlaylist(List<Media> playlist, Media media) async {
    // currentPlaylist = playlist;
    // startAudioPlayBack(media);
  }
}
