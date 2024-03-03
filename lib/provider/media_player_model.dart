import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import '../data/Repository/repositor.dart';
import '../data/model/comments_arguement.dart';
import '../data/model/like_comment_item.dart';
import '../data/model/media_model.dart';
import '../screens/comments/comments_screen.dart';
import '../utils/shared_pref.dart';

class MediaPlayerModel with ChangeNotifier {
  Media? currentMedia;
  String? userdata;
  Repository repository = Repository();
  LikeCommentCount? likeCommentCount;

  MediaPlayerModel(Media? media) {
    setMediaLikesCommentsCount(media);
  }

  setMediaLikesCommentsCount(Media? media) {
    currentMedia = media;
    debugPrint("userLiked = ${currentMedia?.likesCount}");
    likeCommentCount = LikeCommentCount(
        commentCount: media?.commentsCount ?? 0,
        likeCount: media?.likesCount ?? 0,
        isLiked: media?.userLiked ?? false);
    // updateViewsCount();
    notifyListeners();
    // getMediaLikesCommentsCount();
  }

  // Future<void> getMediaLikesCommentsCount() async {
  //   final email = await SharedPref.getValue(SharedPref.keyEmail);
  //
  //   try {
  //     final data = FormData.fromMap({
  //       "media": currentMedia?.id,
  //       "email": email,
  //     });
  //
  //     debugPrint("get_media_count = $data");
  //     final likeCommentData = await repository.getMediaLikesCommentsCount(data);
  //     if (likeCommentData != null) {
  //       notifyListeners();
  //     }
  //   } catch (exception) {
  //     debugPrint(exception.toString());
  //   }
  // }

  Future<void> updateViewsCount() async {
    var data = {"media": currentMedia?.id};

    debugPrint(data.toString());

    try {
      final isSuccess = await repository.updateViewCount(data);
      if (isSuccess == true) {}
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  Future<void> likePost(songId) async {
    // ignore: unused_local_variable
    final email = await SharedPref.getValue(SharedPref.keyEmail);
    final id = await SharedPref.getValue(SharedPref.keyId);

    if (id == null) {
      Fluttertoast.showToast(msg: 'You are not logged in');
      return;
    }
    try {
      final response = await repository.likePost(songId);
      if (response['status'] == 'success') {
        final message = response['message'];
        if (message.contains("Disliked")) {
          likeCommentCount?.likeCount -= 1;
          likeCommentCount?.isLiked = false;
          notifyListeners();
        } else {
          likeCommentCount?.likeCount += 1;
          likeCommentCount?.isLiked = true;
          notifyListeners();
        }
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  navigateToCommentsScreen(BuildContext context) async {
    var count = await Navigator.pushNamed(
      context,
      CommentsScreen.routeName,
      arguments: CommentsArgument(
          item: currentMedia, commentCount: currentMedia?.commentsCount),
    );
    if (count != null) {
      currentMedia?.commentsCount = count as int;
      notifyListeners();
    }
  }
}
