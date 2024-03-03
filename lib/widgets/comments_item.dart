import 'package:flutter/material.dart';
import '../data/model/comment.dart';
import '../data/model/comments_arguement.dart';
import '../provider/comments_model.dart';
import '../screens/comments/replies_screen.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import 'package:provider/provider.dart';

class CommentsItem extends StatefulWidget {
  final bool isUser;
  final Comments? object;
  final int index;
  final BuildContext context;

  const CommentsItem(
      {Key? key,
      required this.isUser,
      required this.index,
      required this.object,
      required this.context})
      : assert(object != null),
        super(key: key);

  @override
  State<CommentsItem> createState() => _CommentsItemState();
}

class _CommentsItemState extends State<CommentsItem> {
  late int repliesCount;

  @override
  void initState() {
    repliesCount = widget.object?.replies ?? 0;
    super.initState();
  }

  reportPost(int id, int index, String reason) {
    Provider.of<CommentsModel>(widget.context, listen: false)
        .reportComment(id, index, reason);
  }

  replyCommentScreen() async {
    var count = await Navigator.pushNamed(
      context,
      RepliesScreen.routeName,
      arguments: CommentsArgument(
          item: widget.object, commentCount: widget.object?.replies),
    );
    setState(() {
      repliesCount = count as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: IntrinsicHeight(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Center(
                child: Text(
                  widget.object?.name?.substring(0, 1) ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(width: 10.0),
            Flexible(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(widget.object?.name ?? '',
                          style: TextStyles.caption(context).copyWith(color: Colors.white)
                          //.copyWith(color: MyColors.grey_60),
                          ),
                      const Spacer(),
                      Text(TimUtil.timeAgoSinceDate(widget.object?.date ?? 0),
                          style: TextStyles.caption(context)
                          //.copyWith(color: MyColors.grey_60),
                          ),
                    ],
                  ),
                  Container(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                        widget.object?.content ?? '',
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        style: TextStyles.subhead(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(height: 8),
                  Row(
                    children: <Widget>[
                      // InkWell(
                      //   onTap: () {
                      //     replyCommentScreen();
                      //   },
                      //   child: Text(
                      //     'Reply',
                      //     style: TextStyles.caption(context).copyWith(
                      //         fontWeight: FontWeight.bold, fontSize: 13),
                      //   ),
                      // ),
                      Container(width: 10),
                      Visibility(
                        visible: repliesCount != 0,
                        child: InkWell(
                          onTap: () {
                            replyCommentScreen();
                          },
                          child: Text(
                            repliesCount.toString(),
                            style: TextStyles.caption(context).copyWith(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      Container(width: 2),
                      Visibility(
                        visible: repliesCount != 0,
                        child: InkWell(
                          onTap: () {
                            replyCommentScreen();
                          },
                          child: Text(
                            'Replies',
                            style: TextStyles.caption(context).copyWith(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: widget.isUser ? false : true,
                            child: InkWell(
                              child: Icon(Icons.report,
                                  color: Colors.pink[300], size: 20.0),
                              onTap: () async {
                                await showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return ReportCommentDialog(
                                        id: widget.object?.id,
                                        index: widget.index,
                                        function: reportPost,
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: widget.isUser ? true : false,
                            child: InkWell(
                              child: const Icon(Icons.edit,
                                  color: Colors.lightBlue, size: 20.0),
                              onTap: () {
                                Provider.of<CommentsModel>(context,
                                        listen: false).showEditCommentAlert( widget.object?.id ?? 0, widget.index);
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: widget.isUser ? true : false,
                            child: InkWell(
                              child: const Icon(Icons.delete_forever,
                                  color: Colors.redAccent, size: 20.0),
                              onTap: () {
                                Provider.of<CommentsModel>(context,
                                        listen: false).showDeleteCommentAlert(widget.object?.id ?? 0, widget.index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCommentDialog extends StatefulWidget {
  final int? id, index;
  final Function function;

  const ReportCommentDialog({Key? key, this.id, this.index, required this.function}): super(key: key);

  @override
  State<ReportCommentDialog> createState() => _ReportCommentDialogState();
}

class _ReportCommentDialogState extends State<ReportCommentDialog> {
  List<String> reportOptions = [
    'Unwanted commercial content or spam',
    'Pornography or sexual explicit material',
    'Hate speech or graphic violence',
    'Harassment or bullying',
    'Disturbing Content',
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Report Options',
        style: TextStyles.subhead(context),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
          onPressed: () {
            Navigator.of(context).pop();
            widget.function(widget.id, widget.index, reportOptions[_selected]);
          },
          child: const Text('ok'),
        ),
      ],
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reportOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                          title: Text(reportOptions[index]),
                          value: index,
                          groupValue: _selected,
                          onChanged: (value) {
                            setState(() {
                              _selected = index;
                            });
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
