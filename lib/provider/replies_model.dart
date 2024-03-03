import 'package:dhak_dhol/data/model/construct_comment.dart';
import 'package:dhak_dhol/utils/alerts.dart';
import 'package:dhak_dhol/utils/utility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../data/Repository/repositor.dart';
import '../data/model/replies.dart';
import 'dart:async';
import '../utils/shared_pref.dart';

class RepliesModel with ChangeNotifier {
  List<Replies> _items = [];
  bool isError = false;
  int commentId = 0;
  int totalCommentsReply = 0;
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
  ConstructComment? constructComment;
  Repository repository = Repository();

  RepliesModel(BuildContext context, this.commentId,
      this.totalCommentsReply) {
    _context = context;
    SharedPref.getValue(SharedPref.keyEmail).then((value){
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

  List<Replies> get items {
    return _items;
  }

  void setComments(List<Replies> item) {
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

  void setComment(Replies item) {
    items.add(item);
    isMakingComment = false;
    inputController.clear();
    notifyListeners();
    if (items.length > 2) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void setMoreArticles(List<Replies> item) {
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
      var data = {
        "id": 0,
        "comment": commentId,
      };
      debugPrint("get_media_count = $data");
      final response = await repository.loadReply(data);
      if (response?.statusCode == 200) {
        hasMoreComments = response?.data["has_more"];
        List<Replies> comments = await compute(parseComments, response?.data);
        setComments(comments);
      }else{
        setCommentsFetchError();
      }
    } catch (exception) {
      debugPrint(exception.toString());
      setCommentsFetchError();
    }
  }

  Future<void> fetchMoreComments() async {
    try {

      final data = FormData.fromMap({
        "id": items[0].id,
        "comment": commentId,
      });

      debugPrint("get_media_count = $data");
      final response = await repository.loadMoreReply(data);
      if (response?.statusCode == 200) {
        hasMoreComments = response?.data["has_more"];
        List<Replies> comments = await compute(parseComments, response?.data);
        setMoreArticles(comments);
      }else{
        loadMoreCommentsError();
      }
    } catch (exception) {
      debugPrint(exception.toString());
      loadMoreCommentsError();
    }
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

  loadMoreCommentsError() {
    isLoadingMore = false;
    notifyListeners();
    Alerts.showCupertinoAlert(_context, 'Error', 'Cannot load more comments at the moment..');
  }

  makeComment(String content) {
    isMakingComment = true;
    getConstructComment(content);
    notifyListeners();
  }

  Future<void> getConstructComment(String content) async {
    try {

      final data = FormData.fromMap({
        "content": Utility.getBase64EncodedString(content),
        "email": userdata,
        "comment": commentId
      });

      debugPrint("get_media_count = $data");

      final response = await repository.constructReply(data);

      if (response?.statusCode == 200) {

        String status = response?.data["ok"];

        if(status == 'ok'){
          constructComment =  ConstructComment.fromJson(response?.data);
        }
      } else {
        makeCommentsError();
      }
    } catch (exception) {
      debugPrint(exception.toString());
      makeCommentsError();
    }
  }


  makeCommentsError() {
    isMakingComment = false;
    notifyListeners();
    Alerts.showCupertinoAlert(_context, 'Error', 'Cannot process commenting at the moment..');
  }

  Future<void> showDeleteCommentAlert(int commentId, int position) async {
    return showDialog(
        context: _context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Delete Comment'),
              content: const Text('Do you wish to delete this comment? This action cannot be undone'),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteComment(commentId, position);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: const Text('Cancel'),
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

      final data = FormData.fromMap({
        "id": commentId, "comment": commentId
      });


      debugPrint(data.toString());

      final response = await repository.constructReply(data);

      if (response?.statusCode == 200) {

        String status = response?.data["status"];
        if (status == "ok") {
          totalCommentsReply = int.parse(response?.data["total_count"]);
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
      // I get no exception here
      debugPrint(exception.toString());
      processingErrorMessage('Cannot delete this comment at the moment..');
    }
  }

  static List<Replies> parseComments(jsonData) {
    final parsed = jsonData["comments"].cast<Map<String, dynamic>>();
    return parsed.map<Replies>((json) => Replies.fromJson(json)).toList();
  }

  Future<void> showEditCommentAlert(int commentId, int position) async {
    editController.text =
        Utility.getBase64DecodedString(items[position].content ?? '');
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
                child: const Text('cancel'),
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

  Future<void> editComment(int id, String content, int position) async {
    Alerts.showProgressDialog(_context, 'Editing comment');
    try {
      var encoded = Utility.getBase64EncodedString(content);

      final data = FormData.fromMap({
        "content": encoded,
        "id": id,
        "email": userdata,
        "comment": commentId
      });

      debugPrint(data.toString());

      final response = await repository.constructReply(data);

      if (response?.statusCode == 200) {

        String status = response?.data["status"];
        if (status == "ok") {
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
      // I get no exception here
      debugPrint(exception.toString());
      processingErrorMessage('Cannot edit this comment at the moment..');
    }
  }

  Future<void> reportComment(int commentId, int position, String reason) async {
    Alerts.showProgressDialog(_context, 'Reporting Comment');
    try {

      final data = FormData.fromMap({
        "id": commentId,
        "type": "replies",
        "reason": reason,
        "email": userdata
      });

      final response = await repository.constructReply(data);

      if (response?.statusCode == 200) {

        String status = response?.data["status"];

        if (status == "ok") {
          totalCommentsReply -= 1;
          Navigator.of(_context).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage('Error Reporting Comment');
        }
      } else {
        processingErrorMessage('Error Reporting Comment');
      }
    } catch (exception) {
      debugPrint(exception.toString());
      processingErrorMessage('Error Reporting Comment');
    }
  }

  processingErrorMessage(String msg) {
    Navigator.of(_context).pop();
    Alerts.showCupertinoAlert(_context, 'Error', msg);
  }
}
