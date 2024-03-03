import 'package:dhak_dhol/utils/utility.dart';
import 'package:flutter/material.dart';
import '../data/model/replies.dart';
import '../provider/replies_model.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import 'package:provider/provider.dart';

class RepliesItem extends StatelessWidget {
  final bool isUser;
  final Replies object;
  final int index;
  final BuildContext context;

  const RepliesItem(
      {Key? key,
        required this.isUser,
        required this.index,
        required this.object,
        required this.context})
      : super(key: key);

  reportPost(int id, int index, String reason) {
    Provider.of<RepliesModel>(context, listen: false)
        .reportComment(id, index, reason);
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
                  '${object.name?.substring(0, 1)}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(width: 10),
            Flexible(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(object.name ?? '', style: TextStyles.caption(context)
                        //.copyWith(color: MyColors.grey_60),
                      ),
                      const Spacer(),
                      Text(TimUtil.timeAgoSinceDate(object.date ?? 0),
                          style: TextStyles.caption(context)
                        //.copyWith(color: MyColors.grey_60),
                      ),
                    ],
                  ),
                  Container(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(Utility.getBase64DecodedString(object.content ?? ''),
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        style: TextStyles.subhead(context).copyWith(
                          //color: MyColors.grey_80,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(height: 8),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: isUser ? false : true,
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
                                        id: object.id,
                                        index: index,
                                        function: reportPost,
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: isUser ? true : false,
                            child: InkWell(
                              child: const Icon(Icons.edit,
                                  color: Colors.lightBlue, size: 20.0),
                              onTap: () {
                                Provider.of<RepliesModel>(context,
                                    listen: false)
                                    .showEditCommentAlert(object.id ?? 0, index);
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: isUser ? true : false,
                            child: InkWell(
                              child: const Icon(Icons.delete_forever,
                                  color: Colors.redAccent, size: 20.0),
                              onTap: () {
                                Provider.of<RepliesModel>(context,
                                    listen: false)
                                    .showDeleteCommentAlert(object.id ?? 0, index);
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
  final Function? function;
  const ReportCommentDialog({Key? key, this.id, this.index, this.function})
      : super(key: key);

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
            widget.function!(widget.id, widget.index, reportOptions[_selected]);
          },
          child: const Text('Ok'),
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
