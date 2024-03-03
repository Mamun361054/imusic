import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../data/model/comment.dart';
import '../../data/model/replies.dart';
import '../../provider/replies_model.dart';
import '../../utils/shared_pref.dart';
import '../../widgets/replyCardItem.dart';
import '../auth/sign_in/sign_in_screen.dart';

class RepliesScreen extends StatefulWidget {
  static String routeName = "/replies";
  final Object? item;
  final int? repliesCount;

  const RepliesScreen({Key? key, this.item, this.repliesCount}) : super(key: key);

  @override
  State<RepliesScreen> createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {

  String? userdata;

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.item.toString());

    SharedPref.getValue(SharedPref.keyEmail).then((value){
      userdata = value;
      return ChangeNotifierProvider(
          create: (context) => RepliesModel(context, (widget.item as Comments).id ?? 0,
              widget.repliesCount ?? 0),
          child: RepliesSection(widget: widget, userdata: userdata));
    });
    return const SizedBox();
  }
}

class RepliesSection extends StatelessWidget {
  const RepliesSection({
    Key? key,
    required this.widget,
    required this.userdata,
  }) : super(key: key);

  final RepliesScreen widget;
  final String? userdata;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context,
            Provider.of<RepliesModel>(context, listen: false)
                .totalCommentsReply);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(
                context,
                Provider.of<RepliesModel>(context, listen: false)
                    .totalCommentsReply),
          ),
          title: const Text('Replies'),
        ),
        body: Column(
          children: <Widget>[
            Container(height: 3),
            const Expanded(
              child: RepliesLists(),
            ),
            const Divider(height: 0, thickness: 1),
            userdata == null
                ? SizedBox(
                    height: 50,
                    child: Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.backgroundColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              textStyle:
                                  const TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            child: const Text('Login to reply'),
                            onPressed: () {
                              Navigator.pushNamed(context, SignInScreen.routeName);
                            })),
                  )
                : Consumer<RepliesModel>(
                    builder: (context, commentsModel, child) {
                    return Row(
                      children: <Widget>[
                        Container(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentsModel.inputController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration.collapsed(
                                hintText: 'Write a message'),
                          ),
                        ),
                        commentsModel.isMakingComment
                            ? const SizedBox(
                                width: 30, child: CupertinoActivityIndicator())
                            : IconButton(
                                icon: Icon(Icons.send,
                                    color: AppColor.backgroundColor, size: 20),
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
  }
}

class RepliesLists extends StatelessWidget {
  const RepliesLists({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repliesModel = Provider.of<RepliesModel>(context);
    List<Replies> repliesList = repliesModel.items;
    if (repliesModel.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    } else if (repliesList.isEmpty) {
      return Center(
          child: SizedBox(
        height: 200,
        child: GestureDetector(
          onTap: () {
            repliesModel.loadComments();
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
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else {
      return ListView.separated(
        controller: repliesModel.scrollController,
        itemCount: repliesModel.hasMoreComments
            ? repliesList.length + 1
            : repliesList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          if (index == 0 && repliesModel.isLoadingMore) {
            return const SizedBox(
                width: 30, child: Center(child: CupertinoActivityIndicator()));
          } else if (index == 0 && repliesModel.hasMoreComments) {
            return SizedBox(
              height: 30,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      child: const Text('load more'),
                      onPressed: () {
                        Provider.of<RepliesModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int tmpIndex = index;
            if (repliesModel.hasMoreComments) tmpIndex = index - 1;
            return RepliesItem(
              isUser: repliesModel.isUser(repliesList[tmpIndex].email ?? ''),
              context: context,
              index: tmpIndex,
              object: repliesList[tmpIndex],
            );
          }
        },
      );
    }
  }
}
