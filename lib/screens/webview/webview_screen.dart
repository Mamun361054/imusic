import 'dart:async';
import 'dart:io';
import 'package:dhak_dhol/screens/webview/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {

  final String url;

  const WebViewScreen({Key? key,required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        return _onBackPressed();
      },
      child: Scaffold(
          key: _globalKey,
          body: Stack(
            children: [
              WebView(
                onPageFinished: (s) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onWebResourceError: (e) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onPageStarted: (s) {
                  setState(() {
                    _isLoading = true;
                  });
                },
                onProgress: (s) {},
                onWebViewCreated: (WebViewController c) {
                  _controllerCompleter.future.then((value) => controller = value);
                  _controllerCompleter.complete(c);
                },
                gestureNavigationEnabled: true,
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) async {
                  return NavigationDecision.navigate;
                },
                javascriptChannels: <JavascriptChannel>{},
              ),
              Visibility(
                visible: _isLoading,
                child: const Center(
                  child: AdaptiveProgressIndicator(),
                ),
              )
            ],
          )),
    ));
  }


  Future<bool> _onBackPressed() async {
    WebViewController webViewController = await _controllerCompleter.future;
    bool canNavigate = await webViewController.canGoBack();
    if (canNavigate) {
      webViewController.goBack();
      return false;
    } else {
      //Return true means, the route will be popped by will pop scope.
      return true;
    }
  }
}
