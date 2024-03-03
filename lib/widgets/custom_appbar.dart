import 'package:flutter/material.dart';
import '../screens/chat_screen/chat_room.dart';
import '../screens/search/search_screen.dart';
import '../utils/app_const.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.backgroundColor,
      title: Transform.translate(
          offset: const Offset(-20.0, 0.0),
          child: Image.asset(
            AppImage.iconWhite,
            height: 50.0,
          )// here you can put the search bar
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ));
            },
            icon: const Icon(Icons.search_rounded,size: 35.0,)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatRoom(),
                  ));
            },
            icon: Image.asset(
              'assets/images/chat.png',
              height: 35.0,
              width: 35.0,
              scale: 2,
            )),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }
}
