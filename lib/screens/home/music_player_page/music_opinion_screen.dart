import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhak_dhol/data/firebase_service/common/common_method.dart';
import 'package:dhak_dhol/data/firebase_service/firebase_service.dart';
import 'package:dhak_dhol/data/model/firebase_model/message.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/model/opinion.dart';
import 'package:dhak_dhol/screens/auth/sign_in/sign_in_screen.dart';
import 'package:dhak_dhol/screens/profile/profile_new/profile_new.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/shared_pref.dart';
import '../../image_preview_screen.dart';
import 'package:badges/badges.dart' as badges;

class MusicOpinionConversation extends StatefulWidget {
  final Opinion? opinion;
  final Media? media;

  const MusicOpinionConversation({super.key, this.opinion, this.media});

  @override
  State<MusicOpinionConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<MusicOpinionConversation> {
  //scroll controller
  final ScrollController listScrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  ScrollController _controller = ScrollController();
  final maxExtent = 230.0;
  double currentExtent = 0.0;

  String message = '';
  XFile? imageFile;
  String? userId;
  List<Message> messages = [];
  String? profileImage;
  String? topic;
  String? title;
  String? createdBy;

  @override
  void dispose() {
    super.dispose();
  }

  topicName() {
    if (userId != null) {
      title = widget.opinion!.title!.length > 3
          ? widget.opinion!.title?.substring(0, 3)
          : widget.opinion!.title;

      createdBy = widget.opinion!.createdBy!.length > 3
          ? widget.opinion!.createdBy?.substring(0, 3)
          : widget.opinion!.createdBy;

      topic = "${widget.opinion?.id}$title$createdBy";
      print('topic name: $topic');
      FirebaseMessaging.instance.subscribeToTopic("$topic");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      setState(() {
        currentExtent = maxExtent - _controller.offset;
        if (currentExtent < 0) currentExtent = 0.0;
        if (currentExtent > maxExtent) currentExtent = maxExtent;

        print(currentExtent);
        print("font size: ${currentExtent / 12}");
      });
    });

    SharedPref.getValue(SharedPref.keyId).then((value) {
      setState(() {
        userId = value;
      });
    });
    SharedPref.getValue(SharedPref.keyProfileImage).then((value) {
      setState(() {
        profileImage = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService database = FirebaseService();
    topicName();
    var snackBar = SnackBar(
      content: Text('You are not Signed In!'),
      action: SnackBarAction(
          label: 'Sign In',
          textColor: AppColor.buttonColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ));
          }),
    );

    return Scaffold(
        backgroundColor: AppColor.signInPageBackgroundColor,
        body: StreamBuilder<List<Message>>(
          stream: widget.opinion != null
              ? database.getOpinionRoomMessage(opinionId: widget.opinion!.id!)
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              messages = snapshot.data ?? [];
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      controller: _controller,
                      slivers: [
                        SliverAppBar(
                          backgroundColor: AppColor.signInPageBackgroundColor,
                          pinned: true,
                          collapsedHeight: 80,
                          expandedHeight: 230.0,
                          flexibleSpace: FlexibleSpaceBar.createSettings(
                            currentExtent: currentExtent,
                            minExtent: 0,
                            maxExtent: maxExtent,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: "${widget.media?.coverPhoto}",
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress)),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  left: -16.0,
                                  right: -16.0,
                                  bottom: -30.0,
                                  child: Container(
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColor
                                                .signInPageBackgroundColor,
                                            blurRadius: 18.0,
                                            spreadRadius: 8.0,
                                            offset: const Offset(0.0, 0.0))
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Opinion name: ${widget.opinion?.title ?? ''}',
                                            style: TextStyle(
                                                // fontSize: currentExtent <= 149 ? 20 : 16,
                                                fontSize: currentExtent >
                                                        192.27678571428498
                                                    ? currentExtent / 12
                                                    : 16.023065476190414,
                                                color: AppColor.secondary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            widget.opinion?.description ?? '',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: AppColor.grey,
                                              fontSize: currentExtent >
                                                      192.27678571428498
                                                  ? currentExtent / 12
                                                  : 16.023065476190414,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            final reversedIndex = messages.length - index - 1;
                            final message = messages.elementAt(reversedIndex);
                            List<String> likeCount = [];
                            likeCount.addAll(message.likes ?? []);
                            final isLike = likeCount
                                .where((element) => element == userId)
                                .toList();
                            print(likeCount.length.toString());
                            return Column(
                              children: [
                                SizedBox(
                                  height: 12.0,
                                ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: userId == message.from
                                              ? 80.0
                                              : 8.0,
                                          right: 16.0,
                                          bottom: 2.0),
                                      leading: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return ProfileNew(
                                              id: int.parse(message.from),
                                            );
                                          }));
                                        },
                                        child: message.profileImage != ''
                                            ? SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      message.profileImage!),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/yellow_profile.png'),
                                              ),
                                      ),
                                      horizontalTitleGap:
                                          userId == message.from ? 0.0 : -4.0,
                                      dense: true,
                                      title: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                              color: userId == message.from
                                                  ? AppColor.backgroundColor
                                                  : AppColor.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      userId == message.from
                                                          ? 20.0
                                                          : 12.0)),
                                          child: message.type == 'image'
                                              ? Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    // child: CircleAvatar(
                                                    //   backgroundColor:
                                                    //   Colors.transparent,
                                                    //   backgroundImage: NetworkImage(message?.message ?? ""),
                                                    // ),
                                                    child: InkWell(
                                                      onTap: () => Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                        return ImagePreviewScreen(
                                                          message:
                                                              message.message,
                                                        );
                                                      })),
                                                      onLongPress: () {
                                                        // downloadImage(widget.message?.message);
                                                      },
                                                      child: Hero(
                                                        tag: 'imagePreview',
                                                        child: Image.memory(
                                                          base64Decode(
                                                              message.message),
                                                          scale: 5,
                                                          height: 200.0,
                                                          width: 200.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  '${message.message}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0),
                                                )),
                                    ),
                                    Positioned(
                                      top: -4,
                                      right: 20.0,
                                      child: buildLikeDislike(isLike, likeCount,
                                          message, database, context),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }, childCount: messages.length),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          icon: Image.asset(
                            'assets/images/attachment.png',
                          ),
                          onPressed: () async {
                            if (userId != null) {
                              imageFile = await ChatCommon.getImage();

                              ///read the file asynchronously as the image can be very large which may cause blocking of main thread
                              String? base64Image =
                                  base64Encode(await imageFile!.readAsBytes());

                              Map<String, dynamic> map = {
                                'type': 'image',
                                'message': base64Image,
                                'status': 'not seen',
                                'from': '$userId',
                                'profile_image': '$profileImage',
                                'timestamp': '${Timestamp.now().seconds}',
                                'likes': [],
                                'doc_id': null
                              };

                              ///create opinion room for current music
                              final docId = await database.createOpinionRoom(
                                  opinionId: widget.opinion!.id!, map: map);

                              /// update list with doc id
                              database.updateOpinionsDocId(
                                  opinionId: widget.opinion!.id!,
                                  docId: docId.id);

                              listScrollController.animateTo(0.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);

                              /// otherwise user get notification by his own messages
                              FirebaseMessaging.instance
                                  .unsubscribeFromTopic("$topic");

                              database.sendNotificationWithTopic(
                                  topic: topic,
                                  title: 'New opinion',
                                  body: 'Attachment send',
                                  map: userId,
                                  status: 'message');

                              _messageController.clear();

                              FirebaseMessaging.instance
                                  .subscribeToTopic("$topic");
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          color: Colors.white,
                        ),
                      ),

                      /// send message button widget
                      buildSendMessageButton(database, context, snackBar),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  )
                ],
              );
            } else
              return SizedBox();
          },
        ));
  }

  GestureDetector buildLikeDislike(List<String> isLike, List<String> likeCount,
      Message message, FirebaseService database, BuildContext context) {
    return GestureDetector(
      onTap: userId != null
          ? () {
              if (isLike.isEmpty) {
                likeCount.add(userId.toString());
                Map<String, dynamic> map = {
                  'likes': likeCount,
                };
                database.doOpinionLike(
                  opinionId: widget.opinion!.id!,
                  map: map,
                  uid: message.docId!,
                );
              } else {
                likeCount.removeWhere((element) => element == userId);
                Map<String, dynamic> map = {
                  'likes': likeCount,
                };
                database.doOpinionLike(
                  opinionId: widget.opinion!.id!,
                  map: map,
                  uid: message.docId!,
                );
                print('you already liked');
              }
            }
          : () {
              /// if user not logged in showed the snackBar for sign in
              var snackBar = SnackBar(
                content: Text('You are not Signed In!'),
                action: SnackBarAction(
                    label: 'Sign In',
                    textColor: AppColor.buttonColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ));
                    }),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -14, end: -10),
        badgeContent: Text(
          likeCount.length.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(
            Icons.thumb_up,
            size: 14,
            color: isLike.isNotEmpty ? AppColor.secondary : Colors.black,
          ),
        ),
      ),
    );
  }

  Expanded buildSendMessageButton(
      FirebaseService database, BuildContext context, snackBar) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(36.0))),
            child: TextFormField(
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: const InputDecoration(
                hintText: 'Message...',
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: userId != null
                  ? () async {
                      Map<String, dynamic> map = {
                        'type': 'message',
                        'message': _messageController.text,
                        'status': 'not seen',
                        'from': '$userId',
                        'profile_image': '$profileImage',
                        'timestamp': '${Timestamp.now().seconds}',
                        'likes': [],
                        'doc_id': null
                      };

                      debugPrint(_messageController.text);

                      ///create opinion room for current music
                      final docId = await database.createOpinionRoom(
                          opinionId: widget.opinion!.id!, map: map);

                      database.updateOpinionsDocId(
                          opinionId: widget.opinion!.id!, docId: docId.id);

                      listScrollController.animateTo(0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);

                      /// otherwise user get notification by his own messages
                      FirebaseMessaging.instance.unsubscribeFromTopic("$topic");

                      database.sendNotificationWithTopic(
                          topic: topic,
                          title: 'New opinion',
                          body: _messageController.text,
                          map: userId,
                          status: 'message');

                      _messageController.clear();

                      FirebaseMessaging.instance.subscribeToTopic("$topic");
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  'assets/images/conversation.png',
                  height: 40.0,
                  width: 40.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
