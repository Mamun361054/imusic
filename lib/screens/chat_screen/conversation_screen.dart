import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhak_dhol/data/firebase_service/common/chat_line.dart';
import 'package:dhak_dhol/data/firebase_service/common/common_method.dart';
import 'package:dhak_dhol/data/firebase_service/firebase_service.dart';
import 'package:dhak_dhol/data/model/firebase_model/friend.dart';
import 'package:dhak_dhol/data/model/firebase_model/message.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/screens/chat_screen/initial_conversation_widget.dart';
import 'package:dhak_dhol/screens/chat_screen/online_offline_view.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/shared_pref.dart';

class ChatConversation extends StatefulWidget {
  final UserModel? friend;
  final LastChat? lastChat;

  const ChatConversation({super.key, this.friend,this.lastChat});

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  //scroll controller
  final ScrollController listScrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  String message = '';
  XFile? imageFile;
  File? file;
  String? userId;
  int fromCount = 1;
  int toCount = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SharedPref.getValue(SharedPref.keyId).then((value) {
      setState(() {
        userId = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService database = FirebaseService();
    final provider = context.watch<ProfileProvider>();
    final chatUser = widget.friend?.user?.id;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.signInPageBackgroundColor,
          title: Row(
            children: [
              Text('${widget.friend?.user?.name}'),
              SizedBox(width: 4.0,),
              OnlineOfflineView(uid: '${widget.friend?.user?.id}'),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (widget.friend != null) {
                    provider.navigationToProfile(context, widget.friend!);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: widget.friend?.user?.image == null ||
                            widget.friend?.user?.image == ''
                        ? Image.network(
                            'https://support.hubstaff.com/wp-content/uploads/2019/08/good-pic.png',
                            width: 45.0,
                            height: 45.0,
                            fit: BoxFit.cover,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                widget.friend?.user?.image.toString() ?? ""),
                          ),
                  ),
                ),
              ),
            ],
          ),
          actions: const <Widget>[],
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            child: StreamBuilder<List<Message>>(
              stream: database.getChatRoomMessage(userId, chatUser),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  database.updateUnseenCount(uid: '$userId', cid: '$chatUser');
                  ///By default chat screen view
                  ///where show all messages
                  return Scaffold(
                    backgroundColor: AppColor.signInPageBackgroundColor,
                    body: Column(
                      children: [
                        snapshot.data?.length == 0
                            ? Expanded(child: InitialConversationWidget(onBackPressed: () {
                                setState(() {
                                  Map<String, dynamic> map = {
                                    'type': 'message',
                                    'message': null,
                                    'status': 'not seen',
                                    'profile_image': null,
                                    'from': '$userId',
                                    'timestamp': '${Timestamp.now().seconds}'
                                  };

                                  debugPrint(_messageController.text);

                                  ///create chat room for current user
                                  database.createChatRoom(userId, chatUser, map);

                                  ///create chat room for chat user
                                  database.createChatRoom('$chatUser', userId, map);

                                  ///update chat friend list for current user
                                  database.createFriend(userId, '$chatUser', "Hello",toCount: toCount++);

                                  ///update chat friend list for chat user
                                  database.createFriend('$chatUser', userId, "Hello",fromCount: fromCount++);

                                  if (kDebugMode) {
                                    print('current uid $userId   chat uid : $chatUser');
                                  }
                                  listScrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

                                  database.sendNotification(
                                      token: widget.friend?.token,
                                      title: 'new message',
                                      body: "Hello",
                                      map: userId,
                                      status: 'message');
                                  _messageController.clear();
                                });
                              }))
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  controller: listScrollController,
                                  reverse: true,
                                  itemBuilder: (_, index) {

                                    Message message = snapshot.data?.elementAt(index) ?? Message();

                                    return message.message != null ? ChatLine(
                                      message: snapshot.data?.elementAt(index),
                                      currentUser: userId,
                                    ) : SizedBox.shrink();
                                  },
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
                                  imageFile = await ChatCommon.getImage();
                                  //print('image file : ${imageFile.path}');
                                  ///read the file asynchronously as the image can be very large which may cause blocking of main thread
                                  String? base64Image = base64Encode(
                                      await imageFile!.readAsBytes());

                                  Map<String, dynamic> map = {
                                    'type': 'image',
                                    'message': base64Image,
                                    'status': 'not seen',
                                    'from': '$userId',
                                    'timestamp':
                                    '${Timestamp.now().seconds}'
                                  };

                                  ///create chat room for current user
                                  database.createChatRoom(userId, chatUser, map);

                                  ///create chat room for chat user
                                  database.createChatRoom(chatUser, userId, map);

                                  ///update friend list for current user
                                  database.createFriend(userId, chatUser,_messageController.text,toCount: toCount++);

                                  ///update friend list for chat user
                                  database.createFriend(chatUser, userId,_messageController.text,fromCount:fromCount++);

                                  if (kDebugMode) {
                                    print('current uid $userId   chat uid : $chatUser');
                                  }
                                  listScrollController.animateTo(0.0,
                                      duration: const Duration(
                                          milliseconds: 300),
                                      curve: Curves.easeOut);
                                },
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
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
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                      decoration: const InputDecoration(
                                        hintText: 'Message...',
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Map<String, dynamic> map = {
                                          'type': 'message',
                                          'message': _messageController.text,
                                          'status': 'not seen',
                                          'from': '$userId',
                                          'timestamp': '${Timestamp.now().seconds}'
                                        };

                                        debugPrint(_messageController.text);

                                        ///create chat room for current user
                                        database.createChatRoom(
                                            userId, chatUser, map);

                                        ///create chat room for chat user
                                        database.createChatRoom('$chatUser', userId, map);

                                        ///update chat friend list for current user
                                        database.createFriend(userId, '$chatUser', _messageController.text,toCount: toCount++);

                                        ///update chat friend list for chat user
                                        database.createFriend('$chatUser', userId, _messageController.text,fromCount: fromCount++);
                                        if (kDebugMode) {
                                          print('current uid $userId   chat uid : $chatUser');
                                        }
                                        listScrollController.animateTo(0.0,
                                            duration:
                                            const Duration(milliseconds: 300),
                                            curve: Curves.easeOut);

                                        database.sendNotification(
                                            token: widget.friend?.token,
                                            title: 'new message',
                                            body: _messageController.text,
                                            map: userId,
                                            status: 'message');
                                        _messageController.clear();
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
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0,)
                      ],
                    ),
                  );
                } else {
                  return ColoredBox(
                    color: AppColor.signInPageBackgroundColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: listScrollController,
                            children: [
                              SizedBox(
                                height: ScreenUtil.defaultSize.height / 2,
                              ),
                              const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
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
                                  imageFile = await ChatCommon.getImage();
                                  //print('image file : ${imageFile.path}');
                                  ///read the file asynchronously as the image can be very large which may cause blocking of main thread
                                  String? base64Image = base64Encode(
                                      await imageFile!.readAsBytes());

                                  Map<String, dynamic> map = {
                                    'type': 'image',
                                    'message': base64Image,
                                    'status': 'not seen',
                                    'from': '$userId',
                                    'timestamp':
                                    '${Timestamp.now().seconds}'
                                  };

                                  ///create chat room for current user
                                  database.createChatRoom(
                                      userId, chatUser, map);

                                  ///create chat room for chat user
                                  database.createChatRoom(
                                      chatUser, userId, map);

                                  ///update friend list for current user
                                  database.createFriend(userId, chatUser,_messageController.text,toCount: toCount++);

                                  ///update friend list for chat user
                                  database.createFriend(chatUser, userId,_messageController.text,fromCount: fromCount++);

                                  if (kDebugMode) {
                                    print('current uid $userId   chat uid : $chatUser');
                                  }
                                  listScrollController.animateTo(0.0,
                                      duration: const Duration(
                                          milliseconds: 300),
                                      curve: Curves.easeOut);
                                },
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
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
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                      decoration: const InputDecoration(
                                        hintText: 'Message...',
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Map<String, dynamic> map = {
                                          'type': 'message',
                                          'message': _messageController.text,
                                          'status': 'not seen',
                                          'from': '$userId',
                                          'timestamp': '${Timestamp.now().seconds}'
                                        };

                                        debugPrint(_messageController.text);

                                        ///create chat room for current user
                                        database.createChatRoom(userId, chatUser, map);

                                        ///create chat room for chat user
                                        database.createChatRoom('$chatUser', userId, map);

                                        ///update chat friend list for current user
                                        database.createFriend(userId, '$chatUser', _messageController.text,toCount: toCount++);

                                        ///update chat friend list for chat user
                                        database.createFriend('$chatUser', userId, _messageController.text,fromCount: fromCount++);
                                        if (kDebugMode) {
                                          print('current uid $userId   chat uid : $chatUser');
                                        }
                                        listScrollController.animateTo(0.0,
                                            duration:
                                            const Duration(milliseconds: 300),
                                            curve: Curves.easeOut);

                                        database.sendNotification(
                                            token: widget.friend?.token,
                                            title: 'new message',
                                            body: _messageController.text,
                                            map: userId,
                                            status: 'message');
                                        _messageController.clear();
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
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0,)
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }
}
