import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhak_dhol/data/model/firebase_model/friend.dart';
import 'package:dhak_dhol/data/model/firebase_model/message.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/firebase_model/message.dart';
import '../model/firebase_model/message.dart';

QuerySnapshot? opinionSnapshot;

class FirebaseService {
  ///create new user
  void createAndUpdateUserInfo(map, uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).set(map);
  }

  Future<UserModel?> getUserData(String uid) async {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (data.data() != null) {
      return UserModel.fromJson(data.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserToken({String? uid, String? token}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'token': token});
  }

  Future<void> updateUserData(
      {required String uid, required String key, required String value}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'$key': value});
  }

  Future<void> updateStatusData({required String uid}) async {
    Map<String, dynamic> map = {
      'status': true,
      'timestamp': Timestamp.now().seconds,
    };

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(map);
  }

  Future<void> updateUnseenCount(
      {required String uid, required String cid}) async {
    Map<String, dynamic> map = {
      'from_unseen_count': 0,
      'to_unseen_count': 0,
    };

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(cid)
        .update(map);
  }

  ///create chat room for every person whom we want to chat
  createChatRoom(fromId, toId, chatMap) {
    FirebaseFirestore.instance
        .collection('users')
        .doc('$fromId')
        .collection('$toId')
        .add(chatMap)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  ///create opinion room for misic
  Future<DocumentReference> createOpinionRoom(
      {required int opinionId, required Map<String, dynamic> map}) {
    return FirebaseFirestore.instance
        .collection('baddest_songs_opinion')
        .doc('$opinionId')
        .collection('opinion')
        .add(map);
  }

  ///update opinions with opinion doc id
  Future updateOpinionsDocId({required int opinionId, required String docId}) {
    return FirebaseFirestore.instance
        .collection('baddest_songs_opinion')
        .doc('$opinionId')
        .collection('opinion')
        .doc(docId)
        .update({"doc_id": docId}).catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  ///do opinion like
  doOpinionLike(
      {required int opinionId,
      required Map<String, dynamic> map,
      required String uid}) {
    FirebaseFirestore.instance
        .collection('baddest_songs_opinion')
        .doc('$opinionId')
        .collection('opinion')
        .doc(uid)
        .update(map)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  ///create friend list
  createFriend(currentUser, chatUser, message,
      {int fromCount = 0, int toCount = 0}) {
    Map<String, dynamic> friendMap = {
      'uid': '$chatUser',
      'message': message,
      'from_unseen_count': fromCount,
      'to_unseen_count': toCount,
      'timestamp': '${Timestamp.now().seconds}',
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc('$currentUser')
        .collection('friends')
        .doc('$chatUser')
        .set(friendMap)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  ///get all opinion message
  Stream<List<Message>> getOpinionRoomMessage({required int opinionId}) {
    return FirebaseFirestore.instance
        .collection('baddest_songs_opinion')
        .doc('$opinionId')
        .collection('opinion')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map(getAllOpinionFromFirebase);
  }

  ///get all query message from firebase
  Stream<List<Message>> getChatRoomMessage(fromId, toId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(fromId)
        .collection('$toId')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map(getAllMessageFromFirebase);
  }

  ///get all opinion message
  Stream<List<Message>> getMoreOpinionRoomMessage({required int opinionId}) {
    return FirebaseFirestore.instance
        .collection('baddest_songs_opinion')
        .doc('$opinionId')
        .collection('opinion')
        .orderBy('timestamp', descending: true)
        .startAfter([opinionSnapshot])
        .limit(20)
        .snapshots()
        .map(getAllOpinionFromFirebase);
  }

  ///get opinions
  List<Message> getAllOpinionFromFirebase(QuerySnapshot snapshot) {
    opinionSnapshot = snapshot;

    return snapshot.docs.map((item) {
      try {
        return Message(
            from: item['from'] ?? '',
            message: item['message'] ?? '',
            timeStamp: item['timestamp'] ?? '',
            docId: item['doc_id'] ?? '',
            type: item['type'],
            status: item['status'],
            profileImage: item['profile_image'] ?? null);
      } catch (e) {
        rethrow;
      } finally {
        return Message(
            from: item['from'] ?? '',
            message: item['message'] ?? '',
            timeStamp: item['timestamp'] ?? '',
            type: item['type'],
            status: item['status'],
            docId: item['doc_id'] ?? '',
            profileImage: item['profile_image'],
            likes: item['likes'] != null
                ? List<String>.from(item['likes']!.map((x) => x)).toList()
                : []);
      }
    }).toList();
  }

  ///get list of message
  List<Message> getAllMessageFromFirebase(QuerySnapshot snapshot) {
    opinionSnapshot = snapshot;

    return snapshot.docs.map((item) {
      try {
        return Message.chat(
          from: item['from'] ?? '',
          message: item['message'] ?? '',
          timeStamp: item['timestamp'] ?? '',
          fromCount:
              item['from_unseen_count'] != null ? item['from_unseen_count'] : 0,
          toCount:
              item['to_unseen_count'] != null ? item['to_unseen_count'] : 0,
          type: item['type'],
          status: item['status'],
        );
      } catch (e) {
        rethrow;
      } finally {
        return Message.chat(
          from: item['from'] ?? '',
          message: item['message'] ?? '',
          timeStamp: item['timestamp'] ?? '',
          type: item['type'],
          status: item['status'],
        );
      }
    }).toList();
  }

  //return friend object from query
  List<UserModel> getChatFriendFromFireStore(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  ///user online/offline status
  Stream<DocumentSnapshot> getStatusAsStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('$uid')
        .snapshots()
        .map(getStatusFromFireStore);
  }

  ///return user status and timeStamp
  DocumentSnapshot getStatusFromFireStore(DocumentSnapshot doc) {
    return doc;
  }

  ///get all query friend from firebase
  Stream<List<LastChat>> getFriend(currentUser) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('friends')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(getAllFriendFromFirebase);
  }

  ///get list of friend
  List<LastChat> getAllFriendFromFirebase(QuerySnapshot snapshot) {
    return snapshot.docs.map((item) {
      try {
        return LastChat.fromJson(item.data() as Map<dynamic, dynamic>);
      } catch (e) {
        rethrow;
      } finally {
        return LastChat.fromRoom(item.data() as Map<dynamic, dynamic>);
      }
    }).toList();
  }

  Future<http.Response> sendNotification(
      {token, title, body, map, status = 'call'}) async {
    final path = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final response = await http.post(
      path,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAarUR18g:APA91bEiuBi1bwHhzvLdp1Zbx2Tqk_BDT3wd64JJm72MOyOcvpwM0bToZBnsPtvHeILo71CCvvnX1iJsScp6J5AgH3bjmCAy6aXiJfbl5ToFyQOkfA-XM-0LNVg8RjZvOZgz3_3gLaOj',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'type': '$status',
            'user_data': map,
          },
          'to': '$token',
        },
      ),
    );
    print('notification ${response.body}');
    return response;
  }

  Future<http.Response> sendNotificationWithTopic(
      {topic, title, body, map, status = 'call'}) async {
    final path = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final response = await http.post(
      path,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAarUR18g:APA91bEiuBi1bwHhzvLdp1Zbx2Tqk_BDT3wd64JJm72MOyOcvpwM0bToZBnsPtvHeILo71CCvvnX1iJsScp6J5AgH3bjmCAy6aXiJfbl5ToFyQOkfA-XM-0LNVg8RjZvOZgz3_3gLaOj',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'type': '$status',
            'user_data': map,
          },
          'to': '/topics/$topic',
        },
      ),
    );
    print('notification ${response.body}');
    return response;
  }
}
