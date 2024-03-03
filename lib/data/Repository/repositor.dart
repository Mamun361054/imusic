import 'dart:convert';

import 'package:dhak_dhol/data/api/api_provider.dart';
import 'package:dhak_dhol/data/dio_service/http_service.dart';
import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:dhak_dhol/data/model/audio_upload_option_model.dart';
import 'package:dhak_dhol/data/model/firebase_model/Search_user_response.dart';
import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:dhak_dhol/data/model/home_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/model/opinion.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/like_comment_item.dart';
import '../model/search_model.dart';

class Repository {
  late HttpServiceImpl _httpServiceImpl;

  Repository() {
    _httpServiceImpl = HttpServiceImpl();
    _httpServiceImpl.init();
  }

  Future<UserModel?> loginUser(data) async {
    try {
      final response = await _httpServiceImpl.postRequest(ApiProvider.login, data);
      return UserModel.fromJson(response.data);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<SearchUserResponse?> chatUserSearch(keyword) async {
    try {

      final response = await _httpServiceImpl.getRequest(ApiProvider.userSearch+'?keyword=$keyword', );

      return SearchUserResponse.fromJson(response.data);

    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

//=========registration===========//
  Future<UserModel?> registrationUser(data) async {
    try {
      var response =
          await _httpServiceImpl.postRequest(ApiProvider.registration, data);

      // final obj = response.data.toString();
      // final result = jsonDecode(obj);
      // return UserModel.fromJson(result);

      // final arr = response.data.toString().split('</div>');

      // final res = jsonDecode(arr.last);

      return UserModel.fromJson(response.data);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //=========forget password ========//
  Future<UserModel?> forgetPassword(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.resetPassword, data);

      final arr = response.data.toString().split('</div>');

      final res = jsonDecode(arr.last);

      return UserModel.fromJson(res["registration"]);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<HomeModel?> fetchDashBoard() async {
    try {
      final response = await _httpServiceImpl.getRequest(ApiProvider.dashboard);

      // final arr = response.data.toString().split('</div>');

      final res = response.data['data'];

      return HomeModel.fromJson(res);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Albums>?> artistAlbum(page) async {
    try {
      final response =
          await _httpServiceImpl.getRequest("${ApiProvider.fetchArtists}$page");
      final parsed = response.data["data"];

      return parsed.map<Albums>((json) => Albums.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Albums>?> fetchAlbum(page) async {
    try {
      final response =
          await _httpServiceImpl.getRequest("${ApiProvider.fetchAlbum}$page");

      final parsed = response.data["data"];

      return parsed.map<Albums>((json) => Albums.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Media>?> fetchAlbumMedia({albumId, page}) async {
    try {
      final response = await _httpServiceImpl
          .getRequest("${ApiProvider.fetchAlbumMedia}/$albumId?page=$page");
      final parsed = response.data["data"];

      return parsed.map<Media>((json) => Media.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Artists>?> fetchArtists(page) async {
    try {
      final response = await _httpServiceImpl.getRequest(
        "${ApiProvider.fetchArtists}$page",
      );

      final parsed = response.data["data"]['items'];

      return parsed.map<Artists>((json) => Artists.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Media>?> fetchArtisMedia({artistId, page}) async {
    try {
      final response = await _httpServiceImpl.getRequest(
        "${ApiProvider.fetchArtistsMedia}/$artistId?page=$page",
      );

      final parsed = response.data['data'];

      return parsed.map<Media>((json) => Media.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Moods>?> fetchMoods(page) async {
    try {
      final response = await _httpServiceImpl.getRequest(
        "${ApiProvider.fetchMoods}$page",
      );
      final parsed = response.data['data'];

      return parsed.map<Moods>((json) => Moods.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Media>?> fetchMoodsMedia(moodId) async {
    try {
      final response = await _httpServiceImpl.getRequest(
        "${ApiProvider.fetchMoodsMedia}/$moodId",
      );

      final parsed = response.data['data'];

      return parsed.map<Media>((json) => Media.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// ==================== Add Album by user ===============
  Future addAlbum(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.addAlbums, data);
      return response.data;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<AudioUploadOptionModel?> uploadSongsItemFetch(data) async {
    try {
      final response = await _httpServiceImpl.postRequest(
          ApiProvider.fetchUploadSongData, data);
      final fetchData = mediaUploadOptionFromJson(response.data.toString());
      return fetchData;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future uploadSongs(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.uploadSongs, data);
      print("saiful  .....................${response.data}");
      return response.data;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Albums>?> fetchUserUploadAlbums(data) async {
    try {
      // final response = await _httpServiceImpl.postRequest(ApiProvider.userUploadAlbums, data);
      final response = await _httpServiceImpl
          .getRequest("${ApiProvider.fetchUserAlbum}$data&page=");
      final res = jsonDecode(response.data);
      final listRes =
          List<Albums>.from(res["albums"].map((x) => Albums.fromJson(x)))
              .toList();
      return listRes;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<SearchModel?> searchMediaData(query) async {
    try {
      final response = await _httpServiceImpl.getRequest(
        "${ApiProvider.search}?sort_order=asc&keyword=$query&user_id=",
      );

      final json = response.data["data"];

      return  SearchModel.fromJson(json);
    } on Exception catch (e) {
      debugPrint('error ${e.toString()}');
      return null;
    }
  }

  Future<List<Media>> genreMedia(data) async {
    try {
      final response = await _httpServiceImpl
          .getRequest("${ApiProvider.fetchgenreMedia}/$data");


      final parsed = response.data['data'];

      return parsed.map<Media>((json) => Media.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<LikeCommentCount?> getMediaLikesCommentsCount(data) async {
    try {
      final response = await _httpServiceImpl.postRequest(
          ApiProvider.getMediaTotalLikesAndCommentsViews, data);

      debugPrint(response.data.toString());

      final arr = response.data.toString().split('</div>');

      final res = jsonDecode(arr.last);

      final parsed = res.cast<Map<String, dynamic>>();

      return LikeCommentCount.fromJson(parsed);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool?> updateViewCount(data) async {
    try {
      final response = await _httpServiceImpl.postRequest(
          ApiProvider.updateMediaTotalViews, data);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future likePost(songId) async {
    try {
      final response = await _httpServiceImpl
          .getRequest("${ApiProvider.likeUnlikeMedia}/$songId");

      if (response.statusCode == 200) {
        return response.data;
      }
      return false;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<Response?> loadReply(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.loadReplies, data);

      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> loadMoreReply(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.loadReplies, data);

      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Media>?> fetchItems(page) async {
    try {
      final response =
          await _httpServiceImpl.getRequest("${ApiProvider.fetchTracks}$page");

      final parsed = response.data["data"];

      return parsed.map<Media>((json) => Media.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<Artists>?> allArtists() async {
    try {
      final response = await _httpServiceImpl.getRequest(
        ApiProvider.allArtists,
      );

      if (response.statusCode == 200) {}

      final parsed = response.data["data"]['items'];

      return parsed.map<Artists>((json) => Artists.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  ///album list for dropdown
  Future<List<Albums>?> allAlbums() async {
    try {
      final response = await _httpServiceImpl.getRequest(
        ApiProvider.allAlbums,
      );

      if (response.statusCode == 200) {}

      final parsed = response.data["data"];

      return parsed.map<Albums>((json) => Albums.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  ///genre list for dropdown
  Future<List<Genres>?> allGenres() async {
    try {
      final response = await _httpServiceImpl.getRequest(
        ApiProvider.allGenres,
      );

      if (response.statusCode == 200) {}

      final parsed = response.data["data"];

      return parsed.map<Genres>((json) => Genres.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  ///mood list for dropDown
  Future<List<Moods>?> allMoods() async {
    try {
      final response = await _httpServiceImpl.getRequest(
        ApiProvider.allMoods,
      );

      if (response.statusCode == 200) {}

      final parsed = response.data["data"];

      return parsed.map<Moods>((json) => Moods.fromJson(json)).toList();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  ///mood list for dropDown
  Future<List<Opinion>> getAllOpinionBySong({required int id}) async {
    try {
      final response = await _httpServiceImpl.getRequest(ApiProvider.opinions+'?media_id=$id');
      if (response.statusCode == 200) {
        final parsed = response.data["data"];
        return parsed.map<Opinion>((json) => Opinion.fromJson(json)).toList();
      }
      return [];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<Response?> constructReply(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.replyComment, data);

      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> deleteReply(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.deleteReply, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> editDelete(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.editReply, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> reportReply(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.replyComment, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future fetchComments(songId) async {
    print('comments...${ApiProvider.loadComments}/$songId');
    try {
      final response = await _httpServiceImpl
          .getRequest("${ApiProvider.loadComments}/$songId");

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> constructComment(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.makeComment, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> deleteComment(commentId) async {
    try {
      final response =
          // await _httpServiceImpl.postRequest(ApiProvider.deleteComment, data);
          await _httpServiceImpl.deleteRequest(
        "${ApiProvider.makeComment}/$commentId",
      );
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> editComment(data, commentId) async {
    try {
      final response = await _httpServiceImpl.postRequest(
          "${ApiProvider.makeComment}/$commentId", data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> reportComment(data) async {
    try {
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.reportComment, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> getAdvertise() async {
    try {
      final response = await _httpServiceImpl.getRequest(ApiProvider.ads);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> getProfileData({int? pid}) async {
    try {
      print('ApiProvider.profile ${ApiProvider.profile}');
      final response = await _httpServiceImpl.getRequest("${ApiProvider.profile}?user_id=${pid ?? ""}");
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> updateProfileData(data) async {
    try {
      print('ApiProvider.updateProfile ${ApiProvider.updateProfile}');
      final response =
          await _httpServiceImpl.postRequest(ApiProvider.updateProfile, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> createOpinion(data) async {
    try {
      final response = await _httpServiceImpl.postRequest(ApiProvider.createOpinion, data);
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  sendFirebaseTokenToServer(String token) async {
    bool? status = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("token_sent_to_server") != null) {
      status = prefs.getBool("token_sent_to_server");
    }
    if (status == false) {

      var data = {"token": token};

      FormData fromData = FormData.fromMap({"token": token});

      debugPrint(data.toString());

      debugPrint(ApiProvider.storeFcmToken);

      try {
        final response = await _httpServiceImpl.postRequest(
            ApiProvider.storeFcmToken, fromData);

        if (response.statusCode == 200) {
          debugPrint(response.data);
          Map<String, dynamic> res = json.decode(response.data);
          if (res["status"] == "ok") {
            prefs.setBool("token_sent_to_server", true);
          }
        }
      } catch (exception) {
        // I get no exception here
        debugPrint(exception.toString());
      }
    } else {
      debugPrint("Firebase token sent to server");
    }
  }
}
