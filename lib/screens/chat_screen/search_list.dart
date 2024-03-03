import 'package:dhak_dhol/data/model/firebase_model/Search_user_response.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/screens/chat_screen/chat_repository.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../utils/shared_pref.dart';
import 'conversation_screen.dart';

class SearchFriend extends StatefulWidget {
  final String? query;

  const SearchFriend({super.key, this.query});

  @override
  State<SearchFriend> createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPref.getValue(SharedPref.keyId),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.hasData) {
          return FutureBuilder<List<ChatProfileSearch>>(
              future: ChatRepository().chatUserSearchApi(context, widget.query),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<ChatProfileSearch>? profiles = snapshot.data;
                  if (profiles!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        if (userIdSnapshot.data !=
                            profiles[index].id.toString()) {
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
                                  // UserModel friendProfile = UserModel();
                                  UserModel friendProfile = UserModel(
                                      user: User(
                                    id: profiles[index].id,
                                    name: '${profiles[index].name}',
                                    about: '${profiles[index].about}',
                                    email: '${profiles[index].email}',
                                    image: profiles[index].thumbnail,
                                    favArtists: [],
                                    subscribed: profiles[index].subscribed,
                                  ));

                                  context
                                      .read<ProfileProvider>()
                                      .navigationToProfile(
                                          context, friendProfile);
                                },
                                leading: profiles[index].thumbnail != null
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                profiles[index].thumbnail!)))
                                    : CircleAvatar(
                                        backgroundColor: AppColor.titleColor,
                                        child: const Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                title: Text(
                                  '${profiles[index].name}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    // ignore: unused_local_variable
                                    ChatProfileSearch? searchProfile =
                                        profiles[index];

                                    // UserModel friendProfile = UserModel();

                                    UserModel friendProfile = UserModel(
                                        user: User(
                                      id: profiles[index].id,
                                      name: '${profiles[index].name}',
                                      about: '${profiles[index].about}',
                                      email: '${profiles[index].email}',
                                      image: profiles[index].thumbnail,
                                      favArtists: [],
                                      subscribed: profiles[index].subscribed,
                                    ));

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatConversation(
                                                  friend: friendProfile,
                                                )));
                                  },
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
                        }
                        return SizedBox.shrink();
                      },
                    );
                  }
                  return Padding(
                    padding:
                        EdgeInsets.only(top: ScreenUtil.defaultSize.height / 3),
                    child: const Text(
                      "User Not Found",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Color(0xff330066)),
                  ),
                );
              });
        }
        return Padding(
          padding: EdgeInsets.only(top: ScreenUtil.defaultSize.height / 3),
          child: const Text(
            "Loading",
            style: TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
