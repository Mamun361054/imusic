import 'package:dhak_dhol/data/model/replies.dart';

class ConstructComment {
  final int? totalCommentReply;
  final Replies? replies;

  ConstructComment({this.totalCommentReply, this.replies});

  factory ConstructComment.fromJson(Map<String, dynamic> json) {
    return ConstructComment(
        totalCommentReply: json['total_count'],
        replies: Replies.fromJson(json["comment"]));
  }
}
