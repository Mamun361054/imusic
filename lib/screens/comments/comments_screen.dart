import 'package:dhak_dhol/screens/auth/sign_in/sign_in_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../data/model/comment.dart';
import '../../data/model/media_model.dart';
import '../../provider/comments_model.dart';
import '../../provider/replies_model.dart';
import '../../utils/shared_pref.dart';
import '../../widgets/comments_Item.dart';
import '../../widgets/comments_media_header.dart';

class CommentsScreen extends StatefulWidget {
  static String routeName = "/comments";
  final Media? item;
  final int? commentCount;

  const CommentsScreen({Key? key, this.item, this.commentCount})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RepliesModel(context,
            (widget.item as Comments).id ?? 0, widget.commentCount ?? 0),
        child: CommentsSection(widget: widget));
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CommentsScreen widget;

  @override
  Widget build(BuildContext context) {
    print("saiful id${widget.item?.id}");
    return ChangeNotifierProvider(
      create: (_) => CommentsModel(
          context, widget.item?.id ?? 0, widget.commentCount ?? 0),
      child: FutureBuilder<String?>(
        future: SharedPref.getValue(SharedPref.keyEmail),
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(
                  context,
                  Provider.of<CommentsModel>(context, listen: false)
                      .totalPostComments);
              return false;
            },
            child: Scaffold(
              backgroundColor: AppColor.deepBlue,
              appBar: AppBar(
                backgroundColor: AppColor.deepBlue,
                leading: BackButton(
                  onPressed: () => Navigator.pop(
                      context,
                      Provider.of<CommentsModel>(context, listen: false)
                          .totalPostComments),
                ),
                title: const Text('comments'),
              ),
              body: Column(
                children: <Widget>[
                  if (widget.item != null)
                    CommentsMediaHeader(object: widget.item!),
                  Container(height: 5),
                  const Expanded(
                    child: CommentsLists(),
                  ),
                  const Divider(height: 0, thickness: 1),
                  snapshot.data == null
                      ? SizedBox(
                          height: 50,
                          child: Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.backgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    textStyle: const TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SignInScreen.routeName);
                                  },
                                  child: const Text(
                                    'Login to add a comment',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        )
                      : Consumer<CommentsModel>(
                          builder: (context, commentsModel, child) {
                          return Row(
                            children: <Widget>[
                              Container(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: commentsModel.inputController,
                                  maxLines: 5,
                                  minLines: 1,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: 'Write a message...',
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              ),
                              commentsModel.isMakingComment
                                  ? const SizedBox(
                                      width: 30,
                                      child: CupertinoActivityIndicator())
                                  : IconButton(
                                      icon: const Icon(Icons.send,
                                          color: Colors.white, size: 20),
                                      onPressed: () {
                                        String text =
                                            commentsModel.inputController.text;
                                        if (text != "") {
                                          commentsModel.makeComment(text);
                                        }
                                      }),
                            ],
                          );
                        })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CommentsLists extends StatelessWidget {
  const CommentsLists({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentsModel = Provider.of<CommentsModel>(context);
    List<Comments> commentsList = commentsModel.items;
    if (commentsModel.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    } else if (commentsList.isEmpty) {
      return Center(
          child: SizedBox(
        height: 200,
        child: GestureDetector(
          onTap: () {
            commentsModel.loadComments();
          },
          child: ListView(children: const <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              'No comments',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ));
    } else {
      return ListView.separated(
        controller: commentsModel.scrollController,
        itemCount: commentsModel.hasMoreComments
            ? commentsList.length + 1
            : commentsList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          if (index == 0 && commentsModel.isLoadingMore) {
            return const SizedBox(
                width: 30, child: Center(child: CupertinoActivityIndicator()));
          } else if (index == 0 && commentsModel.hasMoreComments) {
            return SizedBox(
              height: 30,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        textStyle:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      child: const Text('Load more',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Provider.of<CommentsModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int tmpIndex = index;
            if (commentsModel.hasMoreComments) tmpIndex = index - 1;
            return CommentsItem(
              isUser: commentsModel.isUser(commentsList[tmpIndex].email ?? ''),
              context: context,
              index: tmpIndex,
              object: commentsList[tmpIndex],
            );
          }
        },
      );
    }
  }
}
