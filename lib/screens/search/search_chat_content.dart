import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/shared_pref.dart';
import '../chat_screen/conversation_screen.dart';

class SearchChatContent extends StatefulWidget {

  final List<User> users;

  const SearchChatContent({super.key, required this.users});

  @override
  State<SearchChatContent> createState() => _SearchChatContentState();
}

class _SearchChatContentState extends State<SearchChatContent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future:  SharedPref.getValue(SharedPref.keyId),
      builder: (context,snapshot){
        return widget.users.isNotEmpty ?
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.users.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(6.0)),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFFFB7159),
                        Color(0xFF7001B6),
                      ],
                      begin: FractionalOffset(3.0, 2.0),
                      end: FractionalOffset(0.0, 4.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: ListTile(
                  onTap: () {

                    UserModel friendProfile = UserModel(user: widget.users[index]);

                    context
                        .read<ProfileProvider>()
                        .navigationToProfile(context, friendProfile);
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColor.titleColor,
                    child: const Icon(Icons.person,
                        color: Colors.white),
                  ),
                  title: Text(
                    '${widget.users[index].name}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  trailing: InkWell(
                    onTap: snapshot.data != null ? () {

                      UserModel friendProfile = UserModel(user: widget.users[index]);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChatConversation(friend: friendProfile,)));
                    } : null,
                    child: CircleAvatar(
                      backgroundColor: AppColor.titleColor,
                      child: const Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ) : Padding(
          padding:
          EdgeInsets.only(top: ScreenUtil.defaultSize.height / 3),
          child: const Text(
            "Chat Not Found",
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
