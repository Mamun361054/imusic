import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../data/Repository/repositor.dart';
import '../data/model/comment.dart';
import '../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';

import '../utils/shared_pref.dart';

class CommentsModel with ChangeNotifier {
  List<Comments> _items = [];
  bool isError = false;
  int media = 0;
  int totalPostComments = 0;
  String? userdata;
  bool isLoading = false;
  bool isMakingComment = false;
  bool isMakingCommentsError = false;
  bool hasMoreComments = false;
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();
  final TextEditingController inputController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  late BuildContext _context;
  Repository repository = Repository();

  CommentsModel(BuildContext context, this.media, int commentCount) {
    _context = context;
    totalPostComments = commentCount;
    SharedPref.getValue(SharedPref.keyEmail).then((value) {
      userdata = value;
    });
    loadComments();
  }

  bool isUser(String email) {
    if (userdata == null) return false;
    return email == userdata;
  }

  loadComments() {
    isLoading = true;
    notifyListeners();
    fetchComments();
  }

  setCommentPostDetails() {}
  List<Comments> get items {
    return _items;
  }

  void setComments(List<Comments> item) {
    _items.clear();
    _items = item.reversed.toList();
    if (item.isEmpty) {
      isError = true;
    } else {
      isError = false;
    }
    isLoading = false;
    notifyListeners();
    if (items.length > 2) {
      if (scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 50), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  void setComment(item) {
    items.add(item);
    isMakingComment = false;
    inputController.clear();
    notifyListeners();
    if (items.length > 2) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void setMoreComments(List<Comments> item) {
    _items.insertAll(0, item.reversed.toList());
    isLoadingMore = false;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    //notifyListeners();
  }

  Future<void> fetchComments() async {
    try {
      final response = await repository.fetchComments(media);

      if (response != null) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = response;

        final status = res["status"];
        if (status == 'ok') {
          final parsed = response["comments"].cast<Map<String, dynamic>>();
          final commentsList =
              parsed.map<Comments>((json) => Comments.fromJson(json)).toList();
          setComments(commentsList);
        } else {
          setCommentsFetchError();
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setCommentsFetchError();
      }
    } catch (exception) {
      // I get no exception here
      debugPrint(exception.toString());
      setCommentsFetchError();
    }
    notifyListeners();
  }

  setCommentsFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }

  loadMoreComments() {
    isLoadingMore = true;
    fetchMoreComments();
    notifyListeners();
  }

  Future<void> fetchMoreComments() async {
    try {
      final data = FormData.fromMap({"id": items[0].id, "media": media});

      final response = await repository.fetchComments(data);

      if (response != null) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.data);

        final status = res["status"];

        if (status == 'ok') {
          // hasMoreComments = response.data["has_more"];
          final parsed = response["comments"].cast<Map<String, dynamic>>();
          final commentsList =
              parsed.map<Comments>((json) => Comments.fromJson(json)).toList();
          setMoreComments(commentsList);
        } else {
          loadMoreCommentsError();
        }
      } else {
        loadMoreCommentsError();
      }
    } catch (exception) {
      // I get no exception here
      debugPrint(exception.toString());
      loadMoreCommentsError();
    }
  }

  loadMoreCommentsError() {
    isLoadingMore = false;
    notifyListeners();
    Alerts.showCupertinoAlert(
        _context, 'Error', 'Cannot process commenting at the moment..');
  }

  makeComment(String content) {
    isMakingComment = true;
    constructComment(content);
    notifyListeners();
  }

  Future<void> constructComment(String content) async {
    try {
      FormData data = FormData.fromMap({
        "category": "music",
        "content": content,
        // "parent_comment_id": null,
        "id_of_category": media
      });

      final response = await repository.constructComment(data);

      if (response != null) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = response.data;

        if (res["status"] == "ok") {
          totalPostComments = res["total_count"];
          Comments item = Comments.fromJson(response.data["comment"]);
          setComment(item);
        } else {
          makeCommentsError();
        }
      } else {
        makeCommentsError();
      }
    } catch (exception) {
      // I get no exception here
      debugPrint(exception.toString());
      makeCommentsError();
    }
  }

  makeCommentsError() {
    isMakingComment = false;
    notifyListeners();
    Alerts.showCupertinoAlert(
        _context, 'Error', 'Cannot process commenting at the moment..');
  }

  Future<void> showDeleteCommentAlert(int commentId, int position) async {
    return showDialog(
        context: _context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Delete Comment'),
              content: const Text(
                  'Do you wish to delete this comment? This action cannot be undone'),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: const Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteComment(commentId, position);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: const Text('cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> deleteComment(int commentId, int position) async {
    Alerts.showProgressDialog(_context, 'Deleting comment');
    try {
      // ignore: unused_local_variable
      final data = FormData.fromMap({"id": commentId, "media": media});

      final response = await repository.deleteComment(commentId);

      if (response != null) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = response.data;

        if (res["status"] == "success") {
          totalPostComments = res["total_count"];

          Navigator.of(_context).pop();

          items.removeAt(position);

          notifyListeners();
        } else {
          processingErrorMessage('Cannot delete this comment at the moment..');
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage('Cannot delete this comment at the moment..');
      }
    } catch (exception) {
      debugPrint(exception.toString());
      processingErrorMessage('Cannot delete this comment at the moment..');
    }
  }

  static List<Comments> parseComments(json) {
    final parsed = json["comments"].cast<Map<String, dynamic>>();
    return parsed.map<Comments>((json) => Comments.fromJson(json)).toList();
  }

  Future<void> showEditCommentAlert(int commentId, int position) async {
    editController.text = items[position].content ?? '';
    await showDialog<void>(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(t.edit_comment_alert),
          content: SingleChildScrollView(
            child: TextFormField(
              controller: editController,
              maxLines: 5,
              minLines: 1,
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: const Text('Save'),
                onPressed: () {
                  String text = editController.text;
                  if (text != "") {
                    Navigator.of(context).pop();
                    editComment(commentId, text, position);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> editComment(int commentId, String content, int position) async {
    Alerts.showProgressDialog(_context, 'Editing comment');
    try {
      var encoded = content;

      final data = FormData.fromMap({
        "content": encoded,
      });

      final response = await repository.editComment(data, commentId);

      if (response != null) {
        String status = response.data["status"];
        if (status == "success") {
          Navigator.of(_context).pop();
          items[position].content = encoded;
          notifyListeners();
        } else {
          processingErrorMessage('Cannot edit this comment at the moment..');
        }
      } else {
        processingErrorMessage('Cannot edit this comment at the moment..');
      }
    } catch (exception) {
      debugPrint(exception.toString());
      processingErrorMessage('Cannot edit this comment at the moment..');
    }
  }

  Future<void> reportComment(int commentId, int position, String reason) async {
    Alerts.showProgressDialog(_context, 'Reporting Comment');
    try {
      var data = {
        "id": commentId,
        "type": "comments",
        "reason": reason,
        "email": userdata
      };
      debugPrint(data.toString());

      final response = await repository.deleteComment(data);

      if (response?.statusCode == 200) {
        String status = response?.data["status"];
        if (status == "ok") {
          totalPostComments -= 1;
          Navigator.of(_context).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage('Error Reporting Comment');
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage('Error Reporting Comment');
      }
    } catch (exception) {
      // I get no exception here
      debugPrint(exception.toString());
      processingErrorMessage('Error Reporting Comment');
    }
  }

  processingErrorMessage(String msg) {
    Navigator.of(_context).pop();
    Alerts.showCupertinoAlert(_context, 'Error', msg);
  }
}
