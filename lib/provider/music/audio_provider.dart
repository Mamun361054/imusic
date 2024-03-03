import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audio_session/audio_session.dart';
import 'package:audiofileplayer/audio_system.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/model/opinion.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dhak_dhol/utils/utility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/Repository/repositor.dart';

EventBus eventBus = EventBus();
final Logger _logger = Logger('stream_flutter');

class AudioProvider extends ChangeNotifier with WidgetsBindingObserver {
  late BuildContext _context;
  TextEditingController opinionTitleController = TextEditingController();
  TextEditingController opinionDescriptionController = TextEditingController();
  bool isOpinion = false;
  List<Media> currentPlaylist = [];
  List<AudioSource> audioSourceList = [];
  Media? currentMedia;
  int currentMediaPosition = 0;
  Color backgroundColor = AppColor.backgroundColor;
  bool isDialogShowing = false;

  double backgroundAudioDurationSeconds = 0.0;
  double backgroundAudioPositionSeconds = 0.0;

  bool isSeeking = false;
  AudioPlayer player = AudioPlayer();
  late LockCachingAudioSource _audioSource;
  bool remoteAudioPlaying = false;
  bool _remoteAudioLoading = false;
  bool isUserSubscribed = false;
  StreamController<double>? audioProgressStreams;
  late AudioSession session;
  bool playInterrupted = false;
  List<Opinion> opinions = [];

  /// Identifiers for the two custom Android notification buttons.
  static const String replayButtonId = 'replayButtonId';
  static const String newReleasesButtonId = 'newReleasesButtonId';
  static const String skipPreviousButtonId = 'skipPreviousButtonId';
  static const String skipNextButtonId = 'skipNextButtonId';


  List<AudioPlayer> audioPlayerList = [];

  AudioProvider() {
    registerEvents();
    getRepeatMode();
    AudioSystem.instance.addMediaEventListener(_mediaEventListener);
    audioProgressStreams = StreamController<double>.broadcast();
    audioProgressStreams?.add(0);
    initSession();
  }

  void generate() async {
    List.generate(currentPlaylist.length, (index){
      audioPlayerList.add(AudioPlayer());
    });
  }

