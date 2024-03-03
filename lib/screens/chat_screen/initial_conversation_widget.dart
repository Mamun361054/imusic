import 'package:flutter/material.dart';

import '../../utils/app_const.dart';

class InitialConversationWidget extends StatelessWidget {

  final VoidCallback onBackPressed;

  const InitialConversationWidget({Key? key,required this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20),
                color: AppColor.signInPageBackgroundColor,
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      "Baddest Music Company advises you not to share any personal information or data with any one.",
                      style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          wordSpacing: 1.0,
                          letterSpacing: 1.0,
                          fontWeight:
                          FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Ensure you always remain anonymous",style: TextStyle(
                        color: Colors.white,
                        height: 1.5,
                        wordSpacing: 1.0,
                        letterSpacing: 1.0,
                        fontWeight:
                        FontWeight.bold),),
                    SizedBox(
                      height: 24.0,
                    ),
                  ],
                ),
              )),
          SizedBox(height: 20,),
          InkWell(
            onTap: onBackPressed,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text("I UNDERSTAND",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              )),
            ),
          )
        ],
      ),
    );
  }
}
