import 'package:dhak_dhol/screens/chat_screen/search_list.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/firebase_model/chat_friend.dart';
import '../../provider/profile_provider.dart';

class ChatSearchScreen extends StatefulWidget {

  final ChatProfile? myProfile;

  const ChatSearchScreen({super.key, this.myProfile});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  bool isSearching = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.signInPageBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.signInPageBackgroundColor,
        title: const Text(
          'Search',
          style: TextStyle(color: Color(0xffeeeeee)),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(25.0)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.blue, fontSize: 16.0),
                        decoration: const InputDecoration(
                          hintText: 'Search ',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => setState(() => searchQuery = val),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      child:  CircleAvatar(
                          radius: 20.0,
                          backgroundColor: AppColor.titleColor,
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24,
                          )),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SearchFriend(
                  query: searchQuery,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
