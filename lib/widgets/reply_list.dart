import 'package:dhak_dhol/widgets/replyCardItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/model/replies.dart';
import '../provider/replies_model.dart';
import '../utils/app_const.dart';

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
                  'No Comments found \nclick to retry',
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