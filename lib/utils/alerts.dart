import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Alerts {
  static Future<void> show(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCupertinoAlert(context, title, message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
