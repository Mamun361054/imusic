import 'package:dhak_dhol/data/firebase_service/firebase_service.dart';
import 'package:dhak_dhol/data/model/firebase_model/friend.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/screens/profile/profile_new/profile_new.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../utils/shared_pref.dart';
import '../auth/sign_in/sign_in_screen.dart';
import 'chat_search.dart';
import 'conversation_screen.dart';
import 'online_offline_view.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //database instance
  final FirebaseService _database = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.signInPageBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.signInPageBackgroundColor,
          title: const Text(
            'iMusic Rooms',
            style: TextStyle(color: Color(0xffeeeeee)),
          ),
        ),
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(left: 32.0),
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(25.0)),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChatSearchScreen()));
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.blue, fontSize: 16.0),
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Search for more users',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                CircleAvatar(
                    radius: 20.0,
                    backgroundColor: AppColor.titleColor,
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<String?>(
            future: SharedPref.getValue(SharedPref.keyId),
            builder: (context, userIdSnapshot) {
              if (userIdSnapshot.hasData) {
                return StreamBuilder<List<LastChat>>(
                  stream: _database.getFriend(userIdSnapshot.data),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Empty list',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          if (userIdSnapshot.data !=
                              snapshot.data?.elementAt(index).uid) {
                            final toLastChat = snapshot.data?.elementAt(index);

                            String? chatUser =
                                snapshot.data?.elementAt(index).uid;

                            // ignore: unused_local_variable
                            String? lastMessage =
                                snapshot.data?.elementAt(index).message;

                            FirebaseService().getUserData(chatUser ?? '');

                            ///after retrieve chat uid
                            ///then we can access user profile
                            return FutureBuilder<UserModel?>(
                              future: _database.getUserData(chatUser!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final profile = snapshot.data;

                                  debugPrint('fcm token ${profile?.token}');

                                  return profile?.user != null
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatConversation(
                                                          friend: profile,
                                                          lastChat: toLastChat,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0,
                                                right: 10.0,
                                                left: 10.0),
                                            child: Card(
                                              elevation: 4,
                                              color: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF7001B6),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0)),
                                                    child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 70.0,
                                                              right: 16.0),
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${profile?.user?.name ?? 'user'}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          Divider(
                                                            color: AppColor
                                                                .secondary,
                                                          ),
                                                          Text(
                                                            'Liked Artists',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xffEEEEEE)),
                                                          ),
                                                          if (profile!
                                                              .user!
                                                              .favArtists!
                                                              .isNotEmpty)
                                                            Wrap(
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: profile
                                                                  .user!
                                                                  .favArtists!
                                                                  .map(
                                                                      (item) =>
                                                                          Text(
                                                                            '${item.name}  ',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold),
                                                                          ))
                                                                  .toList(),
                                                            )
                                                          else
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      trailing: Stack(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/conversation.png',
                                                            height: 40.0,
                                                            width: 40.0,
                                                          ),
                                                          Visibility(
                                                            visible: toLastChat
                                                                    ?.fromUnseenCount !=
                                                                0,
                                                            child: Positioned(
                                                              top: 0.0,
                                                              right: 0.0,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child: Text(
                                                                    '${toLastChat?.fromUnseenCount}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 6.0,
                                                    bottom: 6.0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfileNew(
                                                                          id: profile
                                                                              .user
                                                                              ?.id,
                                                                        )));
                                                      },
                                                      child: SizedBox(
                                                          width: 60.0,
                                                          height: 60.0,
                                                          child: Image.asset(
                                                            'assets/images/yellow_profile.png',
                                                            fit: BoxFit.fill,
                                                            height: 60.0,
                                                          )),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      left: 45.0,
                                                      top: 8.0,
                                                      child: OnlineOfflineView(
                                                        uid:
                                                            '${profile.user?.id}',
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink();
                                } else {
                                  return Container();
                                }
                              },
                            );
                          } else {
                            return Column(
                              children: const [
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: CircularProgressIndicator(
                            backgroundColor: AppColor.signInPageBackgroundColor,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          )),
                        ],
                      );
                    }
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        child: Lottie.asset(
                            'assets/images/login_screen_lotte.json',
                            height: 250.0)),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.buttonColor,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0)),
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.manrope(
                              color: AppColor.signInPageBackgroundColor,
                              fontSize: 16),
                        ),
                      ),
                    )
                  ],
                );
              }
            }));
  }
}
