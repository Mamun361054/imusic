import 'dart:async';
import 'package:dhak_dhol/utils/TimUtil.dart';
import 'package:flutter/material.dart';
import '../../data/firebase_service/firebase_service.dart';


class OnlineOfflineView extends StatefulWidget {
  final String uid;

  const OnlineOfflineView({Key? key, required this.uid}) : super(key: key);

  @override
  State<OnlineOfflineView> createState() => _OnlineOfflineViewState();
}

class _OnlineOfflineViewState extends State<OnlineOfflineView> {
  Duration? duration;
  int? timeStamp;

  final onlineNotifier = ValueNotifier<int>(100);

  @override
  void initState() {
    super.initState();

    FirebaseService().getStatusAsStream(widget.uid).listen((snapshot) {
      timeStamp = snapshot.get('timestamp');
      duration = TimUtil.getTimeDifferenceDuration(timestamp: snapshot.get('timestamp'));
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeStamp != null) {
        duration = TimUtil.getTimeDifferenceDuration(timestamp: timeStamp!);
        print('duration.inSeconds ${duration!.inSeconds}');
        onlineNotifier.value = duration!.inSeconds;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: onlineNotifier,
      builder: (context, value, child) {
        return CircleAvatar(
          radius: 5.0,
          backgroundColor: value > 10 ? Colors.red : Colors.green,
        );
      },
    );
  }
}
