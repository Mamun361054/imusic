

class LikeCommentCount {

    int commentCount;
    int likeCount;
    bool isLiked;

  LikeCommentCount({required this.commentCount, required this.likeCount, this.isLiked = false});

  factory LikeCommentCount.fromJson(Map<String,dynamic> json){
    return LikeCommentCount(
      likeCount: json['total_likes'],
      commentCount: json['total_comments'],
      isLiked: json['isLiked']
    );
  }
  @override
  String toString() {
    return 'like :$likeCount comments : $commentCount isLiked : $isLiked';
  }
}