  initSession() async {
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    session.becomingNoisyEventStream.listen((_) {
      debugPrint('PAUSE');
      onPressed();
    });
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Another app started playing audio and we should duck.
            player.setVolume(player.volume / 2);
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            // Another app started playing audio and we should pause.
            debugPrint("interruption started");
            if (remoteAudioPlaying) {
              _pauseBackgroundAudio();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // The interruption ended and we should unduck.
            player.setVolume(min(1.0, player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          // The interruption ended and we should resume.
          case AudioInterruptionType.unknown:
            // The interruption ended but we should not resume.
            if (remoteAudioPlaying) {
              _pauseBackgroundAudio();
              playInterrupted = true;
            }
            break;
        }
      }
    });
  }

  registerEvents() {
    //logged in event
    eventBus.on<OnVideoStarted>().listen((event) {
      debugPrint("user login event called");
      _pauseBackgroundAudio();
    });
    //when user initiates a new chat
  }

  bool _isRepeat = false;

  bool get isRepeat => _isRepeat;

  changeRepeat() async {
    _isRepeat = !_isRepeat;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("_isRepeatMode", _isRepeat);
  }

  getRepeatMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("_isRepeatMode") != null) {
      _isRepeat = prefs.getBool("_isRepeatMode") ?? false;
    }
  }

  setUserSubscribed(bool isUserSubscribed) {
    this.isUserSubscribed = isUserSubscribed;
  }

  setContext(BuildContext context) {
    _context = context;
  }

  bool _showList = false;

  bool get showList => _showList;

  setShowList(bool showList) {
    _showList = showList;
    notifyListeners();
  }

  preparePlaylist(List<Media> playlist, Media media, int? index) async {
    currentPlaylist = playlist;
    getOpinions(media: media);
    for (Media media in currentPlaylist) {
      audioSourceList.add(LockCachingAudioSource(
        Uri.parse('${media.streamUrl}'),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${media.id}',
          // Metadata to display in the notification:
          album: '${media.album}',
          title: '${media.title}',
          artUri: Uri.parse('${media.coverPhoto}',
          ),
        ),
      ));
    }

    generate();

    _audioSource = audioSourceList[currentMediaPosition] as LockCachingAudioSource;

    startAudioPlayBack(media);
  }

  startAudioPlayBack(Media? media) async {
    await player.pause();
    if (await session.setActive(true)) {
      if (media != null) {
        // Now play audio.
        playAudioNow(media);
      }
    }
    session.setActive(true);
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<AudioPositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, double, Duration?, AudioPositionData>(
          player.positionStream,
          _audioSource.downloadProgressStream,
          player.durationStream,
          (position, downloadProgress, reportedDuration) {
        final duration = reportedDuration ?? Duration.zero;
        final bufferedPosition = duration * downloadProgress;
        return AudioPositionData(position, bufferedPosition, duration);
      });

  ///playing currently selected media
  playAudioNow(Media media) async {
    currentMedia = media;
    setCurrentMediaPosition();
    _remoteAudioLoading = true;
    remoteAudioPlaying = false;
    notifyListeners();
    audioProgressStreams?.add(0);

    debugPrint('Audio Title ${media.title}');
    debugPrint('Audio id ${media.id}');
    debugPrint('Audio stream ${media.streamUrl}');

    ///assign current media in audio source queue
    ///so that current media play first place in player
    audioSourceList[0] = LockCachingAudioSource(
      Uri.parse('${media.streamUrl}'),
      tag: MediaItem(
        /// Specify a unique ID for each media item:
        id: '${media.id}',

        /// Metadata to display in the notification:
        album: '${media.album}',

        /// title to display in the notification:
        title: '${media.title}',

        /// cover photo to display in the notification:
        artUri: Uri.parse(
          '${media.coverPhoto}',
        ),
      ),
    );

    
    File file = File(media.streamUrl!);

    bool isExists = await file.exists();


    await player.dispose();
    player = audioPlayerList[currentMediaPosition];
    player = AudioPlayer();

    
    ///ConcatenatingAudioSource in player so media will play in a
    ///sequence into audio player as well as notification system tray
    if (media.streamUrl != null) {
      media.streamUrl!.startsWith('http')
          ? await player.setAudioSource(ConcatenatingAudioSource(children: audioSourceList),
              initialIndex: currentMediaPosition)
          : await player.setUrl('file://${media.streamUrl}',
              initialPosition: Duration.zero, preload: true);
    }

    await player.play();

    player.positionStream.listen((position) {
      debugPrint('positionStream = ${position.inSeconds}');
      backgroundAudioPositionSeconds =
          double.parse(position.inSeconds.toString());
      //if (isSeeking) return;
      audioProgressStreams?.add(backgroundAudioPositionSeconds);

      if (Utility.isPreviewDuration(
          currentMedia!, position.inSeconds, isUserSubscribed)) {
        _pauseBackgroundAudio();
      }

      if (player.duration?.inSeconds == position.inSeconds) {
        if (_isRepeat) {
          startAudioPlayBack(currentMedia);
        } else {
          skipNext();
        }
      }
      notifyListeners();
    });

    player.durationStream.listen((duration) {
      debugPrint("durationStream =  ${duration?.inSeconds}");
      _remoteAudioLoading = false;
      remoteAudioPlaying = true;
      backgroundAudioDurationSeconds =
          double.parse((duration?.inSeconds ?? Duration.zero).toString());
      notifyListeners();
    });

    player.playbackEventStream.listen((event) {
      debugPrint('Buffered position ${event.bufferedPosition.inSeconds}');
    }, onError: (_) {
      player.dispose();
      remoteAudioPlaying = false;
      _remoteAudioLoading = false;
    });

    remoteAudioPlaying = false;
    setMediaNotificationData(0);
  }

  setCurrentMediaPosition() {
    if (currentMedia != null) {
      currentMediaPosition = currentPlaylist.indexOf(currentMedia!);
      if (currentMediaPosition == -1) {
        currentMediaPosition = 0;
      }
      debugPrint("currentMediaPosition = $currentMediaPosition");
    }
  }

  cleanUpResources() {
    _stopBackgroundAudio();
  }

  Widget icon(bool isMiniPlayer) {
    print('_remoteAudioLoading $_remoteAudioLoading');
    print('isMiniPlayer $isMiniPlayer');
    print('remoteAudioPlaying $remoteAudioPlaying');

    if (_remoteAudioLoading) {
      return Theme(
          data: ThemeData(
              cupertinoOverrideTheme:
                  const CupertinoThemeData(brightness: Brightness.dark)),
          child: const CupertinoActivityIndicator());
    }
    if (remoteAudioPlaying) {
      if (isMiniPlayer) {
        return const Icon(
          Icons.pause,
          size: 40,
        );
      }
      return const Icon(
        Icons.pause,
        size: 40,
        color: Colors.white,
      );
    }
    if (isMiniPlayer) {
      return const Icon(
        Icons.play_arrow,
        size: 40,
      );
    }
    return const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );
  }

  onPressed() async {
    if (remoteAudioPlaying) {
      _pauseBackgroundAudio();
    } else {
      if (await session.setActive(true)) {
        // Now play audio.
        _resumeBackgroundAudio();
      }
    }
  }

  void _mediaEventListener(MediaEvent mediaEvent) {
    _logger.info('App received media event of type: ${mediaEvent.type}');
    final MediaActionType type = mediaEvent.type;
    if (type == MediaActionType.play) {
      _resumeBackgroundAudio();
    } else if (type == MediaActionType.pause) {
      _pauseBackgroundAudio();
    } else if (type == MediaActionType.playPause) {
      remoteAudioPlaying ? _pauseBackgroundAudio() : _resumeBackgroundAudio();
    } else if (type == MediaActionType.stop) {
      _stopBackgroundAudio();
    } else if (type == MediaActionType.seekTo) {
      player.seek(
          Duration(seconds: mediaEvent.seekToPositionSeconds?.ceil() ?? 0));
      AudioSystem.instance
          .setPlaybackState(true, mediaEvent.seekToPositionSeconds ?? 0.0);
    } else if (type == MediaActionType.next) {
      debugPrint("skip next");
      skipNext();
      final double skipIntervalSeconds = mediaEvent.skipIntervalSeconds ?? 0.0;
      _logger.info(
          'Skip-forward event had skipIntervalSeconds $skipIntervalSeconds.');
      _logger.info('Skip-forward is not implemented in this example app.');
    } else if (type == MediaActionType.previous) {
      debugPrint("skip next");
      skipPrevious();
      final double skipIntervalSeconds = mediaEvent.skipIntervalSeconds ?? 0.0;
      _logger.info(
          'Skip-backward event had skipIntervalSeconds $skipIntervalSeconds.');
      _logger.info('Skip-backward is not implemented in this example app.');
    } else if (type == MediaActionType.custom) {
      if (mediaEvent.customEventId == replayButtonId) {
        player.play();
        AudioSystem.instance.setPlaybackState(true, 0.0);
      } else if (mediaEvent.customEventId == newReleasesButtonId) {
        _logger
            .info('New-releases button is not implemented in this exampe app.');
      }
    }
  }

  Future<void> _resumeBackgroundAudio() async {
    await player.play();
    remoteAudioPlaying = true;
    notifyListeners();
    setMediaNotificationData(0);
  }

  void _pauseBackgroundAudio() {
    player.pause();
    remoteAudioPlaying = false;
    notifyListeners();
    setMediaNotificationData(1);
  }

  void _stopBackgroundAudio() {
    player.pause();
    remoteAudioPlaying = false;
    notifyListeners();
    AudioSystem.instance.stopBackgroundDisplay();
  }

  void shufflePlaylist() {
    currentPlaylist.shuffle();
    startAudioPlayBack(currentPlaylist[0]);
  }

  skipPrevious() {
    if (currentPlaylist.isEmpty || currentPlaylist.length == 1) return;
    int pos = currentMediaPosition - 1;
    if (pos == -1) {
      pos = currentPlaylist.length - 1;
    }
    Media media = currentPlaylist[pos];
    startAudioPlayBack(media);
  }

  skipNext() {
    if (currentPlaylist.isEmpty || currentPlaylist.length == 1) return;
    int pos = currentMediaPosition + 1;
    if (pos >= currentPlaylist.length) {
      pos = 0;
    }
    Media media = currentPlaylist[pos];

    startAudioPlayBack(media);
  }

  seekTo(double positionSeconds) {
    //audioProgressStreams.add(_backgroundAudioPositionSeconds);
    //_remoteAudio.seek(positionSeconds);
    //isSeeking = false;
    backgroundAudioPositionSeconds = positionSeconds;
    player.seek(Duration(seconds: positionSeconds.ceil()));
    audioProgressStreams?.add(backgroundAudioPositionSeconds);
    AudioSystem.instance.setPlaybackState(true, positionSeconds);
  }

  onStartSeek() {
    isSeeking = true;
  }

  setMediaNotificationData(int state) async {
    if (state == 0) {
      AudioSystem.instance
          .setPlaybackState(true, backgroundAudioPositionSeconds);
      AudioSystem.instance.setAndroidNotificationButtons(<dynamic>[
        AndroidMediaButtonType.pause,
        AndroidMediaButtonType.previous,
        AndroidMediaButtonType.next,
        AndroidMediaButtonType.stop,
        const AndroidCustomMediaButton(
            'replay', replayButtonId, 'ic_replay_black_36dp')
      ], androidCompactIndices: <int>[
        0
      ]);
    } else {
      AudioSystem.instance
          .setPlaybackState(false, backgroundAudioPositionSeconds);
      AudioSystem.instance.setAndroidNotificationButtons(<dynamic>[
        AndroidMediaButtonType.play,
        AndroidMediaButtonType.previous,
        AndroidMediaButtonType.next,
        AndroidMediaButtonType.stop,
        const AndroidCustomMediaButton(
            'replay', replayButtonId, 'ic_replay_black_36dp')
      ], androidCompactIndices: <int>[
        0
      ]);
    }

    AudioSystem.instance.setMetadata(AudioMetadata(
        title: currentMedia?.title,
        artist: currentMedia?.artist,
        album: currentMedia?.album,
        genre: currentMedia?.genre,
        durationSeconds: backgroundAudioDurationSeconds,
        artBytes: null));

    AudioSystem.instance.setSupportedMediaActions(<MediaActionType>{
      MediaActionType.playPause,
      MediaActionType.pause,
      MediaActionType.next,
      MediaActionType.previous,
      MediaActionType.skipForward,
      MediaActionType.skipBackward,
      MediaActionType.seekTo,
    }, skipIntervalSeconds: 30);
  }

  void createOpinion({required BuildContext context}) async {
    isOpinion = true;
    notifyListeners();
    try {
      var data = FormData.fromMap({
        'media_id': currentMedia?.id,
        'title': opinionTitleController.text,
        'description': opinionDescriptionController.text,
      });

      final response = await Repository().createOpinion(data);

      isOpinion = false;
      notifyListeners();

      if (response?.statusCode == 200) {
        getOpinions(media: currentMedia!);
        opinionDescriptionController.clear();
        opinionTitleController.clear();
        Navigator.pop(context);
      }
    } catch (e) {
      isOpinion = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: 'try again later',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: AppColor.backgroundColor2,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  void getOpinions({required Media media}) async {
      opinions = [];
      opinions = await Repository().getAllOpinionBySong(id: media.id??0);
      notifyListeners();
  }
}

class OnVideoStarted {
  OnVideoStarted();
}

class AudioPositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  AudioPositionData(this.position, this.bufferedPosition, this.duration);
}
